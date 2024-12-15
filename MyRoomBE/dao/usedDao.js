const models = require("../models");
const { Op } = require("sequelize"); // Sequelize operators 가져오기 - search

// write
const createUsed = async (usedData, photoData) => {
  const transaction = await models.sequelize.transaction();
  const userId = usedData.userId;

  try {
    const newUsed = await models.Used.create(usedData, { transaction });
    const usedId = newUsed.id;

    const photos = [];

    for (const field in photoData) {
      if (Array.isArray(photoData[field])) {
        photoData[field].forEach((photo) => {
          if (photo.fieldname == "image") {
            photos.push({
              image: photo.blobName,
              usedId: usedId, // Link to the newly created 'Used' record
            });
          }
        });
      }
    }

    await models.UsedPhoto.bulkCreate(photos, { transaction });

    await transaction.commit();

    const returnData = await models.Used.findByPk(usedId, {
      include: [
        {
          model: models.User,
          as: "user",
          attributes: ["nickname", "userImage"],
        },
        {
          model: models.UsedPhoto,
          as: "images",
          attributes: ["id", "image"],
        },
        {
          model: models.UsedFav,
          as: "usedFav",
          where: { usedId: usedId },
          required: false,
        },
      ],
    });

    return returnData;
  } catch (error) {
    await transaction.rollback();
    throw error;
  }
};

//list
const findAllUsed = async (page, pageSize, userId) => {
  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  return await models.Used.findAndCountAll({
    limit: limit,
    offset: offset,
    order: [["createdAt", "DESC"]],
    include: [
      {
        model: models.User, // 조인할 모델 (Post)
        as: "user", // alias (선택 사항)
      },
      {
        model: models.UsedPhoto,
        as: "images",
      },
      {
        model: models.UsedFav,
        as: "usedFav",
        where: { userId },
        required: false, // LEFT OUTER JOIN
      },
    ],
    attributes: {
      include: [
        [
          models.sequelize.literal(
            `CASE WHEN "usedFav"."userId" IS NOT NULL THEN true ELSE false END`
          ),
          "isFavorite",
        ],
      ],
    },
    distinct: true, // 중복 방지
    subQuery: false,
    //   logging: (sql) => console.log('Executing SQL:', sql)
  });
};

const findUsedByName = async(id,data) => {
  return await models.Used.findAndCountAll({
    where: {
      usedTitle: {
        [Op.like]: `%${data}%`, // data가 포함된 값을 검색
      },
    },
    include: [
      {
        model: models.User, // 조인할 모델 (Post)
        as: "user", // alias (선택 사항)
      },
      {
        model: models.UsedPhoto,
        as: "images",
      },
      {
        model: models.UsedFav,
        as: "usedFav",
        where: { userId:id },
        required: false, // LEFT OUTER JOIN
      },
    ],
    attributes: {
      include: [
        [
          models.sequelize.literal(
            `CASE WHEN "usedFav"."userId" IS NOT NULL THEN true ELSE false END`
          ),
          "isFavorite",
        ],
      ],
    },
    distinct: true, // 중복 방지
    subQuery: false,
    //   logging: (sql) => console.log('Executing SQL:', sql)
  });
}

//detail
const findUsedById = async (id, userId) => {
  return await models.Used.findByPk(id, {
    include: [
      {
        model: models.User, // 조인할 모델 (Post)
        as: "user", // alias (선택 사항)
        attributes: ["nickname", "userImage"], // 가져올 필드 (선택 사항)
      },
      {
        model: models.UsedPhoto,
        as: "images",
      },
      {
        model: models.UsedFav,
        as: "usedFav",
        where: { userId },
        required: false, // LEFT OUTER JOIN
      },
    ],
    attributes: {
      include: [
        [
          models.sequelize.literal(
            `CASE WHEN "usedFav"."userId" IS NOT NULL THEN true ELSE false END`
          ),
          "isFavorite",
        ],
      ],
    },
  });
};

//edit
const updateUsed = async (id, data) => {

  await await models.Used.update(data, {
    where: { id },
  });

  return await models.Used.findOne({ where: { id } });
};

//delete
const deleteUsed = async (id) => {
  return await models.Used.destroy({
    where: { id },
  });
};

//favorite
const toggleFavorite = async (usedId, userId, action) => {
  const used = await models.Used.findByPk(usedId);
  let result;

  if (used) {
    if (action === "add") {
      used.usedFavCnt += 1;
      result = models.UsedFav.create({
        userId: userId,
        usedId: usedId,
        logging: (sql) => console.log("Executing SQL:", sql),
      });
    } else if (action === "remove") {
      console.log("remove 왔어용");
      used.usedFavCnt -= 1;
      result = models.UsedFav.destroy({
        where: { userId: userId, usedId: usedId },
      });
    }
    await used.save();


    return result;
  }
};

//거래상태변경
const updateUsedStatus = async (usedStatus, id) => {
  return await models.Used.update(usedStatus, {
    where: { id },
    logging: (sql) => console.log("Executing SQL:", sql),
  });
};

//조회수 증가
const updateViewCnt = async (id) => {
  const used = await models.Used.findByPk(id);

  if (used) {
    used.usedViewCnt += 1;
  }
  await used.save();

  return used;
};

module.exports = {
  createUsed,
  findAllUsed,
  findUsedByName,
  findUsedById,
  updateUsed,
  deleteUsed,
  toggleFavorite,
  updateUsedStatus,
  updateViewCnt,
};
