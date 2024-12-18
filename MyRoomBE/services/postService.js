// postService.js
// Post(게시글) Service

const postDao = require("../dao/postDao");

const createPost = async (postData, photoData, buttonData) => {
  return await postDao.createPost(postData, photoData, buttonData);
};

const findPostById = async (userId,id) => {
  return await postDao.findPostById(userId,id);
};

const findAllPost = async (page, pageSize, userId) => {
  return await postDao.findAllPost(page, pageSize, userId);
};

const findPostByName = async (id, data) => {
  return await postDao.findPostByName(id, data);
};

const updatePost = async (postId,postData) => {
  return await postDao.updatePost(postId,postData);
};

const updatePostPhoto = async (id,photoData,buttonData) => {
  return await postDao.updatePostPhoto(id,photoData,buttonData);
}

const deletePost = async (id) => {
  return await postDao.deletePost(id);
};

const toggleFavorite = async (postId, userId, action) => {
  return await postDao.toggleFavorite(postId, userId, action);
};

const updateViewCnt = async (id) => {
  return await postDao.updateViewCnt(id);
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
