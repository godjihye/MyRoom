const express = require("express");
const commentController = require("../controllers/commentController");
const router = express.Router();


router.post("/:id", commentController.createCommnet);
router.post("/:id/:parentId",commentController.createReply);
router.get("/:postId/:parentId",commentController.findAllComment)
router.put("/:id",commentController.updateComment)
router.delete("/:id",commentController.deleteCommnet)

module.exports = router;