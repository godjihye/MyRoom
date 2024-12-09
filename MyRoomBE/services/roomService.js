// roomService.js
// 사용자의 Room에 대한 Service

const roomDao = require("../dao/roomDao");

// 1. Create Room
const createRoom = async (data) => {
  return await roomDao.createRoom(data);
};
// 2-1. Find Rooms By HomeId
const findAllRoom = async (id) => {
  return await roomDao.findAllRoom(id);
};
// 2-2. Find Room By PK
const findRoom = async (id) => {
  return await roomDao.findRoom(id);
};
// 2-3.Find Rooms By HomeId And Location Info
const getAllRoom = async (id) => {
  return await roomDao.getAllRoom(id);
};
// 3. Update Room
const updateRoom = async (id, data) => {
  return await roomDao.updateRoom(id, data);
};
// 4. Delete Room
const deleteRoom = async (id) => {
  return await roomDao.deleteRoom(id);
};

module.exports = {
  createRoom,
  findAllRoom,
  findRoom,
  getAllRoom,
  updateRoom,
  deleteRoom,
};
