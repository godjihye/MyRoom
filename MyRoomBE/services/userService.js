const userDao = require("../dao/userDao");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const secret = process.env.JWT_SECRET;
const expiresIn = "10y";

const createHash = async (password, saltRound) => {
  let hashed = await bcrypt.hash(password, saltRound);
  console.log(hashed);
  return hashed;
};
// 1. login
const login = async (data) => {
  const { userName, password } = data;
  const user = await userDao.getUserByUserName(userName);
  if (!user) {
    throw new Error("유저를 찾을 수 없습니다.");
  }
  const isPasswordValid = bcrypt.hash(password, user.password);
  if (!isPasswordValid) {
    throw new Error("패스워드가 틀립니다.");
  }
  const token = jwt.sign({ userId: user.id }, secret, {
    expiresIn: expiresIn,
  });
  return { token, user };
};

// 2. createUser
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
// 3. logout

// 4. deleteUser
const deleteUser = async (id) => {
  return await userDao.deleteUser(id);
};
// 5. updateUser
const updateUser = async (id, data) => {
  return await userDao.updateUser(id, data);
};

module.exports = {
  login,
  createUser,
  deleteUser,
  updateUser,
};
