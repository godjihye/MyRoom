const models = require("../models");

const createRoom = async (data) => {
  return await models.Room.create(data);
};
const findRoomById = async (id) => {
  return await models.Room.findByPk(id);
};
const findAllRoom = async () => {
  return await models.Room.findAll();
};
const deleteRoom = async (id) => {
  return await models.Room.destroy({
    where: { id },
  });
};

module.exports = {
  createRoom,
  findRoomById,
  findAllRoom,
  deleteRoom,
};
