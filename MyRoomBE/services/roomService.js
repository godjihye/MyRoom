const roomDao = require("../dao/roomDao");

const createRoom = async (data) => {
  return await roomDao.createRoom(data);
};
const findRoomById = async (id) => {
  return await roomDao.findRoomByUserId(id);
};
const findAllRoom = async () => {
  return await roomDao.findAllRoom();
};
const deleteRoom = async (id) => {
  return await roomDao.deleteRoom(id);
};
const updateRoom = async(id, data) => {
  return await roomDao.updateRoom(id, data)
}
module.exports = {
  createRoom,
  findRoomById,
  findAllRoom,
  deleteRoom,
  updateRoom,
};
