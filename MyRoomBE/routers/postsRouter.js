const express = require("express");
const postController = require("../controllers/postController");
// const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();

router.post("/", postController.createPost);
router.get("/:id", postController.findPostById);
router.get("/", postController.findAllPost);
router.put("/:id", postController.updatePost);
router.delete("/:id", postController.deletePost);

module.exports = router;
