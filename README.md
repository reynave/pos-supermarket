# POS Supermarket — Retail Point of Sale System

> **On-premise retail POS** application for supermarket/retail stores — built with **Node.js**, **Angular**, **MySQL**, and **Socket.IO**. Designed to run on physical POS terminal hardware with barcode scanners, thermal printers, cash drawers, and EDC payment machines.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Tech Stack](#tech-stack)
- [AI-Assisted Development](#ai-assisted-development)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Environment Configuration](#environment-configuration)
- [Database Setup](#database-setup)
- [Running — Development](#running--development)
- [Running — Production](#running--production)
- [Project Structure](#project-structure)
- [API Overview](#api-overview)
- [Socket.IO Real-Time Events](#socketio-real-time-events)
- [Hardware Integration](#hardware-integration)
- [Security](#security)
- [License](#license)

---

## Architecture Overview

```
┌──────────────────────────────┐      REST API (JSON)      ┌──────────────────────────────┐
│   pos-supermarket-web        │  ◄──────────────────────►  │   pos-supermarket (this repo) │
│   Angular 18 SPA             │      Socket.IO (WS)       │   Express 5 + Socket.IO 4     │
│   Tailwind CSS 3             │  ◄──────────────────────►  │   EJS (receipts & reports)    │
│                              │                            │                                │
│  • Cashier screen            │                            │  • Business logic              │
│  • Customer mirror display   │                            │  • Promotion engine            │
│  • Daily start/close UI      │                            │  • Payment processing          │
│  • Payment checkout          │                            │  • Thermal print rendering     │
└──────────────────────────────┘                            └────────────┬───────────────────┘
                                                                         │
                                                             mysql2 pool │
                                                                         ▼
                                                            ┌───────────────────────┐
                                                            │   MySQL / MariaDB     │
                                                            │   Database: pos2      │
                                                            │   (local per-store)   │
                                                            └───────────────────────┘
```

- **Backend** (`pos-supermarket/`) — REST API, Socket.IO server, receipt rendering (EJS)
- **Frontend** (`pos-supermarket-web/`) — Angular 18 standalone SPA, Tailwind CSS, Socket.IO client
- **Database** — MySQL/MariaDB running locally on each POS terminal or store server

The frontend communicates with the backend via HTTP REST (`/api/*`) and WebSocket (Socket.IO). Express does **not** serve UI views — EJS is used exclusively for thermal receipt and report templates (`/print/*` routes).

---

## Tech Stack

### Backend — `pos-supermarket/`

| Component          | Technology                     |
|--------------------|--------------------------------|
| Runtime            | **Node.js** v24.x              |
| HTTP Framework     | **Express** 5.x                |
| Real-time          | **Socket.IO** 4.x              |
| Database           | **MySQL / MariaDB**            |
| DB Driver          | **mysql2** (connection pool)    |
| Authentication     | **bcryptjs** + **jsonwebtoken** |
| Validation         | **zod**                         |
| Template Engine    | **EJS** (receipts & reports)    |
| Security           | **helmet**, **cors**            |
| Compression        | **compression**                 |
| Logging            | **morgan**                      |
| Config             | **dotenv**                      |
| Dev Server         | **nodemon** (auto-reload)       |

### Frontend — `pos-supermarket-web/`

| Component          | Technology                             |
|--------------------|----------------------------------------|
| Framework          | **Angular** 18.x (standalone components) |
| Language           | **TypeScript** ~5.4                     |
| Styling            | **Tailwind CSS** 3.x (plain CSS, no SCSS) |
| UI Primitives      | **@angular/cdk** (headless dialogs)     |
| Real-time Client   | **socket.io-client** 4.x               |
| Forms              | Angular FormsModule (template-driven)   |
| HTTP               | Angular HttpClient + functional interceptors |

### Infrastructure

| Component          | Technology                     |
|--------------------|--------------------------------|
| Database Server    | MySQL 8.x / MariaDB 10.4+     |
| OS                 | Windows (POS terminal)         |
| Hardware           | Barcode scanner, thermal printer (ESC/POS), cash drawer, EDC machines |

---

## AI-Assisted Development

This project leverages **AI agents** (GitHub Copilot / Claude) for accelerated development. All AI context documents are stored in the `AI-Agent/` folder:

| File | Purpose |
|------|---------|
| `AI-Agent/AGENT.md` | Full context document — business logic, database schema, API design, transaction lifecycle, Socket.IO events |
| `AI-Agent/table-ver2025.sql` | Complete MySQL database schema with seed data |

The **AGENT.md** file provides ~900 lines of structured context covering:
- Complete **database schema** (30+ tables) with field-level documentation
- Full **REST API endpoint design** (50+ endpoints across 12 resource groups)
- **Business rules** — promotion engine, split payment, tax calculation, rounding
- **Transaction lifecycle** — from daily open → scan → payment → settlement
- **Socket.IO event contracts** — real-time customer mirror screen
- **Hardware integration** — EDC serial protocol, QRIS API, thermal printing

> **Tip:** When starting a new Copilot Chat session, reference `@workspace` or attach `AGENT.md` so the AI has full system context.

---

## Prerequisites

| Requirement    | Version   | Notes                          |
|----------------|-----------|--------------------------------|
| **Node.js**    | ≥ 20.x    | v24.x recommended              |
| **npm**        | ≥ 10.x    | Ships with Node.js             |
| **MySQL**      | ≥ 8.0     | Or **MariaDB** ≥ 10.4         |
| **Git**        | latest     | Version control                |

### Optional (for production POS environment)

- Thermal printer (80mm, ESC/POS compatible, e.g. Epson TM-T82)
- Barcode scanner (keyboard wedge / USB HID)
- Cash drawer (connected via printer DK port)
- EDC machine (BCA, BRI, Mandiri — serial COM port)

---

## Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd pos-supermarket
```

### 2. Install dependencies

```bash
# Backend
cd pos-supermarket
npm install

# Frontend
cd ../pos-supermarket-web
npm install
```

---

## Environment Configuration

Create a `.env` file in the `pos-supermarket/` root:

```bash
cp .env.example .env
```

```env
# Server
PORT=3000
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=your_password
DB_NAME=pos2

# JWT Authentication
JWT_SECRET=your-strong-secret-key-here
JWT_EXPIRES_IN=12h

# Terminal Identity
TERMINAL_ID=T01
STORE_OUTLET_ID=OT99

# Thermal Printer
PRINTER_NAME=POS80

# QRIS Telkom (optional — enable if using QRIS payment)
# QRIS_API_URL=https://qris.id/restapi/qris/show_qris.php
# QRIS_STATUS_URL=https://qris.id/restapi/qris/checkpaid_qris.php
# QRIS_API_KEY=
# QRIS_MID=
# QRIS_NMID=
```

> **Important:** In production, use a strong random `JWT_SECRET` (min 32 characters). Never commit `.env` to version control.

---

## Database Setup

### 1. Create the database

```sql
CREATE DATABASE pos2 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

### 2. Import the schema & seed data

```bash
mysql -u root -p pos2 < AI-Agent/table-ver2025.sql
```

Or via a GUI tool (HeidiSQL, DBeaver, phpMyAdmin):
1. Connect to your MySQL/MariaDB server
2. Select the `pos2` database
3. Import/run `AI-Agent/table-ver2025.sql`

The SQL file includes all table structures and seed data (items, payment types, system config, etc.).

---

## Running — Development

### Start the backend (API server)

```bash
cd pos-supermarket
npm run dev
```

This starts nodemon with auto-reload on file changes. The API server runs on `http://localhost:3000`.

### Start the frontend (Angular dev server)

```bash
cd pos-supermarket-web
npx ng serve --proxy-config src/proxy.conf.json
```

The Angular dev server runs on `http://localhost:4200` and proxies `/api/*` requests to port 3000.

### Verify the setup

```bash
# Health check — should return { status: "ok", db: "connected" }
curl http://localhost:3000/api/health
```

---

## Running — Production

### Backend (Node.js)

```bash
cd pos-supermarket

# Set production environment
set NODE_ENV=production      # Windows
# export NODE_ENV=production # Linux/Mac

# Start the server
npm start
```

For process management, use **PM2**:

```bash
# Install PM2 globally
npm install -g pm2

# Start with PM2
pm2 start src/server.js --name pos-api --env production

# Auto-restart on crash
pm2 save
pm2 startup
```

### Frontend (Angular build)

```bash
cd pos-supermarket-web

# Production build
npx ng build --configuration=production

# Output: dist/pos-supermarket-web/browser/
```

Serve the built files with any static file server, or configure Express to serve them:

```bash
# Option A: Use a lightweight static server
npx serve dist/pos-supermarket-web/browser -l 4200

# Option B: Use nginx / IIS to serve static files
# Point document root to dist/pos-supermarket-web/browser/
```

### Production Checklist

- [ ] Set `NODE_ENV=production` in `.env`
- [ ] Use a strong, random `JWT_SECRET`
- [ ] Set `DB_PASS` with a secure database password
- [ ] Run MySQL with proper user privileges (not root)
- [ ] Use PM2 or Windows Service for Node.js process management
- [ ] Build Angular with `--configuration=production` (tree-shaking, minification, AOT)
- [ ] Configure firewall — only expose necessary ports (3000 for API, or use reverse proxy)
- [ ] Set up daily database backups (mysqldump / scheduled task)

---

## Project Structure

```
pos-supermarket/
├── .env                          # Environment variables (git-ignored)
├── package.json                  # Dependencies & scripts
├── AI-Agent/
│   ├── AGENT.md                  # AI context — full system documentation
│   └── table-ver2025.sql         # Database schema + seed data
├── public/                       # Static assets (images, css, js)
├── src/
│   ├── server.js                 # Express + Socket.IO bootstrap
│   ├── config/
│   │   ├── database.js           # mysql2 connection pool
│   │   ├── env.js                # dotenv config loader
│   │   └── socket.js             # Socket.IO initialization
│   ├── controllers/              # Route handlers
│   ├── middleware/
│   │   ├── auth.js               # JWT verification
│   │   ├── role.js               # Role-based access (Cashier/Supervisor)
│   │   ├── validate.js           # Zod request validation
│   │   └── errorHandler.js       # Global error handler
│   ├── routes/                   # Express route definitions
│   ├── schemas/                  # Zod validation schemas
│   ├── services/                 # Business logic layer
│   └── utils/                    # Helpers (response formatter, etc.)
└── views/                        # EJS templates (receipts & reports only)
```

---

## API Overview

The backend exposes a RESTful JSON API at `/api/*`. Key resource groups:

| Resource        | Base Path              | Description                                  |
|----------------|------------------------|----------------------------------------------|
| Auth           | `/api/auth`            | Login, logout, current user                  |
| Item           | `/api/item`            | Barcode lookup, item search                  |
| Cart           | `/api/cart`            | Active transaction — scan, void, member      |
| Payment        | `/api/payment`         | Payment processing, EDC, QRIS               |
| Transaction    | `/api/transaction`     | Completed transaction history, void, reprint |
| Daily          | `/api/daily`           | Daily open/close, cash balance               |
| Report         | `/api/report`          | Sales summary, Z-report, settlement          |
| Member         | `/api/member`          | Customer membership lookup                   |
| Promotion      | `/api/promotion`       | Active promotion check per item              |
| Config         | `/api/config`          | Store & terminal configuration               |
| Print          | `/print/*`             | EJS-rendered receipt/report HTML             |
| Health         | `/api/health`          | Server & DB health check                     |

> Full endpoint details are documented in `AI-Agent/AGENT.md` § REST API Endpoint Design.

---

## Socket.IO Real-Time Events

Socket.IO powers the **customer-facing mirror display** — a secondary screen that shows live cart updates, pricing, and QR codes to customers during checkout.

| Direction        | Event               | Purpose                          |
|-----------------|----------------------|----------------------------------|
| Server → Client  | `cart:update`        | Item scanned / removed / voided  |
| Server → Client  | `cart:clear`         | Transaction completed / cancelled|
| Server → Client  | `payment:qr`        | QR code for QRIS payment         |
| Server → Client  | `payment:complete`   | Payment finalized, show change   |
| Server → Client  | `display:welcome`    | Welcome message (idle state)     |
| Server → Client  | `display:thankyou`   | Thank you message after payment  |
| Client → Server  | `terminal:register`  | Terminal connects and identifies  |

Terminals join room `terminal:{terminalId}` for scoped event broadcasting.

---

## Hardware Integration

| Device           | Connection          | Protocol              |
|-----------------|---------------------|-----------------------|
| Barcode Scanner  | USB (keyboard wedge)| Keyboard input        |
| Thermal Printer  | USB / Network       | ESC/POS commands      |
| Cash Drawer      | Printer DK port     | ESC/POS kick command  |
| EDC (BCA)        | Serial COM port     | BCA ECR hex protocol  |
| EDC (BRI)        | Serial COM port     | Vendor protocol       |
| EDC (Mandiri)    | Serial COM port     | Vendor protocol       |
| QRIS (BCA)       | Via EDC             | ECR-based QR gen      |
| QRIS (Telkom)    | HTTPS REST API      | JSON request/response |

---

## Security

- **JWT Authentication** — all `/api/*` endpoints (except health & login) require Bearer token
- **bcryptjs** — password hashing for new accounts
- **Helmet** — HTTP security headers
- **CORS** — configurable cross-origin policy
- **Zod** — server-side request validation on all inputs
- **Role-based access** — Supervisor (1), IT (2), Management (3), Cashier (10)
- **Soft delete** — all records use `presence` flag, no hard deletes

---

## License

Private — All rights reserved.