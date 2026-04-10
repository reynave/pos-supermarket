const pool = require('../config/database');

class PromotionService {
  /**
   * Generate next promotion ID using auto_number table
   */
  async generatePromotionId() {
    const conn = await pool.getConnection();
    try {
      await conn.beginTransaction();

      const [autoNum] = await conn.query(
        'SELECT runningNumber FROM auto_number WHERE name = ?',
        ['promotion']
      );

      if (!autoNum || autoNum.length === 0) {
        throw new Error('Promotion auto_number not found');
      }

      const nextNum = autoNum[0].runningNumber + 1;
      const paddedNum = String(nextNum).padStart(6, '0');
      const promotionId = `PR${paddedNum}`;

      // Update auto_number
      await conn.query(
        'UPDATE auto_number SET runningNumber = ?, updateDate = NOW() WHERE name = ?',
        [nextNum, 'promotion']
      );

      await conn.commit();
      return promotionId;
    } catch (err) {
      await conn.rollback();
      throw err;
    } finally {
      conn.release();
    }
  }

  /**
   * List promotions with search by code & description
   */
  async listPromotions({ q = '', page = 1, limit = 20 }) {
    const safePage = Math.max(1, Number(page) || 1);
    const safeLimit = Math.min(100, Math.max(1, Number(limit) || 20));
    const offset = (safePage - 1) * safeLimit;
    const trimmedQuery = String(q || '').trim();
    const searchTerm = `%${trimmedQuery}%`;
    const hasSearch = trimmedQuery.length > 0;

    try {
      const [totalRows] = hasSearch
        ? await pool.query(
            `SELECT COUNT(*) AS total FROM promotion
             WHERE presence = 1 AND (
               COALESCE(code, '') LIKE ? OR COALESCE(description, '') LIKE ?
             )`,
            [searchTerm, searchTerm]
          )
        : await pool.query(
            `SELECT COUNT(*) AS total FROM promotion
             WHERE presence = 1`
          );

      const [rows] = hasSearch
        ? await pool.query(
            `SELECT p.*,
              (SELECT COUNT(*) FROM promotion_free WHERE promotionId = p.id AND presence = 1) AS freeCount,
              (SELECT COUNT(*) FROM promotion_item WHERE promotionId = p.id AND presence = 1) AS itemCount
             FROM promotion p
             WHERE p.presence = 1 AND (
               COALESCE(p.code, '') LIKE ? OR COALESCE(p.description, '') LIKE ?
             )
             ORDER BY p.inputDate DESC, p.id DESC
             LIMIT ? OFFSET ?`,
            [searchTerm, searchTerm, safeLimit, offset]
          )
        : await pool.query(
            `SELECT p.*,
              (SELECT COUNT(*) FROM promotion_free WHERE promotionId = p.id AND presence = 1) AS freeCount,
              (SELECT COUNT(*) FROM promotion_item WHERE promotionId = p.id AND presence = 1) AS itemCount
             FROM promotion p
             WHERE p.presence = 1
             ORDER BY p.inputDate DESC, p.id DESC
             LIMIT ? OFFSET ?`,
            [safeLimit, offset]
          );

      return {
        promotions: rows.map(row => this._mapPromotionRow(row)),
        total: Number(totalRows[0].total || 0),
        page: safePage,
        limit: safeLimit,
        totalPages: Math.ceil(Number(totalRows[0].total || 0) / safeLimit),
      };
    } catch (err) {
      throw new Error(`Failed to list promotions: ${err.message}`);
    }
  }

  /**
   * Get promotion by ID
   */
  async getPromotionById(id) {
    try {
      const [rows] = await pool.query(
        'SELECT * FROM promotion WHERE id = ? AND presence = 1',
        [id]
      );

      if (rows.length === 0) {
        return null;
      }

      return this._mapPromotionRow(rows[0]);
    } catch (err) {
      throw new Error(`Failed to get promotion: ${err.message}`);
    }
  }

  /**
   * Create new promotion
   */
  async createPromotion(data, userId) {
    const conn = await pool.getConnection();
    try {
      const promotionId = await this.generatePromotionId();

      const {
        typeOfPromotion,
        code,
        description,
        startDate,
        endDate,
        discountPercent,
        discountAmount,
        Mon = 1,
        Tue = 1,
        Wed = 1,
        Thu = 1,
        Fri = 1,
        Sat = 1,
        Sun = 1,
      } = data;

      await conn.query(
        `INSERT INTO promotion 
         (id, typeOfPromotion, code, description, startDate, endDate, 
          discountPercent, discountAmount, Mon, Tue, Wed, Thu, Fri, Sat, Sun, 
          status, presence, inputDate, inputBy, updateDate, updateBy) 
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1, NOW(), ?, NOW(), ?)`,
        [
          promotionId,
          typeOfPromotion,
          code || null,
          description,
          startDate,
          endDate,
          discountPercent || null,
          discountAmount || null,
          Mon,
          Tue,
          Wed,
          Thu,
          Fri,
          Sat,
          Sun,
          userId,
          userId,
        ]
      );

      return this.getPromotionById(promotionId);
    } catch (err) {
      throw new Error(`Failed to create promotion: ${err.message}`);
    } finally {
      conn.release();
    }
  }

  /**
   * Update promotion
   */
  async updatePromotion(id, data, userId) {
    try {
      const existing = await this.getPromotionById(id);
      if (!existing) {
        throw new Error('Promotion not found');
      }

      const {
        typeOfPromotion,
        code,
        description,
        startDate,
        endDate,
        discountPercent,
        discountAmount,
        Mon = 1,
        Tue = 1,
        Wed = 1,
        Thu = 1,
        Fri = 1,
        Sat = 1,
        Sun = 1,
      } = data;

      await pool.query(
        `UPDATE promotion SET 
         typeOfPromotion = ?, code = ?, description = ?, startDate = ?, endDate = ?,
         discountPercent = ?, discountAmount = ?, Mon = ?, Tue = ?, Wed = ?, 
         Thu = ?, Fri = ?, Sat = ?, Sun = ?, updateDate = NOW(), updateBy = ?
         WHERE id = ?`,
        [
          typeOfPromotion,
          code || null,
          description,
          startDate,
          endDate,
          discountPercent || null,
          discountAmount || null,
          Mon,
          Tue,
          Wed,
          Thu,
          Fri,
          Sat,
          Sun,
          userId,
          id,
        ]
      );

      return this.getPromotionById(id);
    } catch (err) {
      throw new Error(`Failed to update promotion: ${err.message}`);
    }
  }

  /**
   * Delete (soft delete) promotion
   */
  async deletePromotion(id, userId) {
    try {
      const existing = await this.getPromotionById(id);
      if (!existing) {
        throw new Error('Promotion not found');
      }

      await pool.query(
        'UPDATE promotion SET presence = 0, updateDate = NOW(), updateBy = ? WHERE id = ?',
        [userId, id]
      );

      // Also soft-delete related detail rows
      await pool.query(
        'UPDATE promotion_free SET presence = 0, updateDate = NOW(), updateBy = ? WHERE promotionId = ?',
        [userId, id]
      );

      await pool.query(
        'UPDATE promotion_item SET presence = 0, updateDate = NOW(), updateBy = ? WHERE promotionId = ?',
        [userId, id]
      );

      return null;
    } catch (err) {
      throw new Error(`Failed to delete promotion: ${err.message}`);
    }
  }

  /**
   * Map database row to API response format
   */
  _mapPromotionRow(row) {
    return {
      id: row.id,
      typeOfPromotion: row.typeOfPromotion,
      code: row.code,
      description: row.description,
      startDate: row.startDate,
      endDate: row.endDate,
      discountPercent: row.discountPercent,
      discountAmount: row.discountAmount,
      requiredVoucherMinAmount: row.requiredVoucherMinAmount,
      requiredVoucherAllowMultyple: row.requiredVoucherAllowMultyple,
      voucherMinAmount: row.voucherMinAmount,
      voucherAllowMultyple: row.voucherAllowMultyple,
      voucherGiftAmount: row.voucherGiftAmount,
      voucherExpDate: row.voucherExpDate,
      Mon: row.Mon,
      Tue: row.Tue,
      Wed: row.Wed,
      Thu: row.Thu,
      Fri: row.Fri,
      Sat: row.Sat,
      Sun: row.Sun,
      status: row.status,
      presence: row.presence,
      freeCount: Number(row.freeCount || 0),
      itemCount: Number(row.itemCount || 0),
      inputDate: row.inputDate,
      inputBy: row.inputBy,
      updateDate: row.updateDate,
      updateBy: row.updateBy,
    };
  }
}

module.exports = new PromotionService();
