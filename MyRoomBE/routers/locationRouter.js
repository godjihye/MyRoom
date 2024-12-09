const express = require("express");
const locationController = require("../controllers/locationController");
const router = express.Router();

// 1. Create Location
router.post("/", locationController.createLocation);
// 2-1. Find Location By RoomId
router.get("/:roomId", locationController.findAllLocation);
// 2-2. Find Location By PK
router.get("/detail/:locationId", locationController.findLocation);
// 3. Update Location
router.put("/:locationId", locationController.updateLocation);
// 4. Delete Location
router.delete("/:locationId", locationController.deleteLocation);

module.exports = router;
