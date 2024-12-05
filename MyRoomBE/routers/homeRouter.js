const express = require("express");
const homeController = require("../controllers/homeController");
const router = express.Router();

router.post("/:userId", homeController.createHome);
router.get("/:userId", homeController.findHomeByPK);
router.put("/:id", homeController.updateHome);

module.exports = router;