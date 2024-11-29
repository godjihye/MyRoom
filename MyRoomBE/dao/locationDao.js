const { where } = require("sequelize");
const models = require("../models");

// 1. Location 생성
const createLocation = async (data) => {
  return await models.Location.create(data);
};
// 2. Location 전체 조회
const findAllLocation = async (id) => {
  return await models.Location.findAll({
    where: { roomId: id },
  });
};
// 3. Location 상세 조회
const findLocation = async (id) => {
  return await models.Location.findByPk(id);
};
// 4. Location 삭제
const deleteLocation = async (id) => {
  return await models.Location.destroy({
    where: { id },
  });
};
// 5. Location 수정
const updateLocation = async (id, data) => {
  return await models.Location.update(data, {
    where: { id },
  });
};
const findList = async (id) => {
  return await models.Location.findAll({
    where: {
      id,
    },
  });
};
module.exports = {
  createLocation,
  findAllLocation,
  findLocation,
  deleteLocation,
  updateLocation,
  findList,
};
