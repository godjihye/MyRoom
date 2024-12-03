const express = require("express");
const postController = require("../controllers/postController");
const upload = require("./uploadImage");
// const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.post(
    "/",
    upload.fields([
      { name: "image", maxCount: 10 }, // 최대 10개의 이미지
      { name: "postThumbnail", maxCount: 1 }, // 썸네일
    ])
  );

router.post("/", postController.createPost);
// router.get("/:id", postController.findPostById);
router.get("/:userId", postController.findAllPost);
router.put("/:id", postController.updatePost);
router.delete("/:id", postController.deletePost);

router.post("/:postId/favorite", postController.toggleFavorite); // 좋아요 추가
router.delete("/:postId/favorite", postController.toggleFavorite); // 좋아요 제거

router.post("/:id/viewCnt",postController.updateViewCnt) //조회수 증가

module.exports = router;
