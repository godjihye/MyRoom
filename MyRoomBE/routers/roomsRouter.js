const express = require("express");
const roomController = require("../controllers/roomController");
const router = express.Router();

// 1. Create Room
router.post("/", roomController.createRoom);
// 2-1. Find Rooms By HomeId
router.get("/:homeId", roomController.findAllRoom);
// 2-2. Find Room By PK
router.get("/detail/:roomId", roomController.findRoom);
// 2-3.Find Rooms By HomeId And Location Info
router.get("/list/:homeId", roomController.getAllRoom);
// 3. Update Room
router.put("/:roomId", roomController.updateRoom);
// 4. Delete Room
router.delete("/:roomId", roomController.deleteRoom);

module.exports = router;
