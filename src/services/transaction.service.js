const pool = require('../config/database');
const fs = require('fs/promises');
const path = require('path');
const Handlebars = require('handlebars');
const { generateAutoNumber } = require('../utils/autoNumber');

const TEMPLATE_DIR = path.join(__dirname, '..', '..', 'public', 'template');

Handlebars.registerHelper('currencyIdr', (value) => {
  const amount = Number(value || 0);
  return new Intl.NumberFormat('id-ID', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
});

Handlebars.registerHelper('formatLine', (leftText, rightText, width = 48) => {
  const left = String(leftText || '');
  const right = String(rightText || '');
  const lineWidth = Number(width) || 48;
  const space = Math.max(1, lineWidth - left.length - right.length);

  return left + ' '.repeat(space) + right;
});

Handlebars.registerHelper('formatItemLeft', (qty, name) => {
  return `${qty || 0} x ${String(name || '')}`.trim();
});

Handlebars.registerHelper('formatDateTime', (value) => {
  if (!value) {
    return '';
  }

  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) {
    return String(value);
  }

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
});

Handlebars.registerHelper('formatDateOnly', (value) => {
  if (!value) {
    return '';
  }

  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) {
    return String(value);
  }

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
});

function normalizeTemplateName(templateName) {
  const fileName = path.basename(templateName || 'bill.hbs');
  return fileName.endsWith('.hbs') ? fileName : `${fileName}.hbs`;
}

function formatMysqlDatetime(value) {
  if (!value) {
    return null;
  }

  const normalizedValue = typeof value === 'string' && /^\d{4}-\d{2}-\d{2}$/.test(value)
    ? `${value} 00:00:00`
    : value;

  const date = normalizedValue instanceof Date ? normalizedValue : new Date(normalizedValue);
  if (Number.isNaN(date.getTime())) {
    return null;
  }

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

async function renderReceiptTemplate(payload, templateName = 'bill.hbs') {
  const safeTemplateName = normalizeTemplateName(templateName);
  const templatePath = path.join(TEMPLATE_DIR, safeTemplateName);
  const source = await fs.readFile(templatePath, 'utf8');
  const template = Handlebars.compile(source);
  return template(payload);
}

/**
 * Generate a new transaction ID using auto_number id=200.
 * Format: {cashierId}.{padded_runningNumber}
 * e.g. 123123.0131
 */
async function generateTransactionId(cashierId, conn) {
  const autoNumberId = 200;

  const [rows] = await conn.query(
    'SELECT digit, runningNumber FROM auto_number WHERE id = ? FOR UPDATE',
    [autoNumberId],
  );
  if (!rows[0]) throw new Error('auto_number id=200 not found');

  const { digit, runningNumber } = rows[0];
  const nextNumber = runningNumber + 1;

  await conn.query(
    'UPDATE auto_number SET runningNumber = ?, updateDate = UNIX_TIMESTAMP() WHERE id = ?',
    [nextNumber, autoNumberId],
  );

  const padded = String(nextNumber).padStart(digit, '0');
  return `${cashierId}.${padded}`;
}

/**
 * Read kiosk_cart items + item details for a kioskUuid.
 * Returns individual rows (one per scanned unit).
 */
async function getCartItemsForPayment(kioskUuid, conn) {
  const [rows] = await conn.query(
    `SELECT
       kc.id AS cartRowId,
       kc.itemId,
       kc.barcode,
       kc.price,
       kc.discount,
       i.description,
       i.shortDesc,
       i.price1 AS originPrice,
       i.ppnFlag,
       i.itemTaxId
     FROM kiosk_cart kc
     INNER JOIN item i ON i.id = kc.itemId
     WHERE kc.kioskUuid = ?
       AND kc.presence = 1
       AND kc.void = 0
     ORDER BY kc.inputDate ASC`,
    [kioskUuid],
  );
  return rows;
}

async function getDrawerPaymentTypeIds(paymentTypeIds, conn) {
  if (!paymentTypeIds.length) {
    return new Set();
  }

  const placeholders = paymentTypeIds.map(() => '?').join(', ');
  const [rows] = await conn.query(
    `SELECT id
     FROM payment_type
     WHERE openCashDrawer = 1
       AND presence = 1
       AND status = 1
       AND id IN (${placeholders})`,
    paymentTypeIds,
  );

  return new Set(rows.map((row) => row.id));
}

/**
 * Create a full transaction: header + details + payments + balance.
 * All within a single DB transaction for atomicity.
 *
 * @param {Object} params
 * @param {string} params.kioskUuid
 * @param {string} params.cashierId
 * @param {string} params.terminalId
 * @param {string} params.resetId
 * @param {string} params.storeOutletId
 * @param {Array}  params.payments - [{ paymentTypeId: 'CASH'|'DEBITCC'|'QRIS', amount, reference?, approvedCode? }]
 * @param {number} [params.cashReceived] - actual cash tendered (for CASH)
 * @param {Object|null} [params.voucherPromotion] - result of checkVoucherPromotion()
 */
async function createTransaction({
  kioskUuid,
  cashierId,
  terminalId,
  resetId,
  storeOutletId,
  payments,
  cashReceived,
  voucherPromotion = null,
}) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    // 1. Generate transaction ID
    const transactionId = await generateTransactionId(cashierId, conn);

    // 2. Read items from kiosk_cart
    const cartItems = await getCartItemsForPayment(kioskUuid, conn);
    if (!cartItems.length) {
      throw new Error('Cart is empty — no items to process');
    }

    const PPN_RATE = 11;
    const nowEpoch = Math.floor(Date.now() / 1000);
    const nowDatetime = new Date().toISOString().slice(0, 19).replace('T', ' ');
    const drawerPaymentTypeIds = await getDrawerPaymentTypeIds(
      payments.map((payment) => payment.paymentTypeId),
      conn,
    );
    const drawerPayment = payments.find((payment) => drawerPaymentTypeIds.has(payment.paymentTypeId));

    // 3. Calculate totals from actual cart data
    let subTotal = 0;
    let totalDiscount = 0;
    let totalBkp = 0;
    let totalDpp = 0;
    let totalPpn = 0;

    for (const item of cartItems) {
      const price = item.price || 0;
      const discount = item.discount || 0;
      const hasTax = item.ppnFlag === 1 || String(item.itemTaxId) === '2';
      const netPrice = price - discount;

      subTotal += price;
      totalDiscount += discount;

      if (hasTax) {
        // DPP = price before tax, BKP = taxable amount, PPN = tax
        totalDpp += netPrice;
        totalBkp += netPrice;
        totalPpn += Math.round(netPrice * (PPN_RATE / 100));
      }
    }

    const grandTotal = subTotal - totalDiscount + totalPpn;
    const finalPrice = grandTotal;

    // 4. INSERT transaction header
    await conn.query(
      `INSERT INTO \`transaction\`
         (id, transactionDate, transaction_date, kioskUuid, resetId, settlementId,
          storeOutlesId, terminalId, struk, total, locked,
          startDate, endDate, cashierId, pthType,
          subTotal, discount, discountMember, voucher,
          bkp, dpp, ppn, nonBkp, finalPrice,
          cashDrawer, printing, presence,
          inputDate, input_date, updateDate, update_date)
       VALUES (?, ?, ?, ?, ?, '',
               ?, ?, ?, ?, 1,
               '2023-01-01 00:00:00.000', ?, ?, 1,
               ?, ?, 0, 0,
               ?, ?, ?, 0, ?,
               ?, 1, 1,
               ?, ?, ?, ?)`,
      [
        transactionId, nowEpoch, nowDatetime, kioskUuid, resetId || null,
        storeOutletId || 'Comingsoon', terminalId, transactionId, grandTotal,
        nowDatetime, cashierId,
        subTotal, totalDiscount,
        totalBkp, totalDpp, totalPpn, finalPrice,
        drawerPayment ? 1 : 0,
        nowEpoch, nowDatetime, nowEpoch, nowDatetime,
      ],
    );

    // 5. INSERT transaction_detail — one row per cart item
    for (const item of cartItems) {
      await conn.query(
        `INSERT INTO transaction_detail
           (transactionId, promotionId, itemId, barcode,
            originPrice, price, discount,
            isPrintOnBill, presence, inputDate, updateDate)
         VALUES (?, '0', ?, ?,
                 ?, ?, ?,
                 1, 1, ?, ?)`,
        [
          transactionId, item.itemId, item.barcode || item.itemId,
          item.originPrice || item.price, item.price, item.discount || 0,
          nowEpoch, nowEpoch,
        ],
      );
    }

    // 6. INSERT transaction_payment — one row per payment method
    for (const pmt of payments) {
      await conn.query(
        `INSERT INTO transaction_payment
           (transactionId, paymentTypeId, paymentNameId, amount,
            approvedCode, refCode, presence,
            inputDate, updateDate, input_date, update_date)
         VALUES (?, ?, '', ?,
                 ?, ?, 1,
                 ?, ?, ?, ?)`,
        [
          transactionId, pmt.paymentTypeId, pmt.amount,
          pmt.approvedCode || '', pmt.reference || '',
          nowEpoch, nowEpoch, nowDatetime, nowDatetime,
        ],
      );
    }

    // 7. INSERT balance row (for CASH payment — tracks physical cash flow)
    if (drawerPayment) {
      const cashIn = cashReceived || drawerPayment.amount;
      const change = Math.max(0, cashIn - grandTotal);
      const cashOut = change > 0 ? -change : 0;

      await conn.query(
        `INSERT INTO balance
           (resetId, cashIn, cashOut, transactionId, kioskUuid,
            cashierId, terminalId, settlementId, close, input_date)
         VALUES (?, ?, ?, ?, ?,
                 ?, ?, '', 0, ?)` ,
        [
          resetId || '', cashIn, cashOut, transactionId, kioskUuid,
          cashierId, terminalId, nowDatetime,
        ],
      );
    }

    // 8. Mark kiosk session as completed (status=0)
    await conn.query(
      'UPDATE kiosk_uuid SET status = 0, update_date = ? WHERE kioskUuid = ?',
      [nowDatetime, kioskUuid],
    );

    // 9. Save voucher reward snapshot for this transaction if promotion matched.
    if (voucherPromotion && Number(voucherPromotion.giftAmount || 0) > 0) {
      const voucherExpDate = formatMysqlDatetime(voucherPromotion.voucherExpDate);
      const voucherCode = await generateAutoNumber('voucherCode', conn);

      await conn.query(
        `INSERT INTO transaction_voucher
           (transactionId, voucherCode, voucherMinAmount, voucherAllowMultyple,
            voucherGiftAmount, voucherExpDate, status, presence, inputDate, inputBy)
         VALUES (?, ?, ?, ?, ?, ?, 0, 1, ?, ?)`,
        [
          transactionId,
          voucherCode,
          Number(voucherPromotion.voucherMinAmount || 0),
          Number(voucherPromotion.voucherAllowMultyple || 0),
          Number(voucherPromotion.giftAmount || 0),
          voucherExpDate,
          nowDatetime,
          cashierId,
        ],
      );
    }

    await conn.commit();

    // Return data matching the frontend Transaction model
    return {
      id: transactionId,
      cashierId,
      terminalId,
      subtotal: subTotal,
      tax: totalPpn,
      discount: totalDiscount,
      grandTotal,
      voucher: voucherPromotion
        ? {
            promotionId: voucherPromotion.promotionId,
            promotionDescription: voucherPromotion.promotionDescription,
            giftAmount: Number(voucherPromotion.giftAmount || 0),
            expDate: voucherPromotion.voucherExpDate,
          }
        : null,
      status: 1,
      inputDate: nowDatetime,
    };
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

/**
 * List transactions for a given date with pagination.
 * @param {string} date - YYYY-MM-DD
 * @param {number} page - 1-based page number
 * @param {number} limit - items per page
 */
async function listTransactions(date, page, limit, options = {}) {
  const { includeReceiptHtml = false, templateName = 'bill.hbs' } = options;
  const offset = (page - 1) * limit;

  // Count total for the date
  const [countRows] = await pool.query(
    `SELECT COUNT(*) AS total
     FROM \`transaction\`
     WHERE DATE(transaction_date) = ?
       AND presence = 1`,
    [date],
  );
  const total = countRows[0]?.total || 0;

  // Get paginated list with primary payment type
  const [rows] = await pool.query(
    `SELECT
       t.id,
       t.cashierId,
       t.terminalId,
       t.subTotal AS subtotal,
       t.ppn AS tax,
       t.discount,
       t.total AS grandTotal,
       CASE
         WHEN tp.paymentTypeId = 'CASH' THEN 1
         WHEN tp.paymentTypeId IN ('DEBITCC', 'EDC_MANDIRI') THEN 2
         WHEN tp.paymentTypeId = 'QRIS' THEN 3
         ELSE 0
       END AS status,
       t.transaction_date AS inputDate
     FROM \`transaction\` t
     LEFT JOIN transaction_payment tp ON tp.transactionId = t.id
       AND tp.presence = 1
       AND tp.id = (
         SELECT tp2.id FROM transaction_payment tp2
         WHERE tp2.transactionId = t.id AND tp2.presence = 1
         AND tp2.paymentTypeId NOT IN ('DISC.BILL')
         ORDER BY tp2.amount DESC LIMIT 1
       )
     WHERE DATE(t.transaction_date) = ?
       AND t.presence = 1
     ORDER BY t.transactionDate DESC
     LIMIT ? OFFSET ?`,
    [date, limit, offset],
  );

  if (!includeReceiptHtml) {
    return { items: rows, total };
  }

  const itemsWithReceipt = await Promise.all(
    rows.map(async (row) => {
      const detail = await getTransactionById(row.id, {
        includeReceiptHtml: true,
        templateName,
      });

      return {
        ...row,
        receiptHtml: detail?.receiptHtml || '',
      };
    }),
  );

  return { items: itemsWithReceipt, total };
}

/**
 * Get one completed transaction with aggregated item lines for receipt/reprint.
 * @param {string} id
 */
async function getTransactionById(id, options = {}) {
  const { includeReceiptHtml = false, templateName = 'bill.hbs' } = options;
  const [headerRows] = await pool.query(
    `SELECT
       t.id,
       t.cashierId,
       t.terminalId,
       t.subTotal AS subtotal,
       t.ppn AS tax,
       t.discount,
       t.total AS grandTotal,
       t.transaction_date AS inputDate
     FROM \`transaction\` t
     WHERE t.id = ?
       AND t.presence = 1
     LIMIT 1`,
    [id],
  );

  const transaction = headerRows[0] || null;
  if (!transaction) return null;

  const [itemRows] = await pool.query(
    `SELECT
       MIN(td.id) AS lineId,
       td.itemId,
       COALESCE(MAX(i.description), td.itemId) AS name,
       COALESCE(MAX(td.barcode), td.itemId) AS barcode,
       COUNT(*) AS qty,
       ROUND(AVG(td.price), 2) AS price,
       ROUND(SUM(td.discount), 2) AS discount,
       0 AS tax,
       ROUND(SUM(td.price - td.discount), 2) AS total,
       COALESCE(MAX(iu.name), 'PCS') AS uom
     FROM transaction_detail td
     LEFT JOIN item i ON i.id = td.itemId
     LEFT JOIN item_uom iu ON iu.id = i.itemUomId
     WHERE td.transactionId = ?
       AND td.presence = 1
     GROUP BY td.itemId
     ORDER BY MIN(td.id) ASC`,
    [id],
  );

  const items = itemRows.map((r) => ({
    id: String(r.lineId),
    itemId: r.itemId,
    name: r.name,
    barcode: r.barcode,
    qty: Number(r.qty || 0),
    price: Number(r.price || 0),
    discount: Number(r.discount || 0),
    tax: Number(r.tax || 0),
    total: Number(r.total || 0),
    uom: r.uom || 'PCS',
  }));

  const [paymentRows] = await pool.query(
    `SELECT
       tp.id,
       tp.paymentTypeId,
       COALESCE(pt.label, tp.paymentTypeId) AS paymentLabel,
       COALESCE(pt.name, tp.paymentTypeId) AS paymentName,
       ROUND(tp.amount, 2) AS amount,
       tp.refCode AS reference,
       tp.approvedCode
     FROM transaction_payment tp
     LEFT JOIN payment_type pt ON pt.id = tp.paymentTypeId
     WHERE tp.transactionId = ?
       AND tp.presence = 1
       AND tp.paymentTypeId NOT IN ('DISC.BILL')
     ORDER BY tp.amount DESC, tp.id ASC`,
    [id],
  );

  const [voucherRows] = await pool.query(
    `SELECT
       id,
       transactionId,
       voucherMinAmount,
       voucherAllowMultyple,
       voucherGiftAmount,
       voucherExpDate,
       inputDate,
       inputBy
     FROM transaction_voucher
     WHERE transactionId = ?
     ORDER BY id ASC`,
    [id],
  );

  const [printLogRows] = await pool.query(
    `SELECT COUNT(*) AS totalPrintLog
     FROM transaction_printlog
     WHERE transactionId = ?`,
    [id],
  );

  const paymentMethods = paymentRows.map((row) => ({
    id: Number(row.id),
    paymentTypeId: row.paymentTypeId,
    paymentLabel: row.paymentLabel,
    paymentName: row.paymentName,
    amount: Number(row.amount || 0),
    reference: row.reference || '',
    approvedCode: row.approvedCode || '',
  }));

  const primaryPaymentTypeId = paymentMethods[0]?.paymentTypeId || 'CASH';

  const vouchers = voucherRows.map((row) => ({
    id: Number(row.id),
    transactionId: row.transactionId,
    voucherMinAmount: Number(row.voucherMinAmount || 0),
    voucherAllowMultyple: Number(row.voucherAllowMultyple || 0),
    voucherGiftAmount: Number(row.voucherGiftAmount || 0),
    voucherExpDate: row.voucherExpDate,
    inputDate: row.inputDate,
    inputBy: row.inputBy,
  }));

  const totalPrintLog = Number(printLogRows[0]?.totalPrintLog || 0);
  const isCopyReceipt = totalPrintLog > 1;

  const result = {
    transaction: {
      ...transaction,
      cashierName: transaction.cashierId,
      status: 1,
    },
    items,
    paymentMethods,
    vouchers,
    totalPrintLog,
    isCopyReceipt,
    primaryPaymentTypeId,
  };

  if (includeReceiptHtml) {
    result.receiptHtml = await renderReceiptTemplate(result, templateName);
  }

  return result;
}

module.exports = {
  createTransaction,
  listTransactions,
  getTransactionById,
};
