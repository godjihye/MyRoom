const express = require("express");
const homeController = require("../controllers/homeController");
const router = express.Router();

router.post("/:userId", homeController.createHome);
router.get("/:userId", homeController.findHomeByPK);
router.put("/:id", homeController.updateHome);
router.get("/inviteCode/:homeId", homeController.findInviteCode);
router.post("/inviteCode/:userId", homeController.joinHomeWithInviteCode);
router.get("/inviteCode/refresh/:homeId", homeController.refreshInviteCode);

module.exports = router;
