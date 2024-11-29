const locationDao = require("../dao/locationDao");

// 1. Location 생성
const createLocation = async (data) => {
  return await locationDao.createLocation(data);
};

// 2. Location 전체 조회
const findAllLocation = async (id) => {
  return await locationDao.findAllLocation(id);
};

//3. Location 상세 조회
const findLocation = async (id) => {
  return await locationDao.findLocation(id);
};

// 4. Location 삭제
const deleteLocation = async (id) => {
  return await locationDao.deleteLocation(id);
};

// 5. Location 수정
const updateLocation = async (id, data) => {
  return await locationDao.updateLocation(id, data);
};

// 6.
const findList = async (id) => {
  return await locationDao.findList(id);
};

module.exports = {
  createLocation,
  findAllLocation,
  findLocation,
  deleteLocation,
  updateLocation,
  findList,
};
