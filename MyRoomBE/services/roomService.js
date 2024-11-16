const roomDao = require("../dao/roomDao");

const createRoom = async (data) => {
  return await roomDao.createRoom(data);
};
const findRoomById = async (id) => {
  return await roomDao.findRoomById;
};
const findAllRoom = async () => {
  return await roomDao.findAllRoom;
};
const deleteRoom = async (id) => {
  return await roomDao.deleteRoom;
};

module.exports = {
  createRoom,
  findRoomById,
  findAllRoom,
  deleteRoom,
};
