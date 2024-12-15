// itemService.js
// Item의 Service

const itemDao = require("../dao/itemDao");

// 1. Create Item
const createItem = async (data) => {
  return await itemDao.createItem(data);
};

// 2. Read Item
// 2-1 Find Items By LocationId
const findAllItem = async (id) => {
  return await itemDao.findAllItem(id);
};
// 2-2. Find All Items By HomeId
const findAllItemByHomeId = async (id,filterByItemUrl) => {
  return await itemDao.findAllItemByHomeId(id,filterByItemUrl);
};
// 2-3. Find All Favorites By HomeId
const findAllFavItem = async (id) => {
  return await itemDao.findAllFavItem(id);
};
// 2-4. Find Item By PK
const findItem = async (id) => {
  return await itemDao.findItem(id);
};
// 2-5. Find Item By ItemName
const findItemByName = async (id, data) => {
  return await itemDao.findItemByName(id, data);
};

// 3. Update Item
// 3-1. Update Item
const updateItem = async (id, data) => {
  return await itemDao.updateItem(id, data);
};
// 3-2. Update Item Add Additional Photos
const uploadAdditionalPhotos = async (data, id) => {
  return await itemDao.uploadAdditionalPhotos(data, id);
};

// 4. Delete Item
// 4-1. Delete Item
const deleteItem = async (id) => {
  return await itemDao.deleteItem(id);
};
// 4-2. Delete Additional Photo
const deleteAdditionalPhoto = async (id) => {
  return await itemDao.deleteAdditionalPhoto(id);
};

module.exports = {
  createItem,
  findAllItem,
  findAllItemByHomeId,
  findAllFavItem,
  findItem,
  findItemByName,
  updateItem,
  uploadAdditionalPhotos,
  deleteItem,
  deleteAdditionalPhoto,
};
