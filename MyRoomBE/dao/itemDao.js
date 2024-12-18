const models = require("../models");
const { Op } = require("sequelize"); // Sequelize operators 가져오기 - search

// 1. Create Item
const createItem = async (data) => {
  return await models.Item.create(data);
};

// 2. Read Item
// 2-1 Find Items By LocationId
const findAllItem = async (id) => {
  return await models.Item.findAll({
    where: {
      locationId: id,
    },
    include: [
      {
        model: models.ItemPhoto,
        as: "itemPhoto",
        attributes: ["id", "photo", "photoText", "photoTextAI"],
      },
      {
        model: models.Location,
        as: "location",
        attributes: ["locationName"],
        include: [
          {
            model: models.Room,
            as: "room",
            attributes: ["roomName"],
          },
        ],
      },
    ],
    order: [["updatedAt", "DESC"]],
  });
};
// 2-2. Find All Items By HomeId
const findAllItemByHomeId = async (id, filterByItemUrl) => {
  const whereCondition = {};

  if (filterByItemUrl == 1) {
    whereCondition.url = { [models.Sequelize.Op.ne]: null };
  }

  return await models.Item.findAll({
    where: whereCondition,
    include: [
      {
        model: models.ItemPhoto,
        as: "itemPhoto",
        attributes: ["id", "photo", "photoText", "photoTextAI"],
      },
      {
        model: models.Location,
        as: "location",
        attributes: ["locationName"],
        include: [
          {
            model: models.Room,
            as: "room",
            attributes: ["roomName", "homeId"],
            where: { homeId: id },
            required: true,
          },
        ],
        required: true,
      },
    ],
    order: [["updatedAt", "DESC"]],
    //raw: true,
  });
};
// 2-3. Find All Favorites By HomeId
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
            attributes: ["roomName", "homeId"],
            where: { homeId: id },
            required: true,
          },
        ],
        required: true,
      },
    ],
    order: [["updatedAt", "DESC"]],
    //raw: true,
  });
};
// 3. Item 상세 조회
const findItem = async (id) => {
  return await models.Item.findOne({
    where: { id },
    include: [
      {
        model: models.ItemPhoto,
        as: "itemPhoto",
        attributes: ["id", "photo", "photoText", "photoTextAI"],
      },
      {
        model: models.Location,
        as: "location",
        attributes: ["locationName"],
        include: [
          {
            model: models.Room,
            as: "room",
            attributes: ["roomName"],
          },
        ],
      },
    ],
    order: [["updatedAt", "DESC"]],
  });
};

const findItemByName = async (id, data) => {
  return await models.Item.findAll({
    where: {
      itemName: {
        [Op.like]: `%${data}%`, // data가 포함된 값을 검색
      },
    },
    include: [
      {
        model: models.Location,
        as: "location",
        attributes: ["locationName"],
        include: [
          {
            model: models.Room,
            as: "room",
            attributes: ["roomName"],
            where: { homeId: id },
            required: true,
          },
        ],
        required: true,
      },
    ],
  });
};

const findItemByQuery = async (id, data) => {
  return await models.Item.findAll({
    include: [
      {
        model: models.ItemPhoto,
        as: "itemPhoto",
        attributes: ["id", "photo", "photoText", "photoTextAI"],
        where: {
          photoText: {
            [Op.like]: `%${data}%`, // ItemPhoto의 itemPhotoText에 data가 포함된 값
          },
        },
        required: true, // ItemPhoto 조건을 만족하는 경우만 반환
      },
      {
        model: models.Location,
        as: "location", // Item -> Location 관계
        attributes: ["locationName"],
        required: true, // Location은 필수 조건
        include: [
          {
            model: models.Room,
            as: "room", // Location -> Room 관계
            attributes: ["roomName", "homeId"],
            where: {
              homeId: id, // Room의 id가 요청받은 id와 일치
            },
            required: true, // Room 조건을 만족하는 경우만 반환
          },
        ],
      },
    ],
  });
};

// 4. Item 삭제
const deleteItem = async (id) => {
  return await models.Item.destroy({
    where: { id },
  });
};
// 5. Item 수정
const updateItem = async (id, data) => {
  await models.Item.update(data, {
    where: {
      id,
    },
  });
  return await models.Item.findOne({ where: { id } });
};
// 6. Fav Item 조회

const uploadAdditionalPhotos = async (photoData, itemId) => {
  const transaction = await models.sequelize.transaction();
  try {
    const photos = photoData.map((photo) => ({
      photo: photo.blobName,
      photoText: photo.text,
      photoTextAI: photo.textAI,
      itemId: itemId,
    }));
    await models.ItemPhoto.bulkCreate(photos, { transaction });
    await transaction.commit();
    return await findItem(itemId);
  } catch (error) {
    await transaction.rollback();
    throw error;
  }
};

const deleteAdditionalPhoto = async (id) => {
  const item = await models.ItemPhoto.findOne({
    where: { id },
    attributes: ["itemId"],
  });
  await models.ItemPhoto.destroy({
    where: { id },
  });
  return { itemId: item.itemId, id };
};

module.exports = {
  createItem,
  findAllItem,
  findItem,
  findItemByName,
  deleteItem,
  updateItem,
  findAllFavItem,
  findAllItemByHomeId,
  uploadAdditionalPhotos,
  deleteAdditionalPhoto,
  findItemByQuery,
};
