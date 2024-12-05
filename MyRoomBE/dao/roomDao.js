const models = require("../models");

// 1. Room 생성
const createRoom = async (data) => {
  return await models.Room.create(data);
};
// 2. homeId가 id인 유저의 방 전체 조회
const findAllRoom = async (id) => {
  return await models.Room.findAll({
    where: { homeId: id },
  });
};
// 3. room의 id가 id인 방 조회
const findRoom = async (id) => {
  return await models.Room.findAll({
    where: { id },
  });
};
// 4. room의 id가 id인 방 삭제
const deleteRoom = async (id) => {
  return await models.Room.destroy({
    where: { id },
  });
};
// 5. room의 id가 id인 방 업데이트
const updateRoom = async (id, data) => {
  return await models.Room.update(data, {
    where: { id },
  });
};
const getAllRoom = async (id) => {
  try {
    return await models.Room.findAll({
      include: {
        model: models.Location,
        as: "locations",
        attributes: ["id", "locationName", "locationDesc", "roomId"],
      },
      where: { homeId: id },
    });
  } catch (error) {
    console.log(error);
    throw error;
  }
};
module.exports = {
  createRoom,
  findAllRoom,
  findRoom,
  deleteRoom,
  updateRoom,
  getAllRoom,
};
