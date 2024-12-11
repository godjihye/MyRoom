// userController.js
//

const userService = require("../services/userService");

// 1. Login
const login = async (req, res) => {
  try {
    const { token, user } = await userService.login(req.body);
    res
      .status(200)
      .json({ success: true, message: "Login Successful", token, user });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

// 2. Register
const createUser = async (req, res) => {
  try {
    const newUser = await userService.createUser(req.body);
    res.status(201).json({
      success: true,
      message: "회원 가입이 완료되었습니다.",
      user: newUser,
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

// 3. Social Login (apple, kakao)
const socialLogin = async (req, res) => {
  try {
    const { token, user } = await userService.socialLogin(req.body.userName);
    res
      .status(200)
      .json({ success: true, message: "social login success", token, user });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

// 4. Find User By PK
const findUser = async (req, res) => {
  try {
    const user = await userService.findUserById(req.params.userId);
    res
      .status(200)
      .json({ success: true, message: "회원 정보 조회 성공", user: user });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
};

// 5. Update User Info
const updateUser = async (req, res) => {
  const userData = req.body;
  userData.userImage = req.filename;
  const userId = req.params.userId;
  try {
    const user = await userService.updateUser(userId, userData);
    res.status(201).json({
      success: true,
      message: "이미지가 성공적으로 업로드되었습니다.",
      user,
    });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
};

// 6. Delete User
const deleteUser = async (req, res) => {
  try {
    const result = await userService.deleteUser(req.params.userId);
    res
      .status(200)
      .json({ success: true, message: "회원 탈퇴가 완료되었습니다." });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const changePW = async (req, res) => {
  const userId = req.params.userId;

  const originPW = req.body.originPW;
  const newPW = req.body.newPW;

  try {
    await userService.changePW(userId, req.body);
    // console.log(result);
    res.status(200).json({ success: true, message: "비밀번호 변경 성공" });
    // if (!result) {
    //   res
    //     .status(404)
    //     .json({ success: false, message: "기존 비밀번호가 틀립니다." });
    // }
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

module.exports = {
  login,
  createUser,
  socialLogin,
  findUser,
  updateUser,
  deleteUser,
  changePW,
};
