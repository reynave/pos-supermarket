const pool = require('../config/database');

class PromotionItemService {
  /**
   * List all promotion_item rows for a promotion
   */
  async listByPromotionId(promotionId) {
    try {
      const [rows] = await pool.query(
        `SELECT pi.*, i.description AS itemDescription
         FROM promotion_item pi
         LEFT JOIN item i ON pi.itemId = i.id
         WHERE pi.promotionId = ? AND pi.presence = 1
         ORDER BY pi.inputDate DESC`,
        [promotionId]
      );

      return rows.map(row => this._mapRow(row));
    } catch (err) {
      throw new Error(`Failed to list promotion_item: ${err.message}`);
    }
  }

  /**
   * Get single promotion_item by ID
   */
  async getById(id) {
    try {
      const [rows] = await pool.query(
        `SELECT pi.*, i.description AS itemDescription
         FROM promotion_item pi
         LEFT JOIN item i ON pi.itemId = i.id
         WHERE pi.id = ? AND pi.presence = 1`,
        [id]
      );

      if (rows.length === 0) {
        return null;
      }

      return this._mapRow(rows[0]);
    } catch (err) {
      throw new Error(`Failed to get promotion_item: ${err.message}`);
    }
  }

  /**
   * Create new promotion_item detail
   */
  async create(data, userId) {
    try {
      const {
        promotionId,
        itemId,
        qtyFrom = 1,
        qtyTo = 99999,
        specialPrice = 0,
        disc1 = 0,
        disc2 = 0,
        disc3 = 0,
        discountPrice = 0,
      } = data;

      if (!promotionId || !itemId) {
        throw new Error('promotionId and itemId are required');
      }

      const [result] = await pool.query(
        `INSERT INTO promotion_item 
         (promotionId, itemId, qtyFrom, qtyTo, specialPrice, disc1, disc2, disc3, discountPrice,
          status, presence, inputDate, inputBy, updateDate, updateBy)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1, NOW(), ?, NOW(), ?)`,
        [
          promotionId,
          itemId,
          qtyFrom,
          qtyTo,
          specialPrice,
          disc1,
          disc2,
          disc3,
          discountPrice,
          userId,
          userId,
        ]
      );

      return this.getById(result.insertId);
    } catch (err) {
      throw new Error(`Failed to create promotion_item: ${err.message}`);
    }
  }

  /**
   * Update promotion_item detail
   */
  async update(id, data, userId) {
    try {
      const existing = await this.getById(id);
      if (!existing) {
        throw new Error('Promotion_item not found');
      }

      const {
        itemId,
        qtyFrom,
        qtyTo,
        specialPrice,
        disc1,
        disc2,
        disc3,
        discountPrice,
      } = data;

      await pool.query(
        `UPDATE promotion_item SET 
         itemId = ?, qtyFrom = ?, qtyTo = ?, specialPrice = ?, 
         disc1 = ?, disc2 = ?, disc3 = ?, discountPrice = ?,
         updateDate = NOW(), updateBy = ?
         WHERE id = ?`,
        [
          itemId,
          qtyFrom || 1,
          qtyTo || 99999,
          specialPrice || 0,
          disc1 || 0,
          disc2 || 0,
          disc3 || 0,
          discountPrice || 0,
          userId,
          id,
        ]
      );

      return this.getById(id);
    } catch (err) {
      throw new Error(`Failed to update promotion_item: ${err.message}`);
    }
  }

  /**
   * Delete (soft delete) promotion_item
   */
  async delete(id, userId) {
    try {
      const existing = await this.getById(id);
      if (!existing) {
        throw new Error('Promotion_item not found');
      }

      await pool.query(
        'UPDATE promotion_item SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ?',
        [userId, id]
      );

      return null;
    } catch (err) {
      throw new Error(`Failed to delete promotion_item: ${err.message}`);
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
      qtyFrom: row.qtyFrom,
      qtyTo: row.qtyTo,
      specialPrice: row.specialPrice,
      disc1: row.disc1,
      disc2: row.disc2,
      disc3: row.disc3,
      discountPrice: row.discountPrice,
      status: row.status,
      presence: row.presence,
      inputDate: row.inputDate,
      inputBy: row.inputBy,
      updateDate: row.updateDate,
      updateBy: row.updateBy,
    };
  }
}

module.exports = new PromotionItemService();
