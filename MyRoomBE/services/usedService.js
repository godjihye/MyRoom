// usedService.js
// 중고상품(Used)에 대한 Service

const usedDao = require("../dao/usedDao");

const createUsed = async (usedData, photoData) => {
  return await usedDao.createUsed(usedData, photoData);
};

const findAllUsed = async (page, pageSize, userId) => {
  return await usedDao.findAllUsed(page, pageSize, userId);
};

const findUsedById = async (id, userId) => {
  return await usedDao.findUsedById(id, userId);
};

const updateUsed = async (id, data) => {
  return await usedDao.updateUsed(id, data);
};

const deleteUsed = async (id) => {
  return await usedDao.deleteUsed(id);
};

const toggleFavorite = async (usedId, userId, action) => {
  return await usedDao.toggleFavorite(usedId, userId, action);
};

const updateUsedStatus = async (usedStatus, id) => {
  return await usedDao.updateUsedStatus(usedStatus, id);
};

const updateViewCnt = async (id) => {
  return await usedDao.updateViewCnt(id);
};

module.exports = {
  createUsed,
  findAllUsed,
  findUsedById,
  updateUsed,
  deleteUsed,
  toggleFavorite,
  updateUsedStatus,
  updateViewCnt,
};
