const models = require("../models");

//홈 생성
const createHome = async (userId, data) => {
  const home = await models.Home.create(data);
  const homeId = home.id;

  const homeUser = await models.User.update(
    { homeId },
    {
      where: { id: userId },
    }
  );

  return home;
};

//홈 조회
const findHomeByPK = async (id) => {
  return await models.Home.findByPk(id, {
    include: [
      {
        model: models.Room,
        as: "homeRoom",
      },
    ],
  });
};

//홈 수정
const updateHome = async (id, data) => {
  return await models.Home.update(data, {
    where: { id },
  });
};

// 초대 코드
const isExistInviteCode = async (data) => {
  return await models.Home.findOne({
    where: { inviteCode: data },
  });
};

// 초대 코드 조회
const findInviteCode = async (id) => {
  return await models.Home.findOne({
    attributes: ["inviteCode"],
    where: { id },
  });
};
module.exports = {
  createHome,
  findHomeByPK,
  updateHome,
  isExistInviteCode,
  findInviteCode,
};
