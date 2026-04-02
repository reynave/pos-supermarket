# POS Supermarket — AI Agent Context Document

> This document describes the full concept, business logic, database schema, and technical architecture of the POS (Point of Sale) Supermarket system. It is intended as the primary context for AI agents working on this codebase.

## Fast Start (Latest Verified: 2026-04-02)

Gunakan bagian ini dulu agar AI agent lain cepat paham kondisi real codebase.

### Current Runtime Facts
- Backend API aktif di `src/server.js` (Express 5 + Socket.IO).
- Daily session runtime memakai `resetId` (alias `settlementId` masih dipakai untuk backward compatibility di beberapa payload/route).
- Flow payment aktif menggunakan `kiosk_paid_pos` lalu finalize ke `transaction`, `transaction_detail`, `transaction_payment`.
- Frontend Angular aktif di folder terpisah `pos-supermarket-web/`.

### Implemented Endpoint Snapshot (Real Route Names)

| Domain | Endpoint | Status |
|--------|----------|--------|
| Auth | `POST /api/auth/login`, `POST /api/auth/logout`, `GET /api/auth/me` | Implemented |
| Shift | `POST /api/shift/open`, `GET /api/shift/active/:terminalId`, `GET /api/shift/summary/:settlementId`, `POST /api/shift/close/:settlementId` | Implemented |
| Daily Close | `GET /api/daily-close/history`, `GET /api/daily-close/:resetId`, `POST /api/daily-close/:resetId`, `GET /api/daily-close/report/:resetId` | Implemented |
| Cart Session | `POST /api/cart/new`, `GET /api/cart/:kioskUuid`, `GET /api/cart/list/:kioskUuid`, `POST /api/cart/void/:kioskUuid`, `POST /api/cart/voidItem/:kioskUuid` | Implemented |
| Item Scan/Add | `POST /api/item/barcode`, `POST /api/item/add`, `POST /api/item/add-qty`, `GET /api/item/search` | Implemented |
| Payment | `GET /api/payment/types`, `GET /api/payment/pending/:kioskUuid`, `POST /api/payment/add`, `DELETE /api/payment/:id`, `POST /api/payment/complete` | Implemented |
| Transaction | `POST /api/transactions`, `GET /api/transactions`, `GET /api/transactions/:id` | Implemented |
| Manual Cash | `GET /api/manual-cash/summary`, `GET /api/manual-cash/summary/:terminalId`, `POST /api/manual-cash/add`, `POST /api/manual-cash/open-drawer`, `GET /api/manual-cash/history` | Implemented |

### Socket.IO Snapshot
- Implemented listener: `terminal:register`.
- Implemented relay: `display:update` ke room terminal.
- Event domain lain (`cart:update`, `payment:complete`, dll) belum standar penuh di backend.

---

## 1. Project Overview

This is a **retail POS application** designed to run on physical POS terminal machines in a supermarket / retail store environment. It is **not** an e-commerce or online store — it operates on-premise with barcode scanners, thermal printers, cash drawers, and EDC machines.

### Primary Users
| Role | Description |
|------|-------------|
| **Cashier** | Operates the POS terminal: scans items, processes payments, opens/closes daily shift |
| **Supervisor** | Authorizes voids, refunds, price overrides, and manages daily settlements |

### Key Characteristics
- Single-store or multi-terminal deployment (each terminal has its own `terminalId`)
- Offline-capable (local MySQL database per store)
- Real-time mirror screen for customer-facing display via Socket.IO
- Receipt printing via thermal printer (ESC/POS compatible)
- Multiple payment methods in a single transaction (split payment)
- Promotion engine with multiple discount types

---

## 2. Tech Stack

### Backend (this repository: `pos-supermarket/`)

| Layer | Technology |
|-------|------------|
| Runtime | Node.js v24.x |
| HTTP Framework | Express 5.x |
| Template Engine | EJS (for reports & receipt printing **only**) |
| Realtime | Socket.IO 4.x (mirror screen, live updates) |
| Database | MySQL / MariaDB |
| DB Driver | mysql2 (with connection pool) |
| Auth | bcryptjs + jsonwebtoken |
| Validation | zod |
| Security | helmet, cors |
| Logging | morgan |
| Config | dotenv |

### Frontend (separate repository / folder)

| Layer | Technology |
|-------|------------|
| Framework | Angular 18.x |
| Communication | HTTP (REST API) + Socket.IO client |

> **Architecture Note**: The frontend is an Angular 18 SPA maintained in a **separate folder/project**. Express does **not** serve any UI views — EJS is used exclusively for server-side rendered report pages and thermal receipt templates (accessed via `/print/*` routes). All POS UI screens (cashier screen, customer mirror display, etc.) are built in Angular and consume the REST API + Socket.IO events from this backend.

---

## 3. Core Features

### 3.1 Cashier Login (`F1`)
- Cashier enters employee ID (e.g. `123123`) to log in at a terminal.
- Supervisor login requires password (stored as MD5 hash in legacy — should migrate to bcrypt).
- Each login session is tracked in `user_auth` with token and terminal binding.
- User roles are defined in `user_access`: Supervisor (1), IT (2), Management (3), Cashier (10).
- Cashier function keys are mapped in `user_func` (e.g. void, refund, discount, reprint).

### 3.2 Barcode Scan → Item Lookup (`F2`)
- Cashier scans a barcode using a barcode scanner (keyboard wedge or serial).
- The API looks up `item_barcode` to find the `itemId` from the scanned `barcode`.
- Then fetches the item details from `item` (description, price, tax flag, etc.).
- One item can have **multiple barcodes** (e.g. different packaging).
- Item has up to 10 price levels (`price1` through `price10`).
- The scanned item is added to the active cart (`kiosk_cart`).
- **Socket.IO emits** the updated cart to the customer mirror screen.

### 3.3 Discount / Promotion Engine (`F3`)
When an item is scanned, the system checks if any active promotion applies. Promotion types:

| Type | Table | Description |
|------|-------|-------------|
| **Buy X Get Y Free** | `promotion_free` | e.g. Buy 1 Get 1, Buy 2 Get 1. Configurable: same item or different item, multiply-able |
| **Percentage Discount** | `promotion_item` | disc1, disc2, disc3 cascading percentage discounts per item |
| **Fixed Amount Discount** | `promotion_item` | `discountPrice` — fixed IDR amount off the price |
| **Special Price** | `promotion_item` | Override price to a specific amount |
| **Quantity-Based Discount** | `promotion_discount` | Discount triggered at qty threshold (e.g. 2nd item gets 20%+30% off) |
| **Member Discount** | `account` (id=99) | Global member discount percentage (e.g. 10%) applied if member is attached |
| **Fixed Promo (Transaction-Level)** | `promo_fixed` | Based on total transaction amount: free parking, lucky dip, voucher, cashback |
| **Tebus Murah** | `tebus_murah` + `_items` | Cheap redemption items unlocked at min transaction amount |

Promotion rules from `promotion`:
- `typeOfPromotion`: 0 = item-level, 1 = free-item, 2 = buy-N-get-free, 3 = quantity-discount
- Day-of-week flags: `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`, `Sun`
- Date range: `startDate` / `endDate` (unix timestamp)
- Promotions are checked automatically on every scan

### 3.4 Payment Processing (`F4`)
Supports **multiple payment methods in a single transaction** (split payment).

**Payment Types** (`payment_type`):
| ID | Label | Type |
|----|-------|------|
| `CASH` | Cash | Manual |
| `EDC_BCA` | BCA EDC | Hardware (COM port) |
| `EDC_BRI` | BRI EDC | Hardware |
| `EDC_MANDIRI` | Mandiri EDC | Hardware (COM port) |
| `DEBITCC` | Manual Debit/CC | Manual entry with approval code |
| `BCA01` | BCA Card ECR | Electronic Cash Register protocol |
| `BCA31` | BCA QRIS | QR code payment |
| `QRISTELKOM` | QRIS Telkom | QR code payment via Telkom API |
| `VOUCHER` | Voucher | Physical/digital voucher |
| `DISC.BILL` | Discount Bill | Bill-level discount as payment |

**Payment Card Names** (`payment_name`):
- BCA DEBIT, BCA VISA, BCA MASTERCARD
- MANDIRI DEBIT, MANDIRI VISA, MANDIRI MASTERCARD
- BRI DEBIT, BRI VISA, BRI MASTERCARD
- BNI DEBIT, BNI VISA, BNI MASTERCARD
- DIGITAL MONEY

**Split Payment Flow:**
1. Cashier selects first payment method → enters amount
2. If remaining balance > 0, selects next payment method → enters amount
3. Repeats until total paid >= final price
4. Each payment line is stored in `transaction_payment`
5. Change is calculated from cash portion only

**EDC Integration:**
- EDC machines connect via COM port (serial) or LAN
- `payment_bca_ecr` stores raw hex/ASCII communication with BCA EDC
- `payment_bca_qris` stores QRIS request/response
- `payment_qris_telkom` stores Telkom QRIS data with API integration

### 3.5 Daily Operations (`F5`)

#### Daily Start (Opening)
1. Supervisor or cashier logs in to the terminal
2. Enters **opening balance** (cash float amount)
3. System creates a new settlement session (`settlement`)
4. Opening balance is recorded in `balance` with `cashIn` and `transactionId = '_S1'`

#### During the Day
- Each completed transaction updates `balance` with cashIn (amount received) and cashOut (change given, stored as negative)
- Balance tracking is per-transaction, per-cashier, per-terminal

#### Daily Close (Settlement / Z-Report)
1. Cashier or supervisor initiates daily close
2. System generates settlement summary in `reset`:
   - `totalNumberOfCheck` — number of transactions
   - `summaryTotalVoid` — total voided amount
   - `summaryTotalTransaction` — gross transaction total
   - `overalitemSales` — total item sales
   - `overalDiscount` — total discounts given
   - `overalNetSales` — net sales
   - `overalFinalPrice` — final price after all deductions
   - `overalTax` — total tax collected
3. Payment breakdown stored in `reset_payment`
4. Settlement record in `settlement` is closed with total count and amount
5. Report is printed (EJS template rendered for thermal printer)

#### Printing
- Receipt printing via thermal printer (e.g. "POS80" configured in `account` id=400)
- Print log tracked in `transaction_printlog`
- Cash drawer kick command sent with print (ESC/POS command)
- Receipt content:
  - Company name, address, phone (from `account`)
  - Transaction items with prices, discounts
  - Tax breakdown (BKP, DPP, PPN)
  - Payment method(s) and amounts
  - Footer message (from `account` id=1007)

#### Open Cash Drawer
- Triggered automatically after payment completion
- Can also be triggered manually (supervisor authorization may be required)
- Tracked via `cashDrawer` flag in `transaction`
- Hardware: ESC/POS command sent to thermal printer (cash drawer connected to printer's DK port)

### 3.6 Customer Mirror Screen (`F6`)
- Uses **Socket.IO** for real-time communication between POS terminal and customer-facing display
- Events to emit:
  - `cart:update` — when item is scanned/removed/voided
  - `cart:clear` — when transaction is completed or cancelled
  - `payment:start` — when payment process begins
  - `payment:complete` — when payment is finalized
  - `promotion:applied` — when a promotion discount is applied
  - `greeting:display` — welcome/thank you messages
- Customer screen shows:
  - Welcome message (from `account` id=1001)
  - Live item list with prices and discounts
  - Running total
  - QR code for QR payment (if applicable)
  - Thank you message after payment (from `account` id=1004)
- Messages are configurable in `account` (ids 1001–1009)

### 3.7 Multiple Payment & Device Integration (`F7`)

#### Credit Card / Debit Card via EDC
- EDC machines are connected via:
  - **Serial port** (COM5, COM8, etc.) — configured in `payment_type.com`
  - **LAN** — via TCP socket
  - **USB** — depends on vendor SDK
- Each EDC payment type has: `apikey`, `mId`, `nmId`, `merchant`, `timeout`
- BCA ECR protocol: sends hex commands, receives hex response → parsed to transaction data
- Payment response includes: `approvalCode`, `rrn`, `pan` (masked card number), `cardHolderName`

#### QR Payment (QRIS)
- **BCA QRIS**: direct ECR-based QR generation
- **Telkom QRIS**: REST API integration
  - API URL: `https://qris.id/restapi/qris/show_qris.php` (generate QR)
  - Status URL: `https://qris.id/restapi/qris/checkpaid_qris.php` (check payment)
  - Fields: `cliTrxNumber`, `cliTrxAmount`, `qris_content` (QR data), `qris_invoiceid`
  - Polling mechanism to check payment status

#### Voucher Payment
- Vouchers managed in `voucher_master` (denomination, expiry) and `voucher` (individual voucher instances)
- During payment, cashier scans/enters voucher number
- System validates: exists, not used, not expired
- Voucher amount deducted from transaction total

### 3.8 Daily Report (`F8`)
- **End-of-day summary** based on `reset` and `reset_payment`
- **Settlement report** from `settlement`
- Report data includes:
  - Total transactions count
  - Gross sales, discounts, net sales
  - Tax collected (BKP, DPP, PPN)
  - Payment method breakdown (how much cash, how much card, how much QR, etc.)
  - Void count and amount
  - Cash balance (opening + received - change given)
- Rendered via **EJS template** on the Express backend for:
  - Thermal printer (80mm receipt format)
  - Browser print (opened from Angular via `/print/*` routes)

---

## 4. Database Schema

### Database Name: `pos_supermarket` (dump 2026) / `pos2` (default env fallback)

### Table Naming Convention
- No prefix — all tables use plain names (e.g. `item`, `transaction`, `balance`, `member`)
- Legacy `cso1_` and `cso2_` prefixes have been **removed** from all table names

### 4.1 System Configuration

#### `auto_number`
Auto-increment number generator with configurable prefix and digit length.
```
id | name | prefix | digit | runningNumber | updateDate
```
Used for generating: transaction IDs, kiosk UUIDs, settlement IDs, refund IDs, etc.

#### `account`
Key-value store for all system configuration.
```
id | name | value | updateDate | updateBy
```
Important entries:
- 1: `companyId`
- 10: `companyName`, 11: `companyAddress`, 12: `companyPhone`
- 21: `Outlet ID`, 22: `Brand ID`
- 51-54: Barcode digit configuration (prefix position, item digits, weight digits, float digits)
- 99: `Member Discount` percentage
- 100: `Round Method`
- 101: `Tax Id`
- 400: `Printer Name`
- 1001-1009: Display messages (welcome, thank you, member not found, etc.)
- 1101-1102: Terms and conditions

### 4.2 Item Master

#### `item`
Master item table.
```
id (PK) | description | shortDesc | priceFlag | ppnFlag | price1..price10 |
itemUomId | itemCategoryId | itemTaxId | images | presence | status
```
- `id` is the article/SKU number (varchar)
- Supports up to 10 price levels
- `presence`: 1 = active, 0 = deleted (soft delete)
- `status`: 1 = active

#### `item_barcode`
Maps barcodes to items (many-to-one).
```
id | itemId → item.id | barcode | status | presence
```

#### `item_category`
Hierarchical category tree.
```
id | id_parent (0 = root) | name | status | presence
```
Examples: Food > Snacks > Snack Pabrik, Non Food > Perawatan Tubuh > Shampoo

#### `item_uom`
Unit of measure.
```
id | name | description
```
Values: Bag, Pcs, Box, Btl

#### `item_tax`
Tax flag on items.
```
id | description
```
Values: Enable (2), Disable (3)

#### `item_discount`
Item-level discount master (currently empty — discounts handled via promotion engine).

### 4.3 Transaction Flow

#### `kiosk_uuid`
Active transaction session. Created when cashier starts a new transaction.
```
kioskUuid (PK) | exchange | cashierId | terminalId | storeOutlesId | memberId |
ilock | presence | status | inputDate | startDate
```
- `kioskUuid` format: `{terminalId}.{YYMMDD}.{sequence}` e.g. `T01.250728.0232`
- `ilock`: transaction lock flag
- `memberId`: attached member (for member discount)

#### `kiosk_cart`
Active shopping cart items (before payment is completed).
```
id | kioskUuid | promotionId | promotionItemId | promotionFreeId | promotionDiscountId |
itemId | barcode | originPrice | price | discount | memberDiscountPercent | memberDiscountAmount |
validationNota | isPriceEdit | isFreeItem | isSpecialPrice | isPrintOnBill |
photo | void | note | presence
```
- `originPrice`: original price before any discount
- `price`: final price after discount
- `discount`: discount amount
- `isFreeItem`: reference to promotion free item
- `isSpecialPrice`: flag if special price was applied
- `void`: 1 = voided item

#### `kiosk_cart_free_item`
Free items in cart from promotion rules.
```
id | kioskUuid | promotionId | promotionFreeId | itemId | freeItemId |
originPrice | barcode | scanFree | price | printOnBill | void
```

#### `kiosk_paid_pos`
Payment entries during active (not yet closed) transaction.
```
id | kioskUuid | paymentTypeId | paymentNameId | approvedCode | refCode |
paid | deviceId | cardId | voucherNumber | note | externalTransId
```

#### `transaction`
Completed transaction header.
```
id (PK) | transactionDate | kioskUuid | resetId | settlementId | memberId |
paymentTypeId | storeOutlesId | terminalId | struk |
total | subTotal | discount | discountMember | voucher |
bkp | dpp | ppn | nonBkp | finalPrice |
cashierId | cashDrawer | printing | presence
```
- `id` format: `{cashierId}.{sequence}` e.g. `123123.0130`
- `struk`: receipt number (same as id)
- Tax fields: `bkp` (taxable), `dpp` (tax base), `ppn` (tax amount), `nonBkp` (non-taxable)
- `cashDrawer`: 1 = cash drawer was opened
- `printing`: 1 = receipt was printed

#### `transaction_detail`
Transaction line items (persisted from cart).
```
id | transactionId | promotionId | promotionFreeId | promotionItemId | promotionDiscountId |
itemId | barcode | originPrice | price | discount |
memberDiscountAmount | memberDiscountPercent |
isPriceEdit | isFreeItem | isSpecialPrice | isPrintOnBill |
void | refund | exchange | note | presence
```

#### `transaction_payment`
Payment records for completed transactions (supports split payment).
```
id | transactionId | paymentTypeId | paymentNameId | amount | rounding |
voucherNumber | approvedCode | refCode | presence
```
One transaction can have multiple payment records (e.g. CASH + EDC_MANDIRI + VOUCHER).

#### `transaction_printlog`
Tracks every receipt print event.
```
id | transactionId | inputDate | inputBy
```

### 4.4 Promotion Engine

#### `promotion`
Promotion header/master.
```
id (PK) | typeOfPromotion | storeOutlesId | code | description |
startDate | endDate | discountPercent | discountAmount |
Mon | Tue | Wed | Thu | Fri | Sat | Sun | status | presence
```

#### `promotion_item`
Item-level promotion rules (percentage discount, special price).
```
id | promotionId | itemId | qtyFrom | qtyTo | specialPrice |
disc1 | disc2 | disc3 | discountPrice | presence | status
```
- `disc1`, `disc2`, `disc3`: cascading percentage discounts
- `specialPrice`: override price
- `discountPrice`: fixed amount discount
- `qtyFrom`/`qtyTo`: quantity range triggering the promotion

#### `promotion_free`
Buy-X-Get-Y-Free rules.
```
id | promotionId | itemId | qty | freeItemId | freeQty |
applyMultiply | scanFree | printOnBill | status | presence
```
- `qty`: how many to buy
- `freeQty`: how many free
- `applyMultiply`: if 1, promotion multiplies (buy 4 get 2 free if qty=2, freeQty=1)
- `scanFree`: if 1, free item must be scanned separately

#### `promotion_discount`
Promotion discount per item (percentage-based, e.g. 2nd item discount).
```
id | promotionId | itemId | disc1 | disc2 | status | presence
```

#### `promo_fixed`
Transaction-level fixed promotions.
```
id | name | description | shortDesc | targetAmount | isMultiple |
voucherAmount | ifAmountNearTarget | status | expDate
```
- `targetAmount`: minimum transaction to qualify
- `isMultiple`: if 1, benefit multiplies per targetAmount reached
- `ifAmountNearTarget`: percentage threshold to show "almost qualified" message
- Types: Free Parking, Lucky Dip, Voucher, Voucher Discount, Extra Point, Free Gift, Cashback

### 4.5 Payment & Device Integration

#### `payment_type`
Payment method master.
```
id (PK) | edc | label | name | com | apikey | mId | nmId | merchant |
timeout | image | apiUrl | apiUrlStatus | isLock | status | presence
```
- `edc`: 1 = hardware EDC, 0 = software/manual
- `com`: serial port (e.g. "COM5", "COM8")
- `apiUrl` / `apiUrlStatus`: for QR payment API endpoints

#### `payment_name`
Card network names for EDC payments.
```
id | name | status | img
```

#### `payment_bca_ecr`
BCA Electronic Cash Register communication log.
```
transactionId | kioskUuid | paymentTypeId | respCode | amount | pan |
expiryDate | rrn | approvalCode | dateTime | merchantId | terminalId |
cardHolderName | invoiceNumber | hex | asciiString
```

#### `payment_bca_qris`
BCA QRIS payment log.
```
id | kioskUuid | reffNo | hex | asciiString | respAscii | respHex | status
```

#### `payment_qris_telkom`
Telkom QRIS payment integration.
```
kioskUuid | cliTrxNumber | cliTrxAmount | qris_status |
qris_payment_customername | qris_payment_methodby | transactionId |
qris_content | qris_invoiceid | qris_nmid | qris_request_date
```

### 4.6 User Management

#### `user`
User master.
```
id (PK) | name | userAccessId | storeOutlesId | password | status | presence |
saveFunc | saveShortCut
```
- `saveFunc`: JSON array of assigned function key numbers
- `password`: MD5 hash (legacy — plan to migrate to bcrypt)

#### `user_access`
Role definitions.
```
id | name
```
Values: Supervisor (1), IT (2), Management (3), Cashier (10)

#### `user_auth`
Login session tracking.
```
id | userId | agent | client_ip | terminalId | inputDate | status | token
```

#### `user_func`
Function key mappings per user.
```
id | userId | number | color | sorting
```

### 4.7 Daily Operations

#### `balance`
Cash balance tracking per transaction.
```
id | cashIn | cashOut | transactionId | kioskUuid | cashierId |
terminalId | settlementId | close | input_date
```
- `cashIn`: cash received from customer
- `cashOut`: change given (stored as negative value)
- `transactionId = '_S1'`: indicates opening balance entry
- `close`: 1 = settlement closed

#### `settlement`
Daily settlement summary.
```
id (PK) | total | amount | input_date | upload | upload_date
```
- `id` format: `{terminalId}SET{sequence}` e.g. `T01SET000039`
- `upload`: flag for uploading to central server

#### `reset`
Z-report / daily reset data.
```
id | storeOutlesId | startDate | endDate | totalNumberOfCheck |
summaryTotalVoid | summaryTotalTransaction | summaryTotalCart |
overalitemSales | overalDiscount | overalNetSales | overalFinalPrice | overalTax |
note | presence | inputDate | inputBy
```

#### `reset_payment`
Payment breakdown in daily reset.
```
id | resetId | paymentTypeId | qty | paidAmount | presence
```

### 4.8 Other Tables

#### `member`
Customer membership.
```
id (PK) | name | status | expDate
```
- When member is attached to a transaction, member discount percentage (from `account` id=99) is applied to eligible items.

#### `refund`
Refund records.
```
id | transactionId | refundTotalAmount | terminalId | input_date | input_by
```

#### `exchange`
Item exchange records.
```
id | kioskUuid | exchange | transactionId | transactionDetailId |
itemId | refundAmount | exchangeItemId | exchangeAmount
```

#### `voucher_master`
Voucher denomination definitions.
```
id | name | amount | donwload | expDate | filename | input_date
```

#### `voucher`
Individual voucher instances.
```
id | voucherMasterId | number (unique) | amount | status |
kioskUuid | transactionId | update_date | input_date
```
- `status`: 0 = unused, 1 = used

#### `greeting`
Configurable greeting messages.
```
id | message | publishDate | status | presence
```

#### `taxcode`
Tax code configuration.
```
id | name | taxType | percentage | status
```
- `taxType`: 1 = inclusive, 0 = exclusive
- Current values: Non PPN (0%), PPN 11% Inc, PPN 11% Excl

#### `tebus_murah` / `tebus_murah_items`
Cheap redemption promotion.
```
tebus_murah: id | description | expDate | minTransaction | maxItem | status
tebus_murah_items: id | tembusMurahId | itemId | price
```

#### `sync` / `sync_log`
Data sync from central server (item master, barcode, promo, member data).
```
sync: id | path | fileName | totalInsert | totalTime | result | lastSycn
sync_log: id | module | fileName | fileSize | syncDate | status
```

---

## 5. Transaction Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                    DAILY START (Opening)                        │
│  1. Cashier login → user_auth                             │
│  2. Enter opening balance → balance (transactionId='_S1') │
│  3. Settlement session created → settlement               │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    NEW TRANSACTION                              │
│  1. Generate kioskUuid → kiosk_uuid                       │
│  2. Attach member (optional) → kiosk_uuid.memberId        │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SCAN ITEMS (loop)                            │
│  1. Scan barcode → lookup item_barcode → item        │
│  2. Check promotions → promotion + sub-tables             │
│  3. Calculate price with discounts                             │
│  4. Add to cart → kiosk_cart                              │
│  5. If free item → kiosk_cart_free_item                   │
│  6. Emit Socket.IO → customer mirror screen                    │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PAYMENT                                      │
│  1. Calculate totals (subtotal, discount, tax, final)          │
│  2. Select payment method(s) — supports split payment          │
│  3. For EDC: send command to device → wait for response        │
│  4. For QRIS: generate QR → poll for payment status            │
│  5. For CASH: calculate change                                 │
│  6. Store payment(s) → kiosk_paid_pos                     │
│  7. Open cash drawer (ESC/POS command)                         │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FINALIZE TRANSACTION                         │
│  1. Move cart → transaction + transaction_detail      │
│  2. Store payments → transaction_payment                   │
│  3. Update balance → balance                               │
│  4. Print receipt → EJS template → thermal printer              │
│  5. Log print → transaction_printlog                       │
│  6. Clear cart → kiosk_cart                                │
│  7. Emit Socket.IO → thank you screen                          │
│  8. Generate auto_number for next transaction                  │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DAILY CLOSE (Settlement)                     │
│  1. Generate Z-report → reset + reset_payment        │
│  2. Close settlement → settlement (mark close)            │
│  3. Print settlement report                                    │
│  4. Upload flag for central sync (optional)                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. REST API Endpoint Design

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | Cashier/supervisor login |
| POST | `/api/auth/logout` | End session |
| GET | `/api/auth/me` | Get current user info |

### Item
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/item/barcode/:barcode` | Lookup item by barcode scan |
| GET | `/api/item/:id` | Get item by article ID |
| GET | `/api/item/search?q=` | Search items by description |

### Cart (Active Transaction)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/cart/start` | Start new transaction (create kiosk_uuid) |
| POST | `/api/cart/scan` | Add item to cart by barcode |
| PUT | `/api/cart/item/:id` | Update cart item (qty, price edit, void) |
| DELETE | `/api/cart/item/:id` | Remove/void item from cart |
| GET | `/api/cart/:kioskUuid` | Get current cart |
| PUT | `/api/cart/:kioskUuid/member` | Attach member to transaction |
| DELETE | `/api/cart/:kioskUuid` | Cancel/clear entire cart |

### Payment
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/payment/types` | List available payment types |
| POST | `/api/payment/add` | Add a payment entry (split payment) |
| DELETE | `/api/payment/:id` | Remove a payment entry |
| POST | `/api/payment/finalize` | Complete transaction, persist, print |
| POST | `/api/payment/edc/send` | Send payment command to EDC |
| GET | `/api/payment/edc/status/:id` | Check EDC payment status |
| POST | `/api/payment/qris/generate` | Generate QRIS QR code |
| GET | `/api/payment/qris/status/:id` | Poll QRIS payment status |

### Transaction
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/transaction/:id` | Get completed transaction |
| GET | `/api/transaction/:id/detail` | Get transaction line items |
| GET | `/api/transaction/:id/payments` | Get transaction payments |
| POST | `/api/transaction/:id/reprint` | Reprint receipt |
| POST | `/api/transaction/:id/void` | Void transaction (supervisor auth) |

### Refund & Exchange
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/refund` | Process refund |
| POST | `/api/exchange` | Process item exchange |

### Daily Operations
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/daily/open` | Daily start with opening balance |
| POST | `/api/daily/close` | Daily close / settlement |
| GET | `/api/daily/balance` | Get current cash balance |
| POST | `/api/daily/cash-drawer` | Trigger cash drawer open |

### Report
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/report/daily?date=` | Daily sales summary |
| GET | `/api/report/settlement/:id` | Settlement report |
| GET | `/api/report/z-report/:id` | Z-report detail |

### Print (EJS rendered views — reports only, no UI)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/print/receipt/:transactionId` | Receipt HTML for thermal printer |
| GET | `/print/z-report/:resetId` | Z-report HTML for printing |
| GET | `/print/settlement/:settlementId` | Settlement report HTML |

### Member
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/member/:id` | Lookup member by ID |
| GET | `/api/member/search?q=` | Search member |

### Promotion
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/promotion/check/:itemId` | Check active promotions for an item |
| GET | `/api/promotion/fixed/:amount` | Check transaction-level promotions |

### Voucher
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/voucher/:number` | Validate voucher number |

### Config
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/config/account` | Get store configuration |
| GET | `/api/config/terminal` | Get terminal info |

---

## 7. Socket.IO Events

### Server → Customer Display (mirror screen)
| Event | Payload | When |
|-------|---------|------|
| `cart:update` | `{ items[], total, discount, finalPrice }` | Item scanned/removed/voided |
| `cart:clear` | `{}` | Transaction completed or cancelled |
| `member:attached` | `{ memberId, memberName }` | Member card scanned |
| `payment:start` | `{ finalPrice, paymentType }` | Payment process initiated |
| `payment:qr` | `{ qrContent, amount }` | QR code generated for payment |
| `payment:complete` | `{ change, paymentMethods[] }` | Payment finalized |
| `promotion:applied` | `{ itemId, promotionDesc, discount }` | Promotion triggered |
| `display:welcome` | `{ message }` | Idle state / new transaction |
| `display:thankyou` | `{ message }` | After payment complete |
| `display:message` | `{ message }` | Custom messages |

### POS Terminal → Server
| Event | Payload | When |
|-------|---------|------|
| `terminal:register` | `{ terminalId }` | Terminal connects |
| `terminal:heartbeat` | `{ terminalId, timestamp }` | Keep-alive |

---

## 8. Recommended Project Structure

```
pos-supermarket/
├── .env                          # Environment variables
├── .env.example                  # Template
├── package.json
├── AGENT.md                      # This file
├── table-ver2025.sql             # Database schema
│
├── src/
│   ├── server.js                 # Express + Socket.IO bootstrap
│   ├── config/
│   │   ├── database.js           # mysql2 pool configuration
│   │   ├── socket.js             # Socket.IO setup
│   │   └── env.js                # dotenv loader & validation
│   │
│   ├── middleware/
│   │   ├── auth.js               # JWT verification middleware
│   │   ├── role.js               # Role-based access control
│   │   ├── validate.js           # Zod validation middleware
│   │   └── errorHandler.js       # Global error handler
│   │
│   ├── routes/
│   │   ├── auth.routes.js
│   │   ├── item.routes.js
│   │   ├── cart.routes.js
│   │   ├── payment.routes.js
│   │   ├── transaction.routes.js
│   │   ├── daily.routes.js
│   │   ├── report.routes.js
│   │   ├── member.routes.js
│   │   ├── promotion.routes.js
│   │   ├── voucher.routes.js
│   │   └── config.routes.js
│   │
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── item.controller.js
│   │   ├── cart.controller.js
│   │   ├── payment.controller.js
│   │   ├── transaction.controller.js
│   │   ├── daily.controller.js
│   │   ├── report.controller.js
│   │   ├── member.controller.js
│   │   ├── promotion.controller.js
│   │   ├── voucher.controller.js
│   │   └── config.controller.js
│   │
│   ├── services/
│   │   ├── auth.service.js
│   │   ├── item.service.js
│   │   ├── cart.service.js
│   │   ├── payment.service.js
│   │   ├── promotion.service.js  # Promotion calculation engine
│   │   ├── transaction.service.js
│   │   ├── daily.service.js
│   │   ├── autoNumber.service.js # Auto number generator
│   │   └── mirror.service.js     # Socket.IO event emitter
│   │
│   ├── schemas/
│   │   ├── auth.schema.js        # Zod schemas for auth
│   │   ├── cart.schema.js
│   │   ├── payment.schema.js
│   │   └── daily.schema.js
│   │
│   ├── socket/
│   │   ├── index.js              # Socket.IO event handlers
│   │   └── mirrorScreen.js       # Customer display events
│   │
│   └── utils/
│       ├── response.js           # Standard API response helper
│       ├── tax.js                # Tax calculation (inclusive/exclusive)
│       └── round.js              # Rounding utility
│
└── views/                        # EJS templates (reports & print ONLY)
    ├── receipt.ejs               # Transaction receipt (thermal printer)
    ├── z-report.ejs              # Z-report / daily reset
    └── settlement.ejs            # Settlement report

# Frontend (separate folder — NOT inside this project)
pos-supermarket-web/              # Angular 18.x SPA
├── src/
│   ├── app/
│   │   ├── pages/                # Cashier screen, login, reports viewer
│   │   ├── components/           # Shared UI components
│   │   ├── services/             # HTTP + Socket.IO client services
│   │   └── models/               # TypeScript interfaces
│   ├── assets/
│   └── environments/
├── angular.json
├── package.json
└── tsconfig.json
```

---

## 9. Environment Variables (.env)

```env
# Server
PORT=3000
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=
DB_NAME=pos2

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=12h

# Terminal
TERMINAL_ID=T01
STORE_OUTLET_ID=OT99

# Printer
PRINTER_NAME=POS80

# QRIS Telkom (if enabled)
QRIS_API_URL=https://qris.id/restapi/qris/show_qris.php
QRIS_STATUS_URL=https://qris.id/restapi/qris/checkpaid_qris.php
QRIS_API_KEY=
QRIS_MID=
QRIS_NMID=
```

---

## 10. Important Business Rules

1. **Soft Delete**: All tables use `presence` field (1 = active, 0 = deleted). Never hard-delete records.
2. **Timestamps**: Legacy uses unix timestamp (int). Newer columns use `datetime`. Both should be populated.
3. **Rounding**: Configured in `account` id=100. Round method = 10 (round to nearest 10).
4. **Tax Calculation**: PPN can be inclusive (price includes tax) or exclusive (tax added on top). Check `taxcode`.
5. **Transaction ID Format**: `{cashierId}.{4-digit-sequence}` — sequence from `auto_number` id=200.
6. **KioskUuid Format**: `{terminalId}.{YYMMDD}.{4-digit-sequence}` — sequence from `auto_number` id=302.
7. **Member Discount**: Global percentage from `account` id=99 (currently 10%). Applied to item price after promotion discount.
8. **Void**: Items can be voided (cart.void = 1) but record is kept. Supervisor authorization may be required.
9. **Reprint**: Receipt reprint is logged in `transaction_printlog`.
10. **Settlement Upload**: After daily close, settlement can be flagged for upload to central server via `settlement.upload`.
