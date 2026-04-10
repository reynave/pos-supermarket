const express = require('express');
const promotionController = require('../controllers/promotion.controller');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

// Apply auth middleware to all promotion routes
router.use(authMiddleware);

/**
 * PROMOTION HEADER ROUTES
 */
router.get('/', promotionController.listPromotions);
router.post('/', promotionController.createPromotion);
router.get('/:id', promotionController.getPromotionById);
router.put('/:id', promotionController.updatePromotion);
router.delete('/:id', promotionController.deletePromotion);

/**
 * PROMOTION_FREE ROUTES
 */
router.get('/:promotionId/free', promotionController.listPromotionFree);
router.post('/:promotionId/free', promotionController.createPromotionFree);
router.get('/free/:id', promotionController.getPromotionFreeById);
router.put('/free/:id', promotionController.updatePromotionFree);
router.delete('/free/:id', promotionController.deletePromotionFree);

/**
 * PROMOTION_ITEM ROUTES
 */
router.get('/:promotionId/item', promotionController.listPromotionItem);
router.post('/:promotionId/item', promotionController.createPromotionItem);
router.get('/item/:id', promotionController.getPromotionItemById);
router.put('/item/:id', promotionController.updatePromotionItem);
router.delete('/item/:id', promotionController.deletePromotionItem);

module.exports = router;
