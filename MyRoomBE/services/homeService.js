const homeDao = require("../dao/homeDao");
const userDao = require("../dao/userDao");
const createHome = async (userId, data) => {
  return await homeDao.createHome(userId, data);
};

const findHomeByPK = async (id) => {
  return await homeDao.findHomeByPK(id);
};

const updateHome = async (homeId, data) => {
  return await homeDao.updateHome(homeId, data);
};

const generateInviteCode = async (id) => {
  let inviteCode = "";
  let isUnique = false;

  while (!isUnique) {
    inviteCode = generateCode();

    const existingInviteCode = await homeDao.isExistInviteCode(inviteCode);
    if (!existingInviteCode) {
      isUnique = true;
    }
  }

  await homeDao.updateHome(id, { inviteCode });
  return inviteCode;
};

function generateCode() {
  let code = "";
  const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  for (let i = 0; i < 6; i++) {
    code += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return code;
}

const joinHomeWithInviteCode = async (id, code) => {
  const home = await homeDao.isExistInviteCode(code);
  if (home) {
    await userDao.updateUser(id, { homeId: home.id });
    return home;
  } else {
    throw new Error("집을 찾을 수 없습니다.");
  }
};
module.exports = {
  createHome,
  findHomeByPK,
  updateHome,
  generateInviteCode,
  joinHomeWithInviteCode,
};
