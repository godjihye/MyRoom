// commentService.js
// Comment(Post-Comment)의 Service

const commentDao = require("../dao/commentDao");

const createComment = async (comment, parentId, postId, userId) => {
  return await commentDao.createComment(comment, parentId, postId, userId);
};

const createReply = async (comment, parentId, postId, userId ) => {
  return await commentDao.createReply(comment, parentId, postId, userId );
};

const findAllComment = async (postId) => {
  return await commentDao.findAllComment(postId);
};

const updateComment = async (id, commnet) => {
  return await commentDao.updateComment(id, commnet);
};

const deleteCommnet = async (id) => {
  return await commentDao.deleteCommnet(id);
};

module.exports = {
  createComment,
  createReply,
  findAllComment,
  updateComment,
  deleteCommnet,
};
