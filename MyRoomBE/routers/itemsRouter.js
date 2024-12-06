const express = require("express");
const itemController = require("../controllers/itemController");
const router = express.Router();
const upload = require("./uploadImage");
router.post("/", upload.single("photo"));
router.post("/", itemController.createItem);
router.post(
  "/additionalPhoto/:itemId",
  upload.fields([
    { name: "photos", maxCount: 20 }, // 최대 20개의 이미지
  ])
);
router.post("/additionalPhoto/:itemId", itemController.updateAdditionalPhotos);
router.delete(
  "/additionalPhoto/:photoId",
  itemController.deleteAdditionalPhoto
);
router.get("/:locationId", itemController.findAllItem);
router.get("/detail/:itemId", itemController.findItem);
router.post("/search", itemController.findItemByName);
router.delete("/:itemId", itemController.deleteItem);
router.patch("/:itemId", upload.single("photo"));
router.patch("/:itemId", itemController.updateItem);
router.get("/fav/:homeId", itemController.findAllFavItem);
router.get("/allItem/:homeId", itemController.findAllItemByHomeId);

module.exports = router;
