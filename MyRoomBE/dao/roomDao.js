const models = require("../models");

const createRoom = async (data) => {
  return await models.Room.create(data);
};
const findRoomByUserId = async (id) => {
  return await models.Room.findAll({
    where: {userId: id}
  });
};
const findAllRoom = async () => {
  return await models.Room.findAll();
};
const deleteRoom = async (id) => {
  return await models.Room.destroy({
    where: { id },
  });
};
const updateRoom = async(id, data) => {
  return await models.Room.update(data,{
    where: {id}
  })
}
module.exports = {
  createRoom,
  findRoomByUserId,
  findAllRoom,
  deleteRoom,
  updateRoom
};
