const models = require("../models");

// 1. Find User

// 1-1. Find User By UserName
const getUserByUserName = async (data) => {
  return await models.User.findOne({ where: { userName: data } });
};

// 1-2. Find User Exclude PW By PK
const getUserByIDExcludePW = async (id) => {
  return await models.User.findOne({
    attributes: [
      "id",
      "userName",
      "nickname",
      "homeId",
      "userImage",
      "createdAt",
      "updatedAt",
    ],
    where: { id },
  });
};

// 1-3. Find User Exclude PW By UserName
const getUserByUserNameExcludePW = async (userName) => {
  return await models.User.findOne({
    attributes: [
      "id",
      "userName",
      "nickname",
      "homeId",
      "userImage",
      "createdAt",
      "updatedAt",
    ],
    where: { userName },
  });
};

// 2. Create User
const createUser = async (data) => {
  return await models.User.create(data);
};

// 5. Update User Info
const updateUser = async (id, data) => {
  await models.User.update(data, {
    where: { id },
  });
  return await models.User.findOne({
    attributes: [
      "id",
      "userName",
      "nickname",
      "homeId",
      "userImage",
      "createdAt",
      "updatedAt",
    ],
    where: { id },
  });
};

// 6. Delete User
const deleteUser = async (id) => {
  return await models.User.destroy({
    where: { id },
  });
};

// Find Mates
const findMates = async (id) => {
  console.log(`id: ${id}`);
  if (id == 0 || id == null) {
    return;
  }
  return await models.User.findAll({
    attributes: ["id", "userImage", "nickname"],
    where: { homeId: id },
    order: [["createdAt", "DESC"]],
  });
};

module.exports = {
  getUserByUserName,
  getUserByIDExcludePW,
  getUserByUserNameExcludePW,
  createUser,
  updateUser,
  deleteUser,
  findMates,
};
