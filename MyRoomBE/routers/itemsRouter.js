const express = require("express");
const itemController = require("../controllers/itemController");
const router = express.Router();

router.post("/", itemController.createItem);
router.get("/:locationId", itemController.findAllItem);
router.get("/detail/:itemId", itemController.findItem);
router.delete("/:itemId", itemController.deleteItem);
router.put("/:itemId", itemController.updateItem);
router.get("/fav/:userId", itemController.findAllFavItem);
module.exports = router;
