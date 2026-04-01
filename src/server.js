const express = require('express');
const http = require('http');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');

const env = require('./config/env');
const { initSocket } = require('./config/socket');
const pool = require('./config/database');
const errorHandler = require('./middleware/errorHandler');

const authRoutes = require('./routes/auth.routes');
const itemRoutes = require('./routes/item.routes');
const cartRoutes = require('./routes/cart.routes');
const shiftRoutes = require('./routes/shift.routes');
const transactionRoutes = require('./routes/transaction.routes');
const paymentRoutes = require('./routes/payment.routes');

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
app.use('/api/cart', cartRoutes);
app.use('/api/shift', shiftRoutes);
app.use('/api/transactions', transactionRoutes);
app.use('/api/payment', paymentRoutes);

// --- 404 ---
app.use((_req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

// --- Global error handler ---
app.use(errorHandler);

// --- Start server ---
server.listen(env.PORT, () => {
  console.log(`[Server] POS Supermarket API running on http://localhost:${env.PORT}`);
  console.log(`[Server] Environment: ${env.NODE_ENV}`);
});

module.exports = { app, server };
