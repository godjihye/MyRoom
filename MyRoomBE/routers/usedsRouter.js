const express = require("express");
const usedController = require("../controllers/usedController");
// const { authenticateToken } = require("../middleware/auth_middleware");
const upload = require("./uploadImage");
const { route } = require("./postsRouter");
const router = express.Router();

router.post(
  "/",
  upload.fields([
    { name: "image", maxCount: 10 }, // 최대 10개의 이미지
    { name: "usedThumbnail", maxCount: 1 }, // 썸네일
  ])
);

router.post("/", usedController.createUsed);
router.get("/:userId", usedController.findAllUsed); //userId
router.get("/detail/:id/:userId", usedController.findUsedById);
router.put("/:id", usedController.updateUsed);
router.delete("/:id", usedController.deleteUsed);

router.post("/:usedId/favorite", usedController.toggleFavorite); // 좋아요 추가
router.delete("/:usedId/favorite", usedController.toggleFavorite); // 좋아요 제거

router.put("/:id/status",usedController.updateUsedStatus) //거래상태 변경
router.post("/:id/viewCnt",usedController.updateViewCnt) //조회수 증가

module.exports = router;
