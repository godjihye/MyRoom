const models = require("../models");

// 0. 유저 찾기
const getUserByUserName = async (data) => {
  return models.User.findOne({ where: { userName: data } });
};

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
  return await models.User.update(data, {
    where: { id },
  });
};

module.exports = {
  getUserByUserName,
  createUser,
  deleteUser,
  updateUser,
};
