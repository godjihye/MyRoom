const express = require("express");
const commentController = require("../controllers/commentController");
const router = express.Router();

// 댓글 작성
router.post("/:postId/:userId", commentController.createCommnet);

// 대댓글 작성 
router.post("/reply/:parentId/:postId/:userId",commentController.createReply);

// 댓글 조회
router.get("/:postId",commentController.findAllComment)

// 댓글 수정
router.put("/:id",commentController.updateComment)

// 댓글 삭제 
router.delete("/:id",commentController.deleteCommnet)

module.exports = router;