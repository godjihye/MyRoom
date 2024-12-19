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
const findAllItemByHomeId = async (id, filterByItemUrl) => {
  return await itemDao.findAllItemByHomeId(id, filterByItemUrl);
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
  const findByQuery = await itemDao.findItemByQuery(id, data);
  const findByName = await itemDao.findItemByName(id, data);
  // 결과를 통합하고 중복 제거
  const combinedItemsMap = new Map();

  // 이름으로 검색된 항목을 Map에 추가
  findByQuery.forEach((item) => {
    combinedItemsMap.set(item.id, item);
  });

  // 사진 텍스트로 검색된 항목을 Map에 추가 (중복된 ID는 덮어쓰기)
  findByName.forEach((item) => {
    combinedItemsMap.set(item.id, item);
  });

  // Map의 값을 배열로 변환
  const combinedItems = Array.from(combinedItemsMap.values());

  return { combinedItems, findByName, findByQuery };
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
