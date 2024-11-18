const roomDao = require("../dao/roomDao");

// 1. Room 생성
const createRoom = async (data) => {
  return await roomDao.createRoom(data);
};
// 2. 한 유저의 Room 전체 조회
const findAllRoom = async (id) => {
  return await roomDao.findAllRoom(id);
};
// 3. Room 상세 조회
const findRoom = async (id) => {
  return await roomDao.findRoom(id);
};
// 4. Room 삭제
const deleteRoom = async (id) => {
  return await roomDao.deleteRoom(id);
};
// 5. Room 수정
const updateRoom = async (id, data) => {
  return await roomDao.updateRoom(id, data);
};

module.exports = {
  createRoom,
  findAllRoom,
  findRoom,
  deleteRoom,
  updateRoom,
};
