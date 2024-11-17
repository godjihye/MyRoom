const express = require("express");
const roomController = require("../controllers/roomController");
const router = express.Router();

router.post("/", roomController.createRoom);
router.get("/", roomController.findAllRoom);
router.get("/:id", roomController.findRoomById);
router.delete("/:id", roomController.deleteRoom);
router.put("/:id", roomController.updateRoom);
module.exports = router