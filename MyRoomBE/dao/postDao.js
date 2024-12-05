const models = require("../models");

// write
const createPost = async (postData,photoData) => {
  const transaction = await models.sequelize.transaction();
  const userId = postData.userId
  console.log(postData)

  try{
    const newPost = await models.Post.create(postData,{transaction},{logging: (sql) => console.log('Executing SQL:', sql) });
    const postId = newPost.id;

    const photos = [];

    for (const field in photoData) {
      if (Array.isArray(photoData[field])) {
          photoData[field].forEach(photo => {
              if (photo.fieldname =="image") {
                  photos.push({
                      image: photo.blobName,
                      postId: postId, // Link to the newly created 'Used' record
                  });
              }
          });
      }
  }
  await models.PostPhoto.bulkCreate(photos, {transaction});

  await transaction.commit();

  const returnData = await models.Post.findByPk(postId,{
    include: [
        {
          model: models.User,           
          as: 'user',           
          attributes: ['nickname','userImage'], 
        }
        ,
        {
            model: models.PostPhoto,
            as:"images",
            attributes: ['id','image']
        },
        {
            model: models.PostFav,
            as: "postFav",
            where: { postId:postId },
            required: false,  //left join
        }
      ], 
    })

  return returnData;

  }catch(error) {
    
    await transaction.rollback();
    throw error;
  }

};



//detail
const findPostById = async (id) => {
  return await models.Post.findByPk(id, {
    inclide: { model: models.User },
  });
};
 
//list
const findAllPost = async (page,pageSize,userId) => {
  const limit = pageSize;
  const offset = (page - 1) * pageSize;

  return await models.Post.findAndCountAll({
    limit: limit,
    offset: offset,
    order: [['createdAt', 'DESC']], 
    include: [
      {
        model: models.User,           // 조인할 모델 (Post)
        as: 'user',           // alias (선택 사항)
        attributes: ['nickname','userImage'], // 가져올 필드 (선택 사항)
      },
      {
        model: models.PostPhoto,
        as: "images"
      },
      {
        model: models.PostFav,
        as: "postFav",
        where: { userId },
        required: false, // LEFT OUTER JOIN
    }],
    attributes: {
      include: [
          [
              models.sequelize.literal(`CASE WHEN "postFav"."userId" IS NOT NULL THEN true ELSE false END`),
              'isFavorite',
          ],
      ],
    },
    distinct: true, // 중복 방지
    subQuery: false, 
  logging: (sql) => console.log('Executing SQL:', sql) 
  });
};

//edit
const updatePost = async (id, data) => {
  return await models.Post.update(data, {
    where: { id },
  });
};

//delete 
const deletePost = async (id) => {
  return await models.Post.destroy({
    where: { id },
  });
}


//좋아요
const toggleFavorite = async(postId,userId,action) => {
  const post = await models.Post.findByPk(postId);
  let result;

  if(post) {
      if (action === 'add') {
          post.postFavCnt += 1;
          result = models.PostFav.create({ userId: userId,
              postId: postId,logging: (sql) => console.log('Executing SQL:', sql)} )

      } else if (action === 'remove') {
          console.log("remove 왔어용")
          post.postFavCnt -= 1;
          result = models.PostFav.destroy({
              where: {userId:userId,
                      postId: postId},
            });
      }
      await post.save();

      // const returnData = await models.Post.findByPk(postId,{
      //     include: [
      //         {
      //           model: models.User,           
      //           as: 'user',           
      //           attributes: ['nickname','userImage'], 
      //         }
      //         ,
      //         {
      //             model: models.PostPhoto,
      //             as:"images",
      //             attributes: ['id','image']
      //         },
      //         {
      //             model: models.PostFav,
      //             as: "postFav",
      //             where: { postId:postId },
      //             required: false, 
      //         }
      //       ], 
      //     })

      return result;
  }
}

//조회수 증가
const updateViewCnt = async(id) => {
  const post = await models.Post.findByPk(id);

  if(post) {
      post.postViewCnt += 1;
  }
  await post.save();

  return post;
}
  
module.exports = {
  createPost,
  findPostById,
  findAllPost,
  updatePost,
  deletePost,
  toggleFavorite,
  updateViewCnt
}