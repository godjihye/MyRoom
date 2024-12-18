const models = require("../models");
const { Op } = require("sequelize"); // Sequelize operators 가져오기 - search
// write
const createPost = async (postData, photoData, buttonData) => {
  const transaction = await models.sequelize.transaction();
  const userId = postData.userId;

  try {
    //1. 본문 저장
    const newPost = await models.Post.create(
      postData,
      { transaction },
      { logging: (sql) => console.log("Executing SQL:", sql) }
    );
    const postId = newPost.id;

    const photos = [];
    const buttons = [];

    // 2. 사진 데이터 처리 (이미지와 버튼 저장)
    for (const field in photoData) {
      if (Array.isArray(photoData[field])) {
        
        for (let index = 0; index < photoData[field].length; index++) {
          const photo = photoData[field][index];

          if (photo.fieldname === "image") {
            // 2.1. PostPhoto 테이블에 이미지 정보 저장
            const newPhoto = await models.PostPhoto.create(
              {
                image: photo.blobName,
                postId: postId,
              },
              { transaction }
            );

            console.log("btn start", buttonData);
            console.log(index); // 현재 photo의 index
            
            // 2.2. 해당 이미지에 대한 버튼 데이터 처리
            if (buttonData) {
              try {
                // 버튼 데이터에 대해 index와 매칭하여 처리
                buttonData.forEach((buttonGroup) => {
                  if (buttonGroup.imageIndex === index) { // 버튼 데이터의 imageIndex와 현재 photo의 index 비교
                    // buttonGroup.buttons 배열 순회
                    buttonGroup.buttons.forEach((button) => {
                      buttons.push({
                        postPhotoId: newPhoto.id, // 새로 생성된 PostPhoto ID
                        positionX: button.positionX,
                        positionY: button.positionY,
                        itemUrl: button.itemUrl,
                      });
                    });
                  }
                });
              } catch (error) {
                console.error("Invalid JSON in buttonData:", error);
              }
            }
          }
        }
      }
    }

    // 3. 버튼 데이터 일괄 저장
    await models.ButtonData.bulkCreate(buttons, { transaction });
    
    await transaction.commit(); // 트랜잭션 커밋

    

    const returnData = await models.Post.findByPk(postId, {
      include: [
        {
          model: models.User,
          as: "user",
        },
        {
          model: models.PostPhoto,
          as: "images",
          attributes: ["id", "image"],
          include: [
            {
              model: models.ButtonData,
              as: "btnData",
            },
          ],
        },
        {
          model: models.PostFav,
          as: "postFav",
          where: { userId },
          required: false, //left join
        },
      ],
      attributes: {
        include: [
          [
            models.sequelize.literal(
              `CASE WHEN "postFav"."userId" IS NOT NULL THEN true ELSE false END`
            ),
            "isFavorite",
          ],
        ],
      },
      distinct: true, // 중복 방지
      subQuery: false,
      logging: (sql) => console.log("Executing SQL:", sql),
    });

    return returnData;
  } catch (error) {
    await transaction.rollback();
    throw error;
  }
};

//detail
const findPostById = async (userId,id) => {
  await models.Post.findByPk(id, {
    include: [
      {
        model: models.User,
        as: "user",
      },
      {
        model: models.PostPhoto,
        as: "images",
        attributes: ["id", "image"],
        include: [
          {
            model: models.ButtonData,
            as: "btnData",
          },
        ],
      },
      {
        model: models.PostFav,
        as: "postFav",
        where: { userId },
        required: false, //left join
      },
    ],
    attributes: {
      include: [
        [
          models.sequelize.literal(
            `CASE WHEN "postFav"."userId" IS NOT NULL THEN true ELSE false END`
          ),
          "isFavorite",
        ],
      ],
    },
    distinct: true, // 중복 방지
    subQuery: false,
    logging: (sql) => console.log("Executing SQL:", sql),
  });
};

//list
const findAllPost = async (page, pageSize, userId) => {
  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  return await models.Post.findAndCountAll({
    limit: limit,
    offset: offset,
    order: [["createdAt", "DESC"]],
    include: [
      {
        model: models.User,
        as: "user",
      },
      {
        model: models.PostPhoto,
        as: "images",
        attributes: ["id", "image"],
        include: [
          {
            model: models.ButtonData,
            as: "btnData",
          },
        ],
      },
      {
        model: models.PostFav,
        as: "postFav",
        where: { userId },
        required: false, //left join
      },
    ],
    attributes: {
      include: [
        [
          models.sequelize.literal(
            `CASE WHEN "postFav"."userId" IS NOT NULL THEN true ELSE false END`
          ),
          "isFavorite",
        ],
      ],
    },
    distinct: true, // 중복 방지
    subQuery: false,
    logging: (sql) => console.log("Executing SQL:", sql),
  });
};

const findPostByName = async (id, data) => {
  return await models.Post.findAll({
    where: {
      postTitle: {
        [Op.like]: `%${data}%`, // data가 포함된 값을 검색
      },
    },
    include: [
      {
        model: models.User,
        as: "user",
      },
      {
        model: models.PostPhoto,
        as: "images",
        attributes: ["id", "image"],
        include: [
          {
            model: models.ButtonData,
            as: "btnData",
          },
        ],
      },
      {
        model: models.PostFav,
        as: "postFav",
        where: { userId: id },
        required: false, //left join
      },
    ],
    attributes: {
      include: [
        [
          models.sequelize.literal(
            `CASE WHEN "postFav"."userId" IS NOT NULL THEN true ELSE false END`
          ),
          "isFavorite",
        ],
      ],
    },
    distinct: true, // 중복 방지
    subQuery: false,
  });
};

//edit
const updatePost = async (id,postData) => {
  const userId = postData.userId
  await models.Post.update(postData, {
    where: {
      id,
    },
  });

  const returnData = await models.Post.findByPk(id, {
    include: [
      {
        model: models.User,
        as: "user",
      },
      {
        model: models.PostPhoto,
        as: "images",
        attributes: ["id", "image"],
        include: [
          {
            model: models.ButtonData,
            as: "btnData",
          },
        ],
      },
      {
        model: models.PostFav,
        as: "postFav",
        where: { userId },
        required: false, //left join
      },
    ],
    attributes: {
      include: [
        [
          models.sequelize.literal(
            `CASE WHEN "postFav"."userId" IS NOT NULL THEN true ELSE false END`
          ),
          "isFavorite",
        ],
      ],
    },
    distinct: true, // 중복 방지
    subQuery: false,
    logging: (sql) => console.log("Executing SQL:", sql),
  });

  return returnData;
};

const updatePostPhoto = async(postId,photoData,buttonData) => {
  const transaction = await models.sequelize.transaction();
  console.log("PHOTO start", photoData);
  console.log("btn start", buttonData);

  let buttons = [];

  for(const field in photoData) {
    console.log("zzz")
    console.log(photoData[field])
  }
      
      for (let index = 0; index < photoData.length; index++) {
        const photo = photoData[index]
        console.log("photo",photo)
        if (photo.fieldname === "image") {
          // 2.1. PostPhoto 테이블에 이미지 정보 저장
          const newPhoto = await models.PostPhoto.create(
            {
              image: photo.blobName,
              postId: postId,
            },
            { transaction }
          );

          console.log("btn start", buttonData);
          console.log(index); // 현재 photo의 index
          
          // 2.2. 해당 이미지에 대한 버튼 데이터 처리
          if (buttonData) {
            try {
              // 버튼 데이터에 대해 index와 매칭하여 처리
              buttonData.forEach((buttonGroup) => {
                if (buttonGroup.imageIndex === index) { // 버튼 데이터의 imageIndex와 현재 photo의 index 비교
                  // buttonGroup.buttons 배열 순회
                  buttonGroup.buttons.forEach((button) => {
                    buttons.push({
                      postPhotoId: newPhoto.id, // 새로 생성된 PostPhoto ID
                      positionX: button.positionX,
                      positionY: button.positionY,
                      itemUrl: button.itemUrl,
                    });
                  });
                }
              });
            } catch (error) {
              console.error("Invalid JSON in buttonData:", error);
            }
          }
        }
      }

  // 3. 버튼 데이터 일괄 저장
  const result = await models.ButtonData.bulkCreate(buttons, { transaction });
  await transaction.commit(); // 트랜잭션 커밋

   
    return result;
}

//delete
const deletePost = async (id) => {
  return await models.Post.destroy({
    where: { id },
  });
};

//좋아요
const toggleFavorite = async (postId, userId, action) => {
  const post = await models.Post.findByPk(postId);
  let result;

  if (post) {
    if (action === "add") {
      post.postFavCnt += 1;
      result = models.PostFav.create({
        userId: userId,
        postId: postId,
        logging: (sql) => console.log("Executing SQL:", sql),
      });
    } else if (action === "remove") {
      console.log("remove 왔어용");
      post.postFavCnt -= 1;
      result = models.PostFav.destroy({
        where: { userId: userId, postId: postId },
      });
    }
    await post.save();

    return result;
  }
};

//조회수 증가
const updateViewCnt = async (id) => {
  const post = await models.Post.findByPk(id);

  if (post) {
    post.postViewCnt += 1;
  }
  await post.save();

  return post;
};

module.exports = {
  createPost,
  findPostById,
  findAllPost,
  findPostByName,
  updatePost,
  updatePostPhoto,
  deletePost,
  toggleFavorite,
  updateViewCnt,
};
