const promotionService = require('../services/promotion.service');
const promotionFreeService = require('../services/promotion-free.service');
const promotionItemService = require('../services/promotion-item.service');
const { success, error } = require('../utils/response');

function getActorId(req) {
  return req.user?.userId || req.user?.id || null;
}

/**
 * PROMOTION HEADER ENDPOINTS
 */

async function listPromotions(req, res, next) {
  try {
    const { q = '', page = '1', limit = '20' } = req.query;
    const result = await promotionService.listPromotions({
      q,
      page: Number.parseInt(page, 10) || 1,
      limit: Number.parseInt(limit, 10) || 20,
    });

    return success(res, result, 'Promotions loaded');
  } catch (err) {
    next(err);
  }
}

async function getPromotionById(req, res, next) {
  try {
    const result = await promotionService.getPromotionById(req.params.id);
    if (!result) {
      return error(res, 'Promotion not found', 404);
    }

    return success(res, result, 'Promotion detail loaded');
  } catch (err) {
    next(err);
  }
}

async function createPromotion(req, res, next) {
  try {
    const created = await promotionService.createPromotion(req.body, getActorId(req));
    return success(res, created, 'Promotion created', 201);
  } catch (err) {
    next(err);
  }
}

async function updatePromotion(req, res, next) {
  try {
    const updated = await promotionService.updatePromotion(
      req.params.id,
      req.body,
      getActorId(req)
    );
    return success(res, updated, 'Promotion updated');
  } catch (err) {
    next(err);
  }
}

async function deletePromotion(req, res, next) {
  try {
    await promotionService.deletePromotion(req.params.id, getActorId(req));
    return success(res, null, 'Promotion deleted');
  } catch (err) {
    next(err);
  }
}

/**
 * PROMOTION_FREE ENDPOINTS
 */

async function listPromotionFree(req, res, next) {
  try {
    const result = await promotionFreeService.listByPromotionId(req.params.promotionId);
    return success(res, result, 'Promotion_free items loaded');
  } catch (err) {
    next(err);
  }
}

async function getPromotionFreeById(req, res, next) {
  try {
    const result = await promotionFreeService.getById(req.params.id);
    if (!result) {
      return error(res, 'Promotion_free not found', 404);
    }

    return success(res, result, 'Promotion_free detail loaded');
  } catch (err) {
    next(err);
  }
}

async function createPromotionFree(req, res, next) {
  try {
    const created = await promotionFreeService.create(req.body, getActorId(req));
    return success(res, created, 'Promotion_free created', 201);
  } catch (err) {
    next(err);
  }
}

async function updatePromotionFree(req, res, next) {
  try {
    const updated = await promotionFreeService.update(
      req.params.id,
      req.body,
      getActorId(req)
    );
    return success(res, updated, 'Promotion_free updated');
  } catch (err) {
    next(err);
  }
}

async function deletePromotionFree(req, res, next) {
  try {
    await promotionFreeService.delete(req.params.id, getActorId(req));
    return success(res, null, 'Promotion_free deleted');
  } catch (err) {
    next(err);
  }
}

/**
 * PROMOTION_ITEM ENDPOINTS
 */

async function listPromotionItem(req, res, next) {
  try {
    const result = await promotionItemService.listByPromotionId(req.params.promotionId);
    return success(res, result, 'Promotion_item items loaded');
  } catch (err) {
    next(err);
  }
}

async function getPromotionItemById(req, res, next) {
  try {
    const result = await promotionItemService.getById(req.params.id);
    if (!result) {
      return error(res, 'Promotion_item not found', 404);
    }

    return success(res, result, 'Promotion_item detail loaded');
  } catch (err) {
    next(err);
  }
}

async function createPromotionItem(req, res, next) {
  try {
    const created = await promotionItemService.create(req.body, getActorId(req));
    return success(res, created, 'Promotion_item created', 201);
  } catch (err) {
    next(err);
  }
}

async function updatePromotionItem(req, res, next) {
  try {
    const updated = await promotionItemService.update(
      req.params.id,
      req.body,
      getActorId(req)
    );
    return success(res, updated, 'Promotion_item updated');
  } catch (err) {
    next(err);
  }
}

async function deletePromotionItem(req, res, next) {
  try {
    await promotionItemService.delete(req.params.id, getActorId(req));
    return success(res, null, 'Promotion_item deleted');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  // Promotion
  listPromotions,
  getPromotionById,
  createPromotion,
  updatePromotion,
  deletePromotion,
  // Promotion_free
  listPromotionFree,
  getPromotionFreeById,
  createPromotionFree,
  updatePromotionFree,
  deletePromotionFree,
  // Promotion_item
  listPromotionItem,
  getPromotionItemById,
  createPromotionItem,
  updatePromotionItem,
  deletePromotionItem,
};
