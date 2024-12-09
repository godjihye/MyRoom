const express = require("express");
const router = express.Router();
const upload = require("./uploadImage");
const jwt = require("jsonwebtoken");
const { RequestPolicyOptions } = require("@azure/storage-blob");
const secret = process.env.JWT_SECRET;

const userController = require("../controllers/userController");

// 1. 로그인
router.post("/sign-in", userController.login);

// 2. 회원가입
router.post("/sign-up", userController.createUser);

// 3. 소셜 로그인
router.post("/social/login", userController.socialLogin);

// 4. 회원정보 조회
router.get("/info/:userId", userController.findUser);

// 5. 회원정보 수정
router.post("/:userId", upload.single("userImage"));
router.post("/:userId", userController.updateUser);

// 6. 회원탈퇴
router.delete("/:userId", userController.deleteUser);

module.exports = router;

// router.post("/regist-apns", async (req, res, next) => {
//   console.log(req.body);
//   const { userName, deviceToken } = req.body;
//   try {
//     const result = await User.update(
//       { deviceToken: deviceToken },
//       { where: { userName: userName } }
//     );
//     if (result) {
//       res.status(200).json({
//         success: true,
//         member: {
//           userName: userName,
//         },
//         message: "device token 등록에 성공했습니다.",
//       });
//     } else {
//       res.status(404).json({
//         message: "존재하지않는 아이디입니다.",
//       });
//     }
//   } catch (err) {
//     next(err);
//   }
// });
