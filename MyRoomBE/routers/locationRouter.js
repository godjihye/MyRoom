const express = require("express");
const locationController = require("../controllers/locationController");
const router = express.Router();

// 1. Location 생성
router.post("/", locationController.createLocation);
// 2. 방 하나의 Location 전체 조회
router.get("/:roomId", locationController.findAllLocation);
// 3. Location 상세 조회
router.get("/detail/:locationId", locationController.findLocation);
// 4. Location 삭제
router.delete("/:locationId", locationController.deleteLocation);
// 5. Location tnwjd
router.put("/:locationId", locationController.updateLocation);
// 6. Room의 정보도 담긴 Location 목록 조회
router.get("/list/:userId", locationController.findList);
module.exports = router;
