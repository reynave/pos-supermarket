require('dotenv').config();

const env = {
  PORT: parseInt(process.env.PORT, 10) || 3000,
  NODE_ENV: process.env.NODE_ENV || 'development',

  DB_HOST: process.env.DB_HOST || 'localhost',
  DB_PORT: parseInt(process.env.DB_PORT, 10) || 3306,
  DB_USER: process.env.DB_USER || 'root',
  DB_PASS: process.env.DB_PASS || '',
  DB_NAME: process.env.DB_NAME || 'pos_supermarket',

  JWT_SECRET: process.env.JWT_SECRET || 'default-secret',
  JWT_EXPIRES_IN: process.env.JWT_EXPIRES_IN || '12h',

  TERMINAL_ID: process.env.TERMINAL_ID || 'T01',
  STORE_OUTLET_ID: process.env.STORE_OUTLET_ID || 'OT99',

  PRINTER_NAME: process.env.PRINTER_NAME || 'POS80',
};

module.exports = env;
