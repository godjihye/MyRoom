const models = require("../models");

const createLocation = async (data) => {
  return await models.Location.create(data);
};
const findLocationById = async (id) => {
  return await models.Location.findAll({
    where: { roomId: id },
  });
};
const findLocation = async (id) => {
  return await models.Location.findAll({
    where: { id },
  });
};
const updateLocation = async (id, data) => {
  return await models.Location.update(data, {
    where: { id },
  });
};
const deleteLocation = async (id) => {
  return await models.Location.destroy({
    where: { id },
  });
};
module.exports = {
  createLocation,
  findLocationById,
  findLocation,
  updateLocation,
  deleteLocation,
};
