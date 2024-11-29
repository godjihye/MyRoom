const express = require("express");
const usedPhotoController = require("../controllers/usedPhotoController");
// const { authenticateToken } = require("../middleware/auth_middleware");
const router = express.Router();


router.post("/",usedPhotoController.createUsedPhotos)
router.delete("/:id",usedPhotoController.deleteUsedPhotos)


module.exports = router;