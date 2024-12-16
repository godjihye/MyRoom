// userService.js
// User에 대한 Service

const userDao = require("../dao/userDao");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const secret = process.env.JWT_SECRET;
const expiresIn = "10y";

const createHash = async (password, saltRound) => {
  let hashed = await bcrypt.hash(password, saltRound);
  return hashed;
};

class NotFoundError extends Error {
  constructor(message) {
    super(message);
    this.name = "NotFoundError";
    this.statusCode = 404;
  }
}

// 1. Login
const login = async (data) => {
  const { userName, password } = data;
  const user = await userDao.getUserByUserName(userName);
  if (!user) {
    throw new NotFoundError(
      "로그인에 실패했습니다.\n이메일 주소와 비밀번호를 확인해주세요."
    );
  }
  const isPasswordValid = await bcrypt.compare(password, user.password);
  if (!isPasswordValid) {
    throw new NotFoundError(
      "로그인에 실패했습니다.\n이메일 주소와 비밀번호를 확인해주세요."
    );
  }
  const token = jwt.sign({ userId: user.id }, secret, {
    expiresIn: expiresIn,
  });
  return { token, user };
};

// 2. Register
const createUser = async (data) => {
  const existUser = await userDao.getUserByUserName(data.userName);
  if (!existUser) {
    const newPassword = await createHash(data.password, 10);
    data.password = newPassword;
    return await userDao.createUser(data);
  } else {
    throw new Error("이미 존재하는 아이디입니다.");
  }
};

// 3. Social Login
const socialLogin = async (userName) => {
  let user = await userDao.getUserByUserNameExcludePW(userName);
  // 소셜 로그인 계정 정보가 db에 없으면 계정 생성
  if (!user) {
    const nickname = makeRandomNickname();
    user = await userDao.createUser({ userName: userName, nickname: nickname });
  }
  const token = jwt.sign({ userId: user.id }, secret, {
    expiresIn: expiresIn,
  });
  return { token, user };
};

// 4. Find User By PK
const findUserById = async (id) => {
  try {
    const user = await userDao.getUserByIDExcludePW(id);
    if (!user) {
      throw new Error("사용자를 찾을 수 없습니다.");
    }
    const mates = await userDao.findMates(user.homeId);
    const userData = user.toJSON();
    userData.mates = mates;
    return userData;
  } catch (error) {
    throw new Error(error.message);
  }
};

// 5. Update User Info
const updateUser = async (id, data) => {
  return await userDao.updateUser(id, data);
};

// 6. Delete User
const deleteUser = async (id) => {
  return await userDao.deleteUser(id);
};

// 7. Change Password
const changePW = async (id, data) => {
  try {
    const { cpw, npw } = data;
    const user = await userDao.getUserByID(id);
    if (!user) {
      throw new Error("유저를 찾을 수 없습니다.");
    }
    const isPasswordValid = await bcrypt.compare(cpw, user.password);
    if (!isPasswordValid) {
      throw new Error("패스워드가 틀립니다.");
    }
    const newPassword = await createHash(npw, 10);
    const newData = { password: newPassword };
    await userDao.updateUser(id, newData);
  } catch (error) {
    throw new Error(error.message);
  }
};

// Nickname with Random Number
function makeRandomNickname() {
  const randomNum = Math.floor(Math.random() * 1000);
  return "마루미" + randomNum;
}

module.exports = {
  login,
  createUser,
  socialLogin,
  findUserById,
  updateUser,
  deleteUser,
  changePW,
};
