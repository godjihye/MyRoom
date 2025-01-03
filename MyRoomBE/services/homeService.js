const homeDao = require("../dao/homeDao");
const userDao = require("../dao/userDao");

// 1. home 생성
const createHome = async (userId, data) => {
  const home = await homeDao.createHome(userId, data);
  const newHome = await generateInviteCode(home.id);
  return newHome;
};

// 2. home의 id로 home 찾기
const findHomeByPK = async (id) => {
  return await homeDao.findHomeByPK(id);
};

// 3. home update
const updateHome = async (homeId, data) => {
  return await homeDao.updateHome(homeId, data);
};

// 4. invite code 생성

// Helper Method

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
  const home = await homeDao.updateHome(id, { inviteCode });
  return home;
};

// 중복 x 코드 생성
function generateCode() {
  let code = "";
  const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  for (let i = 0; i < 6; i++) {
    code += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return code;
}

// 4. 초대코드로 조인
const joinHomeWithInviteCode = async (id, code) => {
  const home = await homeDao.isExistInviteCode(code);
  if (home) {
    await userDao.updateUser(id, { homeId: home.id });
    return home;
  } else {
    throw new Error("집을 찾을 수 없습니다.");
  }
};

// 5. 초대코드가 있는지 찾기
const findInviteCode = async (id) => {
  return await homeDao.findInviteCode(id);
};

// 6. 초대코드 재발급
const refreshInviteCode = async (id) => {
  const home = await generateInviteCode(id);
  return home.inviteCode;
};

module.exports = {
  createHome,
  findHomeByPK,
  updateHome,
  generateInviteCode,
  joinHomeWithInviteCode,
  findInviteCode,
  refreshInviteCode,
};
