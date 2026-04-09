const pool = require('../config/database');

/**
 * Generate the next sequential code from the auto_number table.
 *
 * Format: {prefix}{padded_runningNumber}
 * Example: name='voucherCode', prefix='VCODE', digit=6, runningNumber=1 → 'VCODE000001'
 * Example: name='reset', prefix='RST', digit=6, runningNumber=258 → 'RST000259'
 *
 * The runningNumber is incremented atomically using SELECT ... FOR UPDATE.
 * Callers inside an existing DB transaction should pass their `conn` so the
 * increment participates in the same transaction (and can be rolled back on error).
 * Callers outside a transaction should omit `conn`; the function will create its
 * own connection and manage the transaction internally.
 *
 * @param {string} name - value of auto_number.name (e.g. 'voucherCode', 'reset')
 * @param {import('mysql2/promise').PoolConnection|null} [conn] - optional existing connection
 * @returns {Promise<string>} generated code
 */
async function generateAutoNumber(name, conn = null) {
  const ownConn = conn === null;
  const connection = ownConn ? await pool.getConnection() : conn;

  try {
    if (ownConn) {
      await connection.beginTransaction();
    }

    const [rows] = await connection.query(
      'SELECT id, prefix, digit, runningNumber FROM auto_number WHERE name = ? FOR UPDATE',
      [name],
    );

    if (!rows.length) {
      throw new Error(`auto_number record not found for name='${name}'`);
    }

    const { id, prefix, digit, runningNumber } = rows[0];
    const nextNumber = Number(runningNumber) + 1;

    await connection.query(
      'UPDATE auto_number SET runningNumber = ?, updateDate = UNIX_TIMESTAMP() WHERE id = ?',
      [nextNumber, id],
    );

    if (ownConn) {
      await connection.commit();
    }

    const padded = String(nextNumber).padStart(Number(digit) || 4, '0');
    return `${prefix || ''}${padded}`;
  } catch (err) {
    if (ownConn) {
      await connection.rollback();
    }
    throw err;
  } finally {
    if (ownConn) {
      connection.release();
    }
  }
}

module.exports = { generateAutoNumber };
