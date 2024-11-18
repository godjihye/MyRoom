const locationDao = require("../dao/locationDao");

const createLocation = async (data) => {
  return await locationDao.createLocation(data);
};
const findAllLocation = async (id) => {
  return await locationDao.findLocationById(id);
};
const findLocation = async (id) => {
  return await locationDao.findLocation(id);
};
const deleteLocation = async (id) => {
  return await locationDao.deleteLocation(id);
};
const updateLocation = async (id, data) => {
  return await locationDao.updateLocation(id, data);
};

module.exports = {
  createLocation,
  findAllLocation,
  findLocation,
  deleteLocation,
  updateLocation,
};
