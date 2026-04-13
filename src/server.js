const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

const express = require('express');
const http = require('http');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const { initSocket } = require('./config/socket');
const pool = require('./config/database');
const errorHandler = require('./middleware/errorHandler');

const authRoutes = require('./routes/auth.routes');
const itemRoutes = require('./routes/item.routes');
const itemsAdminRoutes = require('./routes/items-admin.routes');
const cartRoutes = require('./routes/cart.routes');
const shiftRoutes = require('./routes/shift.routes');
const dailyCloseRoutes = require('./routes/daily-close.routes');
const manualCashRoutes = require('./routes/manual-cash.routes');
const transactionRoutes = require('./routes/transaction.routes');
const paymentRoutes = require('./routes/payment.routes');
const paymentBcaLanRoutes = require('./routes/payment-bca-lan.routes');
const printRoutes = require('./routes/print.routes');
const voucherRoutes = require('./routes/voucher.routes');
const promotionRoutes = require('./routes/promotion.routes');
const autoNumberRoutes = require('./routes/auto-number.routes');

const app = express();
const server = http.createServer(app);

// --- Socket.IO ---
initSocket(server);

// --- View engine (EJS for reports/print only) ---
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '..', 'views'));

// --- Middleware ---
app.use(helmet({ contentSecurityPolicy: false }));
app.use(cors());
app.use(compression());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '..', 'public')));

// --- Health check ---
app.get('/api/health', async (_req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1');
    res.json({ status: 'ok', db: 'connected', timestamp: new Date().toISOString() });
  } catch (err) {
    res.status(500).json({ status: 'error', db: 'disconnected', message: err.message });
  }
});

// --- API Routes ---
app.use('/api/auth', authRoutes);
app.use('/api/item', itemRoutes);
app.use('/api/items', itemsAdminRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/shift', shiftRoutes);
app.use('/api/daily-close', dailyCloseRoutes);
app.use('/api/manual-cash', manualCashRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/payment', paymentRoutes);
app.use('/api/payment/bca-lan', paymentBcaLanRoutes);
app.use('/api/print', printRoutes);
app.use('/api/voucher', voucherRoutes);
app.use('/api/promotion', promotionRoutes);

if (process.env.NODE_ENV !== 'production') {
  app.use('/api/auto-number', autoNumberRoutes);
}

// --- 404 ---
app.use((_req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

// --- Global error handler ---
app.use(errorHandler);

// --- Start server ---
server.listen(process.env.PORT || 3000, () => {
  console.log(`[Server] POS Supermarket API running on http://localhost:${process.env.PORT || 3000}`);
  console.log(`[Server] Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = { app, server };
