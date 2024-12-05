// postService.js
// Post(게시글) Service

const postDao = require("../dao/postDao");

const createPost = async (postData, photoData) => {
  return await postDao.createPost(postData, photoData);
};

const findPostById = async (id) => {
  return await postDao.findPostById(id);
};

const findAllPost = async (page, pageSize, userId) => {
  return await postDao.findAllPost(page, pageSize, userId);
};

const updatePost = async (id, data) => {
  return await postDao.updatePost(id, data);
};

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
  updatePost,
  deletePost,
  toggleFavorite,
  updateViewCnt,
};
