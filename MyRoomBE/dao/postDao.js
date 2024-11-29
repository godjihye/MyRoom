const models = require("../models");

// write
const createPost = async (data) => {
    return await models.Post.create(data);
};



//detail
const findPostById = async (id) => {
  return await models.Post.findByPk(id, {
    inclide: { model: models.User },
  });
};
 
//list
const findAllPost = async () => {
  return await models.Post.findAll({
    include: {
      model: models.User,
    },
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

  
module.exports = {
  createPost,
  findPostById,
  findAllPost,
  updatePost,
  deletePost,
}