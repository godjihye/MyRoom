const { where } = require("sequelize");
const models = require("../models");

// 1. Create Location
const createLocation = async (data) => {
  return await models.Location.create(data);
};
// 2-1. Find Location By RoomId
const findAllLocation = async (id) => {
  return await models.Location.findAll({
    where: { roomId: id },
  });
};
// 2-2. Find Location By PK
const findLocation = async (id) => {
  return await models.Location.findByPk(id);
};
// 3. Update Location
const updateLocation = async (id, data) => {
  return await models.Location.update(data, {
    where: { id },
  });
};
// 4. Delete Location
const deleteLocation = async (id) => {
  return await models.Location.destroy({
    where: { id },
  });
};

module.exports = {
  createLocation,
  findAllLocation,
  findLocation,
  updateLocation,
  deleteLocation,
};
