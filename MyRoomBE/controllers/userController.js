const userService = require("../services/userService");

// 1. 로그인
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

// 2. 회원가입
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

// 4. 회원 탈퇴
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

// 5. 회원 정보 수정
const uploadImage = async (req, res) => {
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

const updateUser = async (req, res) => {
  try {
    const newData = await userService.updateUser(req.params.userId, req.body);
    console.log(req.body);
    res.status(200).json({
      success: true,
      message: "회원 정보가 수정되었습니다.",
      user: newData,
    });
  } catch (e) {
    res.status(500).json({ success: false, error: e.message });
  }
};

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

const socialLogin = async (req, res) => {
  try {
    const { token, user } = await userService.findUserByUserName(
      req.body.userName
    );
    res
      .status(200)
      .json({ success: true, message: "Login Successful", token, user });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

const socialSignUp = async (req, res) => {
  try {
    const data = await userService.socialSignUp(req.body.email);
    res
      .status(200)
      .json({ success: true, message: "카카오 회원가입 성공", user: data });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

module.exports = {
  login,
  createUser,
  deleteUser,
  uploadImage,
  updateUser,
  findUser,
  socialLogin,
  socialSignUp,
};
