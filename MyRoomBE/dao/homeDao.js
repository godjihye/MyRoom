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
const updateHome = async (homeId, data) => {
  return await models.Home.update(data, {
    where: { id: homeId },
  });
};

// 초대 코드
const isExistInviteCode = async (data) => {
  return await models.Home.findOne({
    where: { inviteCode: data },
  });
};

module.exports = {
  createHome,
  findHomeByPK,
  updateHome,
  isExistInviteCode,
};
