const pool = require('../config/database');

class PromotionFreeService {
  /**
   * List all promotion_free rows for a promotion
   */
  async listByPromotionId(promotionId) {
    try {
      const [rows] = await pool.query(
        `SELECT pf.*, i.description AS itemDescription, fi.description AS freeItemDescription
         FROM promotion_free pf
         LEFT JOIN item i ON pf.itemId = i.id
         LEFT JOIN item fi ON pf.freeItemId = fi.id
         WHERE pf.promotionId = ? AND pf.presence = 1
         ORDER BY pf.inputDate DESC`,
        [promotionId]
      );

      return rows.map(row => this._mapRow(row));
    } catch (err) {
      throw new Error(`Failed to list promotion_free: ${err.message}`);
    }
  }

  /**
   * Get single promotion_free by ID
   */
  async getById(id) {
    try {
      const [rows] = await pool.query(
        `SELECT pf.*, i.description AS itemDescription, fi.description AS freeItemDescription
         FROM promotion_free pf
         LEFT JOIN item i ON pf.itemId = i.id
         LEFT JOIN item fi ON pf.freeItemId = fi.id
         WHERE pf.id = ? AND pf.presence = 1`,
        [id]
      );

      if (rows.length === 0) {
        return null;
      }

      return this._mapRow(rows[0]);
    } catch (err) {
      throw new Error(`Failed to get promotion_free: ${err.message}`);
    }
  }

  /**
   * Create new promotion_free detail
   */
  async create(data, userId) {
    try {
      const {
        promotionId,
        itemId,
        qty,
        freeItemId,
        freeQty,
        applyMultiply = 0,
        scanFree = 0,
        printOnBill = 0,
      } = data;

      if (!promotionId || !itemId || !freeItemId) {
        throw new Error('promotionId, itemId, and freeItemId are required');
      }

      const [result] = await pool.query(
        `INSERT INTO promotion_free 
         (promotionId, itemId, qty, freeItemId, freeQty, applyMultiply, scanFree, printOnBill,
          status, presence, inputDate, inputBy, updateDate, updateBy)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, 1, NOW(), ?, NOW(), ?)`,
        [
          promotionId,
          itemId,
          qty || 0,
          freeItemId,
          freeQty || 0,
          applyMultiply,
          scanFree,
          printOnBill,
          userId,
          userId,
        ]
      );

      return this.getById(result.insertId);
    } catch (err) {
      throw new Error(`Failed to create promotion_free: ${err.message}`);
    }
  }

  /**
   * Update promotion_free detail
   */
  async update(id, data, userId) {
    try {
      const existing = await this.getById(id);
      if (!existing) {
        throw new Error('Promotion_free not found');
      }

      const {
        itemId,
        qty,
        freeItemId,
        freeQty,
        applyMultiply,
        scanFree,
        printOnBill,
      } = data;

      await pool.query(
        `UPDATE promotion_free SET 
         itemId = ?, qty = ?, freeItemId = ?, freeQty = ?, 
         applyMultiply = ?, scanFree = ?, printOnBill = ?,
         updateDate = NOW(), updateBy = ?
         WHERE id = ?`,
        [
          itemId,
          qty || 0,
          freeItemId,
          freeQty || 0,
          applyMultiply,
          scanFree,
          printOnBill,
          userId,
          id,
        ]
      );

      return this.getById(id);
    } catch (err) {
      throw new Error(`Failed to update promotion_free: ${err.message}`);
    }
  }

  /**
   * Delete (soft delete) promotion_free
   */
  async delete(id, userId) {
    try {
      const existing = await this.getById(id);
      if (!existing) {
        throw new Error('Promotion_free not found');
      }

      await pool.query(
        'UPDATE promotion_free SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ?',
        [userId, id]
      );

      return null;
    } catch (err) {
      throw new Error(`Failed to delete promotion_free: ${err.message}`);
    }
  }

  /**
   * Map database row to API response format
   */
  _mapRow(row) {
    return {
      id: row.id,
      promotionId: row.promotionId,
      itemId: row.itemId,
      itemDescription: row.itemDescription,
      qty: row.qty,
      freeItemId: row.freeItemId,
      freeItemDescription: row.freeItemDescription,
      freeQty: row.freeQty,
      applyMultiply: row.applyMultiply,
      scanFree: row.scanFree,
      printOnBill: row.printOnBill,
      status: row.status,
      presence: row.presence,
      inputDate: row.inputDate,
      inputBy: row.inputBy,
      updateDate: row.updateDate,
      updateBy: row.updateBy,
    };
  }
}

module.exports = new PromotionFreeService();
