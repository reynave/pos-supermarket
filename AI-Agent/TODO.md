# POS Supermarket — REST API TODO

> Backend only (`pos-supermarket/`). Tidak termasuk Angular frontend.
> Referensi lengkap: [AGENT.md](./AGENT.md) | Database terbaru: [table-ver2026.sql](./table-ver2026.sql)

## Update Snapshot (2026-04-02)

- Cart core sudah berjalan dengan naming endpoint baru: `POST /api/cart/new`, `GET /api/cart/list/:kioskUuid`, `POST /api/cart/void/:kioskUuid`, `POST /api/cart/voidItem/:kioskUuid`.
- Scan/add item berjalan di namespace item: `POST /api/item/barcode`, `POST /api/item/add`, `POST /api/item/add-qty`.
- Daily close dedicated endpoint aktif: `GET/POST /api/daily-close/:resetId` dan report/history.
- Session harian runtime menggunakan `resetId` (alias kompatibilitas `settlementId` masih dipertahankan di beberapa endpoint).

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
  - [x] Dipakai oleh frontend startup setup (`/startup`) untuk test koneksi server

---

## 2. Authentication — `POST /api/auth/*` (F1)

- [x] `POST /api/auth/login` — Login cashier/supervisor (MD5 legacy)
- [x] `POST /api/auth/logout` — End session (invalidate token)
- [x] `GET /api/auth/me` — Get current authenticated user info
- [x] Auth service: findUserById, verifyMd5, createSession, invalidateSessions, generateToken
- [x] Auth schema: Zod validation (loginSchema)

---

## 3. Item / Barcode Lookup — `/api/item/*` (F2)

- [~] `GET /api/item/barcode/:barcode` — Lookup item by barcode scan
  - [x] Runtime implemented as `POST /api/item/barcode` (body: `kioskUuid`, `barcode`)
  - Query `item_barcode` → get `itemId` → fetch from `item`
  - Return: item detail + price + promotion info (jika ada)
- [~] `GET /api/item/:id` — Get item by article/SKU ID
  - [x] Runtime implemented as `POST /api/item/add` (body: `kioskUuid`, `itemId`)
- [x] `GET /api/item/search?q=` — Search items by description (LIKE query)
- [x] Item service: findByBarcode, findById, searchByDescription
- [x] Item schema: Zod validation

---

## 4. Cart / Active Transaction — `/api/cart/*` (F2)

- [~] `POST /api/cart/start` — Start new transaction
  - [x] Implemented as `POST /api/cart/new` (naming baru)
  - Generate `kioskUuid` format: `{terminalId}.{YYMMDD}.{sequence}`
  - [x] Insert ke `kiosk_uuid`
  - [x] Auto-increment `auto_number` (id=302 untuk pos)
- [~] `POST /api/cart/scan` — Scan barcode & add item to cart
  - [x] Implemented via `POST /api/item/barcode` (+ `POST /api/item/add`)
  - Lookup barcode → item
  - [ ] Check active promotions (semua tipe promo)
  - [ ] Calculate price after discount
  - [x] Insert ke `kiosk_cart`
  - [ ] Handle free item → `kiosk_cart_free_item`
  - [ ] Emit Socket.IO `cart:update`
- [x] `GET /api/cart/:kioskUuid` — Get current cart session info
- [x] `GET /api/cart/list/:kioskUuid` — Get current cart items & totals
- [~] `PUT /api/cart/item/:id` — Update cart item (qty, price edit, void)
  - [x] Partial: void item implemented via `POST /api/cart/voidItem/:kioskUuid`
  - [x] Partial: add qty implemented via `POST /api/item/add-qty`
  - [ ] Price edit belum ada endpoint khusus
  - Void item perlu supervisor auth (cek `user_func`)
- [~] `DELETE /api/cart/item/:id` — Remove/void item from cart
  - [x] Partial: implemented as `POST /api/cart/voidItem/:kioskUuid`
- [ ] `PUT /api/cart/:kioskUuid/member` — Attach member to transaction
  - Lookup `member` by ID
  - Apply member discount (dari `account` id=99)
  - Recalculate semua item discount
  - Emit Socket.IO `member:attached`
- [x] `DELETE /api/cart/:kioskUuid` — Cancel/clear entire cart
  - [x] Implemented as `POST /api/cart/void/:kioskUuid` (PIN verification + clear)
  - Emit Socket.IO `cart:clear`
- [~] Cart service: createKioskUuid, addToCart, getCart, updateItem, voidItem, attachMember, clearCart
  - [x] createKioskUuid, getCart, voidItem, clearCart
  - [ ] updateItem generic, attachMember
- [~] Cart schema: Zod validation (scanSchema, updateItemSchema, dll)
  - [x] create cart schema tersedia
  - [ ] schema update/attach member/void item belum distandardisasi penuh

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

- [x] `GET /api/payment/types` — List available payment types (from `payment_type`, filtered `isLock=1`)
- [x] `GET /api/payment/pending/:kioskUuid` — Get current paid entries from `kiosk_paid_pos`
- [x] `POST /api/payment/add` — Add payment entry to `kiosk_paid_pos`; returns updated list + totalPaid
  - Support split payment (multiple entries per kioskUuid)
- [x] `DELETE /api/payment/:id` — Remove payment entry from `kiosk_paid_pos`; returns updated list

### 7b. Finalize Transaction

- [x] `POST /api/payment/complete` — Complete & persist transaction
  - Read from `kiosk_paid_pos`, validate paid >= finalPrice
  - Delegate to existing `transactionService.createTransaction()` (atomic DB transaction)
  - Moves `kiosk_cart` → `transaction` + `transaction_detail`
  - Moves `kiosk_paid_pos` → `transaction_payment`
  - Updates `balance` (cashIn, cashOut)
  - [x] `transaction.resetId` now filled from active daily session (`reset.id`)
  - [x] `transaction.settlementId` no longer required from request payload
  - Generates transaction ID via `auto_number`
  - Clears `kiosk_cart` & `kiosk_paid_pos`
  - Files: `payment.service.js`, `payment.controller.js`, `payment.schema.js`, `payment.routes.js`

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

- [x] Payment service: getTypes, addPayment, removePayment, finalizeTransaction
- [x] Payment schema: Zod validation (addPaymentSchema, finalizeSchema)
- [ ] Tax calculation helper: calculateTax(items, taxcodeConfig)

---

## 8. Transaction History — `/api/transaction/*`

- [x] `GET /api/transactions/:id` — Get completed transaction for receipt/reprint (header + aggregated items + primary payment type)
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

- [~] `POST /api/shift/open` — Daily start / opening (current active endpoint)
  - [x] Generate `reset.id` via `auto_number` id=220
  - [x] Insert `reset` row for daily-start (`startDate`, `userIdStart`, `storeOutlesId`)
  - [x] Record opening balance di `balance` (`cashIn`) dengan `transactionId = resetId`
  - [x] Keep session active via `reset.endDate IS NULL`
- [~] `POST /api/shift/close/:resetId` — Daily close / EOD update
  - [x] Calculate summary: `totalTransaction`, `summaryTotalVoid`, `summaryTotalTransaction`, `summaryTotalCart`, `overalitemSales`, `overalDiscount`, `overalNetSales`, `overalFinalPrice`, `overalTax`
  - [x] Update existing `reset` row (daily-close fields: `endDate`, `userIdClose`, totals, note)
  - [x] Insert `reset_payment` breakdown per payment type
  - [x] `settlement` table flow is bypassed for POS runtime (reserved for ERP sync)
- [x] `GET /api/daily-close/:resetId` — Daily close summary endpoint (dedicated controller)
- [x] `POST /api/daily-close/:resetId` — Submit daily close
  - [x] Backfill `transaction.resetId` untuk transaksi yang masih kosong (by terminal + startDate)
  - [x] Recalculate dan update seluruh field agregat di `reset` dari `transaction`
  - [x] Close `balance` rows terkait sesi/reset
- [x] `GET /api/daily-close/report/:resetId` — Daily close report data
- [ ] `GET /api/daily/balance` — Get current cash balance
  - Sum `balance` where close=0
- [ ] `POST /api/daily/cash-drawer` — Trigger cash drawer open
  - ESC/POS command to thermal printer DK port
  - May require supervisor auth
- [ ] Daily service: openDay, closeDay, getBalance, openCashDrawer

- [x] `GET /api/manual-cash/summary/:terminalId?` — Get active session and current cash balance for manual cash-in screen
- [x] `POST /api/manual-cash/add` — Add manual cash in (insert `balance.cashIn` on active reset)
- [x] `POST /api/manual-cash/open-drawer` — Open cash drawer command endpoint (placeholder response for hardware integration)

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
- [x] Listen `terminal:register`
- [ ] Listen `terminal:heartbeat` — keep-alive

---

## 14. Config — `/api/config/*`

- [ ] `GET /api/config/account` — Get store configuration (dari `account`)
- [ ] `GET /api/config/terminal` — Get terminal info

---

## 15. Auto Number Generator

- [~] Utility: generateAutoNumber(name) — generic auto-increment helper
  - [x] Partial: sudah ada implementasi spesifik di service (`auto_number` id=200/220/302)
  - [ ] Belum dijadikan helper generik reusable lintas modul
  - Read current `runningNumber` dari `auto_number`
  - Increment + pad with `digit`
  - Prepend `prefix`
  - Update `runningNumber` dan `updateDate`
  - Used by: transaction, kiosk, settlement, reset, refund, exchange

---

## Fitur Wajib Ditambah (Rekomendasi AI)

### A. Security & Data Integrity (High Priority)

- [ ] Migrasi hash login/pin dari MD5 ke bcrypt + strategi backward-compatible migration saat login.
- [ ] Hardening SQL query raw (hindari string interpolation), terutama validasi PIN.
- [ ] Idempotency key untuk `POST /api/payment/complete` agar tidak double-post saat jaringan tidak stabil.
- [ ] Standardisasi permission check supervisor (`user_func`) untuk void/reprint/refund di semua endpoint sensitif.

### B. Operasional POS (High Priority)

- [ ] Endpoint `GET /api/daily/balance` agar screen cash balance tidak tergantung kalkulasi lokal.
- [ ] Integrasi real hardware cash drawer + printer status (bukan placeholder) dan fallback aman jika device offline.
- [ ] Endpoint transaksi detail/pembayaran (`/detail`, `/payments`) untuk audit yang lengkap.

### C. Observability & Reliability (Medium Priority)

- [ ] Structured logging + correlation id per request/transaction.
- [ ] Healthcheck diperluas (`/api/health`) mencakup DB readiness + version info.
- [ ] Contract test minimal untuk endpoint kritikal: shift open/close, cart, payment complete.

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
