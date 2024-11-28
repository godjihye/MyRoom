const models = require("../models");

// 1. Item 생성
const createItem = async (data) => {
  return await models.Item.create(data);
};
// 2. Item 전체 조회
const findAllItem = async (id) => {
  return await models.Item.findAll({
    where: {
      locationId: id,
    },
    include: [
      {
        model: models.ItemPhoto,
        as: "itemPhoto",
        attributes: ["id", "photo"],
      },
      
    ],
  });
};
// 3. Item 상세 조회
const findItem = async (id) => {
  return await models.Item.findByPk(id);
};
// 4. Item 삭제
const deleteItem = async (id) => {
  return await models.Item.destroy({
    where: { id },
  });
};
// 5. Item 수정
const updateItem = async (id, data) => {
  return await models.Item.update(data, {
    where: {
      id,
    },
  });
};
// 6. Fav Item 조회
const findAllFavItem = async (id) => {
  return await models.Item.findAll({
    where: {
      isFav: true,
    },
    include: [
      {
        model: models.ItemPhoto,
        as: "itemPhoto",
        attributes: ["id", "photo"],
      },
      {
        model: models.Location,
        as: "location",
        attributes: ["locationName"],
        include: [
          {
            model: models.Room,
            as: "room",
            attributes: ["roomName", "userId"],
            where: { userId: id },
            required: true,
          },
        ],
        required: true,
      },
    ],
    //raw: true,
  });
};
// 7.아이템의 추가 정보 사진 조회

module.exports = {
  createItem,
  findAllItem,
  findItem,
  deleteItem,
  updateItem,
  findAllFavItem,
};