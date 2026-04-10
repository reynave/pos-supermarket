const itemsAdminService = require('../services/items-admin.service');
const { success, error } = require('../utils/response');

function getActorId(req) {
  return req.user?.userId || req.user?.id || null;
}

async function listItems(req, res, next) {
  try {
    const { q = '', page = '1', limit = '20' } = req.query;
    const result = await itemsAdminService.listItems({
      q,
      page: Number.parseInt(page, 10) || 1,
      limit: Number.parseInt(limit, 10) || 20,
    });

    return success(res, result, 'Items loaded');
  } catch (err) {
    next(err);
  }
}

async function getMeta(req, res, next) {
  try {
    const result = await itemsAdminService.getMeta();
    return success(res, result, 'Item metadata loaded');
  } catch (err) {
    next(err);
  }
}

async function getItemById(req, res, next) {
  try {
    const result = await itemsAdminService.getItemById(req.params.id);
    if (!result) {
      return error(res, 'Item not found', 404);
    }

    return success(res, result, 'Item detail loaded');
  } catch (err) {
    next(err);
  }
}

async function createItem(req, res, next) {
  try {
    const created = await itemsAdminService.createItem(req.body, getActorId(req));
    return success(res, created, 'Item created', 201);
  } catch (err) {
    if (err.message === 'Item ID already exists' || err.message.startsWith('Barcode already used:')) {
      return error(res, err.message, 409);
    }
    next(err);
  }
}

async function updateItem(req, res, next) {
  try {
    const updated = await itemsAdminService.updateItem(req.params.id, req.body, getActorId(req));
    return success(res, updated, 'Item updated');
  } catch (err) {
    if (err.message === 'Item not found') {
      return error(res, err.message, 404);
    }
    if (err.message.startsWith('Barcode already used:')) {
      return error(res, err.message, 409);
    }
    next(err);
  }
}

async function deleteItem(req, res, next) {
  try {
    const deleted = await itemsAdminService.deleteItem(req.params.id, getActorId(req));
    if (!deleted) {
      return error(res, 'Item not found', 404);
    }

    return success(res, { id: req.params.id }, 'Item deleted');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  listItems,
  getMeta,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
};