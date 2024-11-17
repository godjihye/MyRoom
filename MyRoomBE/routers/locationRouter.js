const express = require("express")
const locationController = require("../controllers/locationController");
const { updateLocation } = require("../services/locationService");
const router = express.Router();

/*
createLocation,
    findAllLocation,
    findLocation,
    deleteLocation,
    updateLocation
*/
router.post("/", locationController.createLocation)
router.get("/user/:id", locationController.findAllLocation)
router.get("/:id", locationController.findLocation)
router.delete("/:id", locationController.deleteLocation)
router.put("/:id", locationController.updateLocation)

module.exports = router;