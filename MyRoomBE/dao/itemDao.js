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
            attributes: ["roomName"],
          },
        ],
      },
    ],
    order: [["updatedAt", "DESC"]],
  });
};
// 2-2. Find All Items By HomeId
const findAllItemByHomeId = async (id) => {
  return await models.Item.findAll({
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
  return await models.Item.findOne({where: {id}, include: [
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
          attributes: ["roomName"],
        },
      ],
    },
  ],
  order: [["updatedAt", "DESC"]]});
};

// 3-1. Item 이름으로 상세 조회 (포함 검색)
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
  return models.ItemPhoto.destroy({
    where: { id },
  });
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
};
