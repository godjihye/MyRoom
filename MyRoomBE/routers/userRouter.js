const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { RequestPolicyOptions } = require("@azure/storage-blob");
const secret = process.env.JWT_SECRET;

const userController = require("../controllers/userController");

router.post("/sign-in", userController.login);
router.post("/sign-up", userController.createUser);
router.patch("/update/");
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
