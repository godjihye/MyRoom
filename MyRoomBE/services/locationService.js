// locationService.js
// 방 안의 가구 등 위치 Service

const locationDao = require("../dao/locationDao");

// 1. Create Location
const createLocation = async (data) => {
  return await locationDao.createLocation(data);
};

// 2-1. Find Location By RoomId
const findAllLocation = async (id) => {
  return await locationDao.findAllLocation(id);
};

// 2-2. Find Location By PK
const findLocation = async (id) => {
  return await locationDao.findLocation(id);
};

// 3. Update Location
const updateLocation = async (id, data) => {
  return await locationDao.updateLocation(id, data);
};

// 4. Delete Location
const deleteLocation = async (id) => {
  return await locationDao.deleteLocation(id);
};

module.exports = {
  createLocation,
  findAllLocation,
  findLocation,
  updateLocation,
  deleteLocation,
};
