const express = require("express");
const locationController = require("../controllers/itemController");
const router = express.Router();

router.post("/", locationController.createItem);
router.get("/:locationId", locationController.findAllItem);
router.get("/detail/:itemId", locationController.findItem);
router.delete("/:itemId", locationController.deleteItem);
router.put("/:itemId", locationController.updateItem);

module.exports = router;
