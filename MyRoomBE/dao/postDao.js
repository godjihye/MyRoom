const models = require("../models");

// write
const createPost = async (data) => {
    return await models.Post.create(data);
  };

 
  
  module.exports = {
    createPost
  }