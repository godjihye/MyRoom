const models = require("../models");

// 0. 유저 찾기
const getUserByUserName = async (data) => {
  return await models.User.findOne({ where: { userName: data } });
};

const getUserByIDExcludePW = async(id)=> {
  return await models.User.findOne({ attributes: ['id', 'userName', 'nickname', 'homeId', 'userImage', 'createdAt', 'updatedAt'], where: { id } });
}

const getUserByUserNameExcludePW = async(userName) => {
  return await models.User.findOne({ attributes: ['id', 'userName', 'nickname', 'homeId', 'userImage', 'createdAt', 'updatedAt'], where: { userName } });
}
// id: homeId
const findMates = async(id)=> {
  return await models.User.findAll({attributes: ['id','userImage', 'nickname'], where: { homeId: id}})
}
// 2. 회원 가입
const createUser = async (data) => {
  return await models.User.create(data);
};

// 4. 회원 탈퇴
const deleteUser = async (id) => {
  return await models.User.destroy({
    where: { id },
  });
};

// 5. 회원 정보 수정
const updateUser = async (id, data) => {
  await models.User.update(data, {
    where: { id },
  });
  return await models.User.findOne({
    attributes: ['id', 'userName', 'nickname', 'homeId', 'userImage', 'createdAt', 'updatedAt'], where: { id }})
};

module.exports = {
  getUserByUserName,
  getUserByIDExcludePW,
  getUserByUserNameExcludePW,
  findMates,
  createUser,
  deleteUser,
  updateUser,
};
