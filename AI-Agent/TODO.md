# POS Supermarket — REST API TODO

> Backend only (`pos-supermarket/`). Tidak termasuk Angular frontend.
> Referensi lengkap: [AGENT.md](./AGENT.md) | Database terbaru: [table-ver2026.sql](./table-ver2026.sql)

## Update Snapshot (2026-04-08)

- Cart core sudah berjalan dengan naming endpoint baru: `POST /api/cart/new`, `GET /api/cart/list/:kioskUuid`, `POST /api/cart/void/:kioskUuid`, `POST /api/cart/voidItem/:kioskUuid`.
- Scan/add item berjalan di namespace item: `POST /api/item/barcode`, `POST /api/item/add`, `POST /api/item/add-qty`.
- Daily close dedicated endpoint aktif: `GET/POST /api/daily-close/:resetId` dan report/history.
- Session harian runtime menggunakan `resetId` (alias kompatibilitas `settlementId` masih dipertahankan di beberapa endpoint).
- Receipt preview support: `GET /api/transactions/:id` dapat mengembalikan `receiptHtml` hasil render template Handlebars dari `public/template/*.hbs` (default `bill.hbs`, query: `renderReceiptHtml=true&template=`).
- Promotion engine untuk add-to-cart sudah aktif untuk `promotion_item` dan `promotion_discount`, termasuk prioritas header/detail discount dan simpan `promotionId` + `promotionItemId` ke `kiosk_cart`.
- Filter promo header sudah menyesuaikan kolom `promotion.startDate` / `endDate` bertipe `DATETIME` dengan perbandingan `NOW()`.
- `GET /api/cart/list/:kioskUuid` sudah mengembalikan `promotionId`, `promotionItemId`, dan `promotionName` per baris cart.
- Payment type settings API sudah aktif: `GET /api/payment/types/all`, `GET /api/payment/types/:id`, `PUT /api/payment/types/:id`.
- Auto number helper generik sudah tersedia di `src/utils/autoNumber.js` dan sudah dipakai untuk generate `voucherCode`.
- API voucher sudah aktif: validasi read-only `GET /api/voucher/:voucherCode` dan submit `POST /api/voucher/use`.
- Submit voucher sukses sekarang juga insert payment type `VOUCHER` ke `kiosk_paid_pos` dengan `approvedCode = voucherCode`.

---

## Sprint Plan 1 Minggu (Execution-Ready)

Tujuan sprint ini: memastikan alur inti kasir stabil, aman, dan siap operasional harian.

### Target Outcome Sprint (End of Week)

- Finalisasi pembayaran aman dari double-submit / duplicate transaksi.
- API saldo kas harian tersedia dan konsisten dengan data operasional.
- Data audit transaksi (detail item + payment breakdown) tersedia untuk recheck/reprint.
- Gap keamanan SQL raw kritikal ditutup.
- Test kontrak minimal untuk endpoint paling kritikal tersedia.

### Item Sprint (Prioritas + Detail Eksekusi)

#### SP1-01 (P0) Idempotency & Race Guard untuk Payment Complete

- [ ] Status: Not Started
- Scope:
  - Tambah mekanisme idempotency key di `POST /api/payment/complete`.
  - Cegah duplicate finalize saat request di-retry atau tombol dibuka berulang.
  - Tambah lock/guard pada fase baca `kiosk_paid_pos` -> tulis `transaction*`.
- Output teknis:
  - Skema penyimpanan key (header/body) + lifecycle TTL/cleanup.
  - Response konsisten untuk repeated request dengan key sama.
  - Log event idempotent hit/miss.
- Definition of Done:
  - Request sama (key sama) tidak membuat transaksi kedua.
  - Beban test paralel tidak menghasilkan duplicate transaction ID.
  - Dokumentasi kontrak request-response idempotency tersedia.
- Dependency:
  - `payment.controller.js`, `payment.service.js`, `transaction.service.js`.
- Risiko:
  - Jika lock tidak tepat, bisa menambah latency atau deadlock.

#### SP1-02 (P0) Endpoint Daily Balance Operasional

- [ ] Status: Not Started
- Scope:
  - Implement `GET /api/daily/balance` by `terminalId` + active `resetId`.
  - Formula saldo harus sama dengan penggunaan layar cash balance.
- Output teknis:
  - Payload saldo ringkas + komponen pembentuk (opening, cashIn, cashOut, net).
  - Filter query untuk sesi aktif dan fallback jika tidak ada sesi.
- Definition of Done:
  - Nilai saldo API sama dengan query manual DB untuk sampel data hari itu.
  - Endpoint aman dipakai frontend tanpa kalkulasi lokal tambahan.
- Dependency:
  - Tabel `balance`, `reset`, endpoint `shift/active` atau lookup active reset.
- Risiko:
  - Perbedaan interpretasi opening/manual cash in bila rule belum disepakati.

#### SP1-03 (P0) Audit Endpoint Transaction Detail & Payments

- [ ] Status: Not Started
- Scope:
  - Tambah `GET /api/transaction/:id/detail`.
  - Tambah `GET /api/transaction/:id/payments`.
- Output teknis:
  - Detail item per transaksi dengan qty/discount/price/void flag.
  - Breakdown pembayaran multi payment untuk audit/rekonsiliasi.
- Definition of Done:
  - Kedua endpoint mengembalikan data valid untuk transaksi lama dan baru.
  - Receipt/reprint flow bisa mengandalkan endpoint ini untuk verifikasi.
- Dependency:
  - `transaction_detail`, `transaction_payment`, `transaction`.
- Risiko:
  - Data legacy mungkin tidak seragam antar periode dump.

#### SP1-04 (P1) Security Quick Win: SQL Parameterization

- [ ] Status: Not Started
- Scope:
  - Refactor query raw berbasis string interpolation (prioritas: verify PIN).
  - Ganti ke query parameterized di path kritikal.
- Output teknis:
  - Daftar query yang sudah di-hardening.
  - Catatan review area raw SQL tersisa.
- Definition of Done:
  - Tidak ada user input langsung masuk SQL string di endpoint kritikal sprint ini.
  - Lolos test fungsi existing (void flow, auth terkait).
- Dependency:
  - `cart.service.js` (verify pin), service lain yang pakai query raw.
- Risiko:
  - Refactor cepat tanpa test bisa memicu regresi logika validasi.

#### SP1-05 (P1) Contract Test Minimal Endpoint Kritis

- [ ] Status: Not Started
- Scope:
  - Buat test kontrak untuk:
    - `POST /api/shift/open`
    - `POST /api/payment/complete`
    - `POST /api/daily-close/:resetId`
- Output teknis:
  - Skenario success + failure utama.
  - Script test yang bisa dipakai CI/smoke lokal.
- Definition of Done:
  - Semua skenario prioritas lulus di local pipeline.
  - Test mendeteksi minimal 1 kasus duplicate/invalid payload.
- Dependency:
  - Data seed minimal untuk flow transaksi.
- Risiko:
  - Tanpa seed data konsisten, test jadi flaky.

### Rencana Hari per Hari (Suggested)

- [ ] Day 1: SP1-01 desain + implementasi inti idempotency.
- [ ] Day 2: SP1-01 hardening + SP1-02 implement endpoint daily balance.
- [ ] Day 3: SP1-03 implement transaction detail/payments.
- [ ] Day 4: SP1-04 SQL hardening + bugfix regresi.
- [ ] Day 5: SP1-05 contract test + full smoke run + sprint review notes.

### Handover Notes untuk Team & AI Agent Lain

- Gunakan istilah `resetId` sebagai session key utama; `settlementId` hanya alias kompatibilitas.
- Saat update endpoint, dokumentasikan request/response final di file ini agar tidak terjadi mismatch frontend-backend.
- Jika ada perubahan query finansial, wajib sertakan contoh hitung manual kecil (1 transaksi cash, 1 split payment) di PR description.
- Semua perubahan di domain payment dan daily-close harus dianggap high risk: wajib ada test atau langkah reproduksi manual.

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

### 3.1 Discount percent & Amount
- [x] table header promotion ini global, 1st priority, type promo aktif: `promotion_item` dan `promotion_discount`
- [x] promotion detail item discount sudah diterapkan via `promotion_item`
- [x] jika percent diisi, maka amount tidak berlaku lagi
- [x] prioritas perhitungan diskon: `header_percent` -> `header_amount` -> `disc1/disc2/disc3` -> `detail_amount` -> `special_price`
- [x] lookup promo sudah dipisah 2 query: `promotion_item` dulu, lalu `promotion` header
- [x] filter tanggal promo memakai `DATETIME` (`NOW()`) dan tetap cek flag hari + outlet
- [x] Promotion discount pertahap  20% + 30% 

### 3.2 Promotion buy 1 get 1  [buy N get xN]
> Status: [x] DONE — 2026-04-09 (API re-check)
- [x] table header promotion ini global, 1st priority, promotion Id = 'promotion_free'
- [x] promotion_free for detail 
- [x] Logic summary (buy N get xN)
  - Header filter: `promotion.typeOfPromotion = promotion_free`, aktif by date/day/outlet, prioritas outlet spesifik lalu `startDate` terbaru.
  - Detail source: `promotion_free` (`id`, `promotionId`, `itemId`, `qty`, `freeItemId`, `freeQty`, `applyMultiply`, `scanFree`, `printOnBill`).
  - Entitlement formula:
    - `applyMultiply = 1`: `floor(paidQty / qty) * freeQty`
    - `applyMultiply = 0`: jika `paidQty >= qty` maka `freeQty`, selain itu `0`
  - Saat add item trigger: hitung entitlement, bandingkan dengan existing free item, insert delta free item ke `kiosk_cart`.
  - Free row di `kiosk_cart`:
    - `price = 0`
    - `originPrice = harga asli free item`
    - `discount = 0`
    - `promotionId = header promotion id`
    - `promotionFreeId = promotion_free.id`
    - `isFreeItem = 1` (atau nilai penanda free item konsisten sistem)
  - Saat void/delete item trigger: pakai algoritma delete-all + reinsert qty sisa agar promo dihitung ulang dari nol (setara add barcode ulang), termasuk promo discount/header.
  - Anti-loop: item free tidak boleh dihitung sebagai trigger entitlement berikutnya.
  - Reconcile point aktif di flow add item & add qty; flow void item sekarang hard delete + add ulang qty sisa.
  - API terkait yang sudah aktif: `POST /api/item/barcode`, `POST /api/item/add`, `POST /api/item/add-qty`, `POST /api/cart/voidItem/:kioskUuid`, `GET /api/cart/list/:kioskUuid`.
  - Payload cart list sudah expose marker free item: `promotionFreeId`, `isFreeItem`, `originPrice`, `totalOriginPrice`.
 
### 3.3 Promotion voucher min total X get voucher y
> Status: [x] DONE — 2026-04-09 (API re-check)
- [x] voucher belanja untuk minimum total belanjaan sebesar x ( x >= requiredVoucherMinAmount), maka customer akan mendapakan voucher belanja sebesar y, dan bisa juga berkelipatan, jika belajanja 2x maka mendapankan 2y
- [x] global promotion, typeOfPromotion = `voucher`
- [x] Jika belanja >= requiredVoucherMinAmount, maka mendapatkan voucher senilai voucherGiftAmount
- [x] berlaku kelipatan jika requiredVoucherAllowMultyple = 1 → `floor(grandTotal / requiredVoucherMinAmount) * voucherGiftAmount`
- [x] Filter aktif: date range (NOW()), day-of-week, status=1, presence=1 (sama dengan promo lainnya)
- [x] Logika kalkulasi di `payment.service.js` → `checkVoucherPromotion(grandTotal, storeOutletId)`
- [x] INSERT ke `transaction_voucher` dilakukan di dalam `createTransaction()` (DB atomic transaction)
- [x] `createTransaction()` menerima param `voucherPromotion` baru, insert `transaction_voucher` di step 7b
- [x] Response `POST /api/payment/complete` ditambah field `voucher: { giftAmount, expDate, promotionId, promotionDescription }`
- [x] Jika tidak ada promo voucher aktif / tidak memenuhi syarat minimum → `voucher: null`
- [x] API trigger voucher sudah aktif di `POST /api/payment/complete` (controller hitung voucher, service simpan snapshot transaksi)
- [x] Verifikasi bug/syntax: `node --check` untuk `payment.service.js`, `transaction.service.js`, `payment.controller.js` (no errors)
- Files yang diubah: `payment.service.js`, `transaction.service.js`, `payment.controller.js`
- [x] nomor voucher unique di-generate dari table `auto_number` (`voucherCode`) dan disimpan ke `transaction_voucher`
- [x] Voucher validation API aktif: `GET /api/voucher/:voucherCode` (read-only validasi status/presence/expired)
- [x] Voucher use API aktif: `POST /api/voucher/use` (update `transaction_voucher.status = 1` + insert snapshot ke `voucher_log`)
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
  - [~] Check active promotions
  - [x] `promotion_item` dan `promotion_discount` aktif pada alur add-to-cart
  - [x] `promotion_free` / buy-X-get-Y sudah aktif
  - [x] Calculate price after discount
  - [x] Insert ke `kiosk_cart`
  - [x] Simpan `promotionId` dan `promotionItemId` ke `kiosk_cart`
  - [x] Handle free item → `kiosk_cart_free_item`
  - [ ] Emit Socket.IO `cart:update`
- [x] `GET /api/cart/:kioskUuid` — Get current cart session info
- [x] `GET /api/cart/list/:kioskUuid` — Get current cart items & totals
  - [x] Response item sudah include `promotionId`, `promotionItemId`, `promotionName`
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

- [~] Promotion check aktif di flow add-to-cart (`POST /api/item/barcode`, `POST /api/item/add`, `POST /api/item/add-qty`)
  - [x] Filter by: active date range, day-of-week, status, outlet
  - [x] Support Type 0: Item-level discount (`promotion_item`) — disc1/disc2/disc3, specialPrice, discountPrice
  - [x] Support Type 1: Buy-X-Get-Y Free (`promotion_free`)
  - [ ] Support Type 2: Buy-N-Get-Free (varian)
  - [x] Support Type 3: Quantity-based discount (`promotion_discount`)
  - [x] Hasil promo disimpan ke `kiosk_cart` dan diekspos kembali di cart list
- [ ] `GET /api/promotion/check/:itemId` — Standalone endpoint check promo masih belum dibuat
- [ ] `GET /api/promotion/fixed/:amount` — Check transaction-level promos (`promo_fixed`)
  - Cek `targetAmount` vs transaction amount
  - `isMultiple` logic (multiply benefit)
  - `ifAmountNearTarget` threshold message
- [ ] Promotion service: checkItemPromotion, checkTransactionPromo, applyDiscount, applyFreeItem
- [x] Helper: calculateCascadingDiscount(price, disc1, disc2, disc3)
- [x] Helper: checkDayOfWeek(promotion) — implemented via header day-flag filter di query promo aktif

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
- [x] `GET /api/payment/types/all` — List payment types for settings page (all rows from `payment_type`)
- [x] `GET /api/payment/types/:id` — Get payment type detail (full row)
- [x] `PUT /api/payment/types/:id` — Update payment type detail fields
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

- [x] `GET /api/voucher/:voucherCode` — Validate voucher (read-only)
  - Cek `transaction_voucher`: exists, presence=1, status=0 (unused), not expired
  - Return voucher snapshot + flag `valid`
- [x] `POST /api/voucher/use` — Mark voucher used
  - Update `transaction_voucher.status = 1`
  - Insert snapshot ke `voucher_log`
- [x] Submit voucher juga insert payment `VOUCHER` ke `kiosk_paid_pos`
  - `paid = voucherGiftAmount`
  - `approvedCode = voucherCode`
  - `refCode = voucherCode`
- [x] Voucher controller dibuat single-file tanpa service tambahan (`src/controllers/voucher.controller.js`)

### 7f. Payment Services & Schemas

- [x] Payment service: getTypes, addPayment, removePayment, finalizeTransaction
- [x] Payment schema: Zod validation (addPaymentSchema, finalizeSchema)
- [x] Payment service settings support: `getAllPaymentTypes`, `getPaymentTypeById`, `updatePaymentTypeById`
- [x] Payment schema settings support: `updatePaymentTypeSchema` (field validation for payment type detail update)
- [ ] Tax calculation helper: calculateTax(items, taxcodeConfig)

---





## 8. Transaction History — `/api/transaction/*`

- [x] `GET /api/transactions/:id` — Get completed transaction for receipt/reprint (header + aggregated items + primary payment type)
  - [x] Optional `receiptHtml` rendered dari template Handlebars user-customizable di `public/template/*.hbs`
  - [x] Query support: `renderReceiptHtml=true|false`, `template=bill.hbs`
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

- [x] Relay `display:update` per terminal room (`terminal:register` + room broadcast)
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

- [x] Utility: generateAutoNumber(name) — generic auto-increment helper
  - [x] Helper generik reusable dibuat di `src/utils/autoNumber.js`
  - [x] Sudah dipakai untuk generate `voucherCode` di `transaction.service.js`
  - [~] Implementasi lama spesifik per service (`auto_number` id=200/220/302) masih ada di beberapa modul lama dan belum semuanya dimigrasikan
  - Read current `runningNumber` dari `auto_number`
  - Increment + pad with `digit`
  - Prepend `prefix`
  - Update `runningNumber` dan `updateDate`
  - Used by: transaction, kiosk, settlement, reset, refund, exchange

---



## 16. Printing
controller baru khusus print, print log, printer POS termal dan lain-lain

### 16.1 Printing Log
[x] jika tekan tombol print maka akan tercatat / insert ke table `transaction_printlog`
[x] buat router dan controller baru `print.controller.js`
- [x] Endpoint baru: `POST /api/print/transaction/:transactionId/log` (auth required)
- [x] File baru: `src/controllers/print.controller.js`, `src/routes/print.routes.js`, `src/services/print.service.js`
- [x] `src/server.js` sudah register route `app.use('/api/print', printRoutes)`

### 16.2 Printer termal POS
[ ] code printer COM ke POS Printer termal


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
