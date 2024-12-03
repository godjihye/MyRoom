// commentService.js
// Comment(Post-Comment)의 Service

const commentDao = require("../dao/commentDao");

const createComment = async (data) => {
  return await commentDao.createComment(data);
};

const createReply = async (data) => {
  return await commentDao.createReply(data);
};

const findAllComment = async (data) => {
  return await commentDao.findAllComment(data);
};

const updateComment = async (id, data) => {
  return await commentDao.updateComment(id, data);
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
