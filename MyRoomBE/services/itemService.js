const itemDao = require("../dao/itemDao");

const createItem = async (data) => {
  return await itemDao.createItem(data);
};
const findAllItem = async (id) => {
  return await itemDao.findAllItem(id);
};
const findItem = async (id) => {
  return await itemDao.findItem(id);
};
const deleteItem = async (id) => {
  return await itemDao.deleteItem(id);
};
const updateItem = async (id, data) => {
  return await itemDao.updateItem(id, data);
};

module.exports = {
  createItem,
  findAllItem,
  findItem,
  deleteItem,
  updateItem,
};