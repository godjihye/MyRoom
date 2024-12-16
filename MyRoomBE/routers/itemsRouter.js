const express = require("express");
const itemController = require("../controllers/itemController");
const router = express.Router();
const upload = require("./uploadImage");
const summarizeMiddleware = require("./gptRouter")

// 1. Create Item
router.post("/", upload.single("photo"));
router.post("/", itemController.createItem);

// 2. Read Item
// 2-1. Find All Items By LocationId
router.get("/:locationId", itemController.findAllItem);
// 2-2. Find All Items By HomeId
router.get("/allItem/:homeId", itemController.findAllItemByHomeId);
// 2-3. Find All Favorites By HomeId
router.get("/fav/:homeId", itemController.findAllFavItem);
// 2-4. Find Item By PK
router.get("/detail/:itemId", itemController.findItem);
// 2-5. Find Item By ItemName
router.post("/search", itemController.findItemByName);

// 3. Update Item
// 3-1. Update Item
router.post("/edit/:itemId", upload.single("photo"));
router.post("/edit/:itemId", itemController.updateItem);
router.patch("/:itemId", itemController.updateItem);

// 3-2. Update Item Add Additional Photos
router.post(
  "/additionalPhoto/:itemId",
  upload.fields([{ name: "photos", maxCount: 20 }]), // 이미지 업로드 처리
  summarizeMiddleware, // GPT 요약 처리
  itemController.updateAdditionalPhotos // 최종 데이터베이스 저장 처리
);

// 4. Delete Item
// 4-1. Delete Item
router.delete("/:itemId", itemController.deleteItem);
// 4-2. Delete Additional Photo
router.delete(
  "/additionalPhoto/:photoId",
  itemController.deleteAdditionalPhoto
);

module.exports = router;
