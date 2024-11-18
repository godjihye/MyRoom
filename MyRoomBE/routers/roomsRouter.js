const express = require("express");
const roomController = require("../controllers/roomController");
const router = express.Router();

// 1. Room 생성
router.post("/", roomController.createRoom);
// 2. 한 유저의 Room 전체 조회
router.get("/:userId", roomController.findAllRoom);
// 3. Room 상세 조회
router.get("/detail/:roomId", roomController.findRoom);
// 4. Room 삭제
router.delete("/:roomId", roomController.deleteRoom);
// 5. Room 수정
router.put("/:roomId", roomController.updateRoom);
router.get("/list/:userId", roomController.getAllRoom);
module.exports = router;
