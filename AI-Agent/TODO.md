# POS Supermarket — REST API TODO

> Backend only (`pos-supermarket/`). Tidak termasuk Angular frontend.
> Referensi lengkap: [AGENT.md](./AGENT.md) | Database: [table-ver2025.sql](./table-ver2025.sql)

---

## Status Legend

- [ ] Belum dikerjakan
- [x] Sudah selesai
- [~] Sedang dikerjakan / partial

---

## 1. Project Setup & Infrastructure

- [x] Express 5.x server setup (`server.js`)
- [x] MySQL connection pool (`config/database.js`)
- [x] Environment config (`config/env.js`)
- [x] Socket.IO init (`config/socket.js`)
- [x] Middleware: auth JWT (`middleware/auth.js`)
- [x] Middleware: role-based access (`middleware/role.js`)
- [x] Middleware: Zod validation (`middleware/validate.js`)
- [x] Middleware: global error handler (`middleware/errorHandler.js`)
- [x] Utils: standardized response (`utils/response.js`)
- [x] Health check endpoint `GET /api/health`

---

## 2. Authentication — `POST /api/auth/*` (F1)

- [x] `POST /api/auth/login` — Login cashier/supervisor (MD5 legacy)
- [x] `POST /api/auth/logout` — End session (invalidate token)
- [x] `GET /api/auth/me` — Get current authenticated user info
- [x] Auth service: findUserById, verifyMd5, createSession, invalidateSessions, generateToken
- [x] Auth schema: Zod validation (loginSchema)

---

## 3. Item / Barcode Lookup — `GET /api/item/*` (F2)

- [x] `GET /api/item/barcode/:barcode` — Lookup item by barcode scan
  - Query `item_barcode` → get `itemId` → fetch from `item`
  - Return: item detail + price + promotion info (jika ada)
- [x] `GET /api/item/:id` — Get item by article/SKU ID
- [x] `GET /api/item/search?q=` — Search items by description (LIKE query)
- [x] Item service: findByBarcode, findById, searchByDescription
- [x] Item schema: Zod validation

---

## 4. Cart / Active Transaction — `/api/cart/*` (F2)

- [ ] `POST /api/cart/start` — Start new transaction
  - Generate `kioskUuid` format: `{terminalId}.{YYMMDD}.{sequence}`
  - Insert ke `kiosk_uuid`
  - Auto-increment `auto_number` (id=302 untuk pos)
- [ ] `POST /api/cart/scan` — Scan barcode & add item to cart
  - Lookup barcode → item
  - Check active promotions (semua tipe promo)
  - Calculate price after discount
  - Insert ke `kiosk_cart`
  - Handle free item → `kiosk_cart_free_item`
  - Emit Socket.IO `cart:update`
- [ ] `GET /api/cart/:kioskUuid` — Get current cart items & totals
- [ ] `PUT /api/cart/item/:id` — Update cart item (qty, price edit, void)
  - Void item perlu supervisor auth (cek `user_func`)
- [ ] `DELETE /api/cart/item/:id` — Remove/void item from cart
- [ ] `PUT /api/cart/:kioskUuid/member` — Attach member to transaction
  - Lookup `member` by ID
  - Apply member discount (dari `account` id=99)
  - Recalculate semua item discount
  - Emit Socket.IO `member:attached`
- [ ] `DELETE /api/cart/:kioskUuid` — Cancel/clear entire cart
  - Emit Socket.IO `cart:clear`
- [ ] Cart service: createKioskUuid, addToCart, getCart, updateItem, voidItem, attachMember, clearCart
- [ ] Cart schema: Zod validation (scanSchema, updateItemSchema, dll)

---

## 5. Promotion Engine — `/api/promotion/*` (F3)

- [ ] `GET /api/promotion/check/:itemId` — Check active promotions for item
  - Filter by: active date range, day-of-week, status
  - Support semua tipe:
    - Type 0: Item-level discount (`promotion_item`) — disc1/disc2/disc3, specialPrice, discountPrice
    - Type 1: Buy-X-Get-Y Free (`promotion_free`)
    - Type 2: Buy-N-Get-Free (varian)
    - Type 3: Quantity-based discount (`promotion_discount`)
- [ ] `GET /api/promotion/fixed/:amount` — Check transaction-level promos (`promo_fixed`)
  - Cek `targetAmount` vs transaction amount
  - `isMultiple` logic (multiply benefit)
  - `ifAmountNearTarget` threshold message
- [ ] Promotion service: checkItemPromotion, checkTransactionPromo, applyDiscount, applyFreeItem
- [ ] Helper: calculateCascadingDiscount(price, disc1, disc2, disc3)
- [ ] Helper: checkDayOfWeek(promotion) — filter Mon-Sun flags

---

## 6. Member — `/api/member/*`

- [ ] `GET /api/member/:id` — Lookup member by ID
- [ ] `GET /api/member/search?q=` — Search member by name
- [ ] Member service: findById, search
- [ ] Member schema: Zod validation

---

## 7. Payment Processing — `/api/payment/*` (F4)

### 7a. Payment Types & Basic

- [ ] `GET /api/payment/types` — List available payment types (from `payment_type`)
- [ ] `POST /api/payment/add` — Add payment entry to active transaction
  - Insert ke `kiosk_paid_pos`
  - Support split payment (multiple entries per kioskUuid)
  - Validate: total paid tidak boleh melebihi finalPrice (kecuali CASH untuk kembalian)
- [ ] `DELETE /api/payment/:id` — Remove payment entry

### 7b. Finalize Transaction

- [ ] `POST /api/payment/finalize` — Complete & persist transaction
  - Move `kiosk_cart` → `transaction` + `transaction_detail`
  - Move `kiosk_paid_pos` → `transaction_payment`
  - Calculate: subTotal, discount, bkp, dpp, ppn, nonBkp, finalPrice
  - Rounding (method dari `account` id=100)
  - Update `balance` (cashIn, cashOut)
  - Generate transaction ID: `{cashierId}.{sequence}`
  - Update `auto_number`
  - Clear `kiosk_cart` & `kiosk_paid_pos`
  - Emit Socket.IO: `payment:complete`, `display:thankyou`, `cart:clear`

### 7c. EDC Integration

- [ ] `POST /api/payment/edc/send` — Send command to EDC device (serial port)
  - BCA ECR hex protocol
  - Log ke `payment_bca_ecr`
- [ ] `GET /api/payment/edc/status/:id` — Check EDC payment response

### 7d. QRIS Payment

- [ ] `POST /api/payment/qris/generate` — Generate QRIS QR code
  - BCA QRIS: ECR-based → log ke `payment_bca_qris`
  - Telkom QRIS: REST API call ke `qris.id` → log ke `payment_qris_telkom`
  - Emit Socket.IO `payment:qr` (untuk customer display)
- [ ] `GET /api/payment/qris/status/:id` — Poll QRIS payment status
  - Telkom: call `checkpaid_qris.php`

### 7e. Voucher

- [ ] `GET /api/voucher/:number` — Validate voucher
  - Cek `voucher`: exists, status=0 (unused), not expired
  - Return voucher amount
- [ ] Voucher service: validate, markUsed

### 7f. Payment Services & Schemas

- [ ] Payment service: getTypes, addPayment, removePayment, finalizeTransaction
- [ ] Payment schema: Zod validation (addPaymentSchema, finalizeSchema)
- [ ] Tax calculation helper: calculateTax(items, taxcodeConfig)

---

## 8. Transaction History — `/api/transaction/*`

- [ ] `GET /api/transaction/:id` — Get completed transaction header
- [ ] `GET /api/transaction/:id/detail` — Get transaction line items
- [ ] `GET /api/transaction/:id/payments` — Get transaction payment records
- [ ] `POST /api/transaction/:id/reprint` — Reprint receipt
  - Log ke `transaction_printlog`
  - Cek permission reprint di `user_func`
- [ ] `POST /api/transaction/:id/void` — Void transaction
  - Require supervisor authorization
  - Cek permission void di `user_func`
  - Reverse `balance` entries
- [ ] Transaction service: findById, getDetails, getPayments, reprint, voidTransaction

---

## 9. Refund & Exchange — `/api/refund/*`, `/api/exchange/*`

- [ ] `POST /api/refund` — Process refund
  - Create record di `refund`
  - Generate refund ID dari `auto_number` (id=303)
  - Require supervisor authorization
- [ ] `POST /api/exchange` — Process item exchange
  - Create record di `exchange`
  - Generate exchange ID dari `auto_number` (id=304)
- [ ] Refund service: processRefund
- [ ] Exchange service: processExchange

---

## 10. Daily Operations — `/api/daily/*` (F5)

- [ ] `POST /api/daily/open` — Daily start / opening
  - Create `settlement` record (generate ID: `{terminalId}SET{seq}`)
  - Record opening balance di `balance` (transactionId='_S1')
  - Update `auto_number` (id=301 untuk settlement)
- [ ] `POST /api/daily/close` — Daily close / settlement / Z-Report
  - Calculate summary: totalNumberOfCheck, summaryTotalVoid, overalitemSales, overalDiscount, overalNetSales, overalFinalPrice, overalTax
  - Insert `reset` record
  - Insert `reset_payment` breakdown per payment type
  - Close `settlement` record
  - Generate reset ID dari `auto_number` (id=220)
- [ ] `GET /api/daily/balance` — Get current cash balance
  - Sum `balance` where close=0
- [ ] `POST /api/daily/cash-drawer` — Trigger cash drawer open
  - ESC/POS command to thermal printer DK port
  - May require supervisor auth
- [ ] Daily service: openDay, closeDay, getBalance, openCashDrawer

---

## 11. Reports — `/api/report/*` (F8)

- [ ] `GET /api/report/daily?date=` — Daily sales summary
- [ ] `GET /api/report/settlement/:id` — Settlement report data
- [ ] `GET /api/report/z-report/:id` — Z-report detail

---

## 12. Print (EJS Views) — `/print/*`

- [ ] `GET /print/receipt/:transactionId` — Receipt HTML for thermal printer
  - Company info (dari `account` id=10,11,12)
  - Transaction items + discounts
  - Tax breakdown (BKP, DPP, PPN)
  - Payment method(s) & amounts
  - Footer message (dari `account` id=1007)
- [ ] `GET /print/z-report/:resetId` — Z-report HTML
- [ ] `GET /print/settlement/:settlementId` — Settlement report HTML
- [ ] EJS templates: receipt.ejs, z-report.ejs, settlement.ejs

---

## 13. Socket.IO Events (F6 — Customer Mirror Screen)

- [ ] Emit `cart:update` — saat item scan/remove/void
- [ ] Emit `cart:clear` — saat transaction selesai/cancel
- [ ] Emit `member:attached` — saat member card di-scan
- [ ] Emit `payment:start` — saat mulai payment
- [ ] Emit `payment:qr` — saat QR code generated
- [ ] Emit `payment:complete` — saat payment final
- [ ] Emit `promotion:applied` — saat promo triggered
- [ ] Emit `display:welcome` — idle / new transaction
- [ ] Emit `display:thankyou` — setelah payment selesai
- [ ] Emit `display:message` — custom message
- [ ] Listen `terminal:register` — [x] sudah ada
- [ ] Listen `terminal:heartbeat` — keep-alive

---

## 14. Config — `/api/config/*`

- [ ] `GET /api/config/account` — Get store configuration (dari `account`)
- [ ] `GET /api/config/terminal` — Get terminal info

---

## 15. Auto Number Generator

- [ ] Utility: generateAutoNumber(name) — generic auto-increment helper
  - Read current `runningNumber` dari `auto_number`
  - Increment + pad with `digit`
  - Prepend `prefix`
  - Update `runningNumber` dan `updateDate`
  - Used by: transaction, kiosk, settlement, reset, refund, exchange

---

## Urutan Prioritas Pengerjaan (Recommended)

| Priority | Module | Alasan |
|----------|--------|--------|
| 1 | **Auto Number Generator** (§15) | Dependency untuk semua ID generation |
| 2 | **Item Lookup** (§3) | Core — scan barcode adalah fungsi utama |
| 3 | **Cart / Active Transaction** (§4) | Core — mengelola transaksi aktif |
| 4 | **Promotion Engine** (§5) | Core — auto-apply saat scan item |
| 5 | **Member** (§6) | Untuk member discount |
| 6 | **Payment Processing** (§7a, 7b) | Core — payment CASH + finalize dulu |
| 7 | **Daily Operations** (§10) | Opening/closing shift |
| 8 | **Transaction History** (§8) | View & reprint receipt |
| 9 | **Print / EJS** (§12) | Receipt & report templates |
| 10 | **Socket.IO Events** (§13) | Customer mirror screen |
| 11 | **Reports** (§11) | Daily summary & Z-report |
| 12 | **Voucher** (§7e) | Voucher payment |
| 13 | **Config** (§14) | Store/terminal config |
| 14 | **EDC Integration** (§7c) | Hardware — BCA ECR serial |
| 15 | **QRIS Payment** (§7d) | QR payment integration |
| 16 | **Refund & Exchange** (§9) | Retur / tukar barang |
