const pool = require('../config/database');
const { success, error } = require('../utils/response');

function formatMysqlDatetime(value) {
	if (!value) {
		return null;
	}

	const date = value instanceof Date ? value : new Date(value);
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

function buildVoucherPayload(row, valid, reason) {
	return {
		valid,
		reason,
		voucherCode: row?.voucherCode || '',
		transactionId: row?.transactionId || '',
		voucherMinAmount: Number(row?.voucherMinAmount || 0),
		voucherAllowMultyple: Number(row?.voucherAllowMultyple || 0),
		voucherGiftAmount: Number(row?.voucherGiftAmount || 0),
		voucherExpDate: row?.voucherExpDate || null,
		status: Number(row?.status || 0),
		presence: Number(row?.presence || 0),
		inputDate: row?.inputDate || null,
		inputBy: row?.inputBy || null,
	};
}

function getVoucherInvalidReason(row) {
	if (!row) {
		return 'Voucher not found';
	}

	if (Number(row.presence) !== 1) {
		return 'Voucher is inactive';
	}

	if (Number(row.status) === 1) {
		return 'Voucher already used';
	}

	const expDate = row.voucherExpDate ? new Date(row.voucherExpDate) : null;
	if (expDate && !Number.isNaN(expDate.getTime()) && expDate.getTime() < Date.now()) {
		return 'Voucher has expired';
	}

	return null;
}

/**
 * GET /api/voucher/:voucherCode
 * Read-only validation before voucher is submitted for use.
 */
async function validateVoucher(req, res, next) {
	try {
		const voucherCode = String(req.params.voucherCode || '').trim().toUpperCase();
		if (!voucherCode) {
			return error(res, 'voucherCode is required', 400);
		}

		const [rows] = await pool.query(
			`SELECT id, transactionId, voucherCode, voucherMinAmount, voucherAllowMultyple,
							voucherGiftAmount, voucherExpDate, status, presence, inputDate, inputBy
			 FROM transaction_voucher
			 WHERE voucherCode = ?
			 LIMIT 1`,
			[voucherCode],
		);

		const voucher = rows[0] || null;
		const invalidReason = getVoucherInvalidReason(voucher);

		return success(
			res,
			buildVoucherPayload(voucher, !invalidReason, invalidReason),
			invalidReason || 'Voucher is valid',
		);
	} catch (err) {
		next(err);
	}
}

/**
 * POST /api/voucher/use
 * Mark voucher as used (status=1) and insert snapshot to voucher_log.
 */
async function useVoucher(req, res, next) {
	const conn = await pool.getConnection();

	try {
		const voucherCode = String(req.body?.voucherCode || '').trim().toUpperCase();
		const kioskUuid = String(req.body?.kioskUuid || '').trim();
		if (!voucherCode) {
			conn.release();
			return error(res, 'voucherCode is required', 400);
		}

		if (!kioskUuid) {
			conn.release();
			return error(res, 'kioskUuid is required', 400);
		}

		await conn.beginTransaction();

		const [rows] = await conn.query(
			`SELECT id, transactionId, voucherCode, voucherMinAmount, voucherAllowMultyple,
							voucherGiftAmount, voucherExpDate, status, presence, inputDate, inputBy
			 FROM transaction_voucher
			 WHERE voucherCode = ?
			 LIMIT 1
			 FOR UPDATE`,
			[voucherCode],
		);

		const voucher = rows[0] || null;
		if (!voucher) {
			await conn.rollback();
			conn.release();
			return error(res, 'Voucher not found', 404);
		}

		const invalidReason = getVoucherInvalidReason(voucher);
		if (invalidReason) {
			await conn.rollback();
			conn.release();
			return error(res, invalidReason, 400);
		}

		const nowDatetime = formatMysqlDatetime(new Date());
		const actorId = req.user?.userId || req.user?.id || voucher.inputBy || 'system';

		await conn.query(
			'UPDATE transaction_voucher SET status = 1 WHERE id = ?',
			[voucher.id],
		);

		await conn.query(
			`INSERT INTO voucher_log
				 (transactionId, voucherCode, voucherMinAmount, voucherAllowMultyple,
					voucherGiftAmount, voucherExpDate, status, presence, inputDate, inputBy)
			 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
			[
				voucher.transactionId,
				voucher.voucherCode,
				Number(voucher.voucherMinAmount || 0),
				Number(voucher.voucherAllowMultyple || 0),
				Number(voucher.voucherGiftAmount || 0),
				voucher.voucherExpDate,
				1,
				Number(voucher.presence || 1),
				nowDatetime,
				actorId,
			],
		);

		await conn.query(
			`INSERT INTO kiosk_paid_pos
				 (kioskUuid, paymentTypeId, paid, refCode, approvedCode, startDate, input_date, update_date)
			 VALUES (?, 'VOUCHER', ?, ?, ?, ?, ?, ?)`,
			[
				kioskUuid,
				Number(voucher.voucherGiftAmount || 0),
				voucher.voucherCode,
				voucher.voucherCode,
				nowDatetime,
				nowDatetime,
				nowDatetime,
			],
		);

		const [paymentRows] = await conn.query(
			`SELECT kp.id, kp.paymentTypeId, kp.paid, kp.refCode, kp.approvedCode, kp.input_date,
						pt.label AS paymentLabel, pt.name AS paymentName
			 FROM kiosk_paid_pos kp
			 LEFT JOIN payment_type pt ON pt.id = kp.paymentTypeId
			 WHERE kp.kioskUuid = ?
			 ORDER BY kp.id ASC`,
			[kioskUuid],
		);

		await conn.commit();
		conn.release();

		const totalPaid = paymentRows.reduce((sum, row) => sum + Number(row.paid || 0), 0);

		return success(
			res,
			{
				voucher: buildVoucherPayload(
					{
						...voucher,
						status: 1,
						inputDate: nowDatetime,
						inputBy: actorId,
					},
					true,
					null,
				),
				payments: paymentRows,
				totalPaid,
			},
			'Voucher marked as used',
		);
	} catch (err) {
		try {
			await conn.rollback();
		} catch (_rollbackErr) {
			// Ignore rollback error and surface the original error.
		}
		conn.release();
		next(err);
	}
}

module.exports = {
	validateVoucher,
	useVoucher,
};
