const express = require("express");
const homeController = require("../controllers/homeController");
const router = express.Router();

// 1. Create Home
router.post("/:userId", homeController.createHome);
// 2-1. Find Home By UserId
router.get("/:userId", homeController.findHomeByPK);
// 2-2. Find Home InviteCode By HomeId
router.get("/inviteCode/:homeId", homeController.findInviteCode);
// 2-3. Refresh InviteCode and Find InviteCode
router.get("/inviteCode/refresh/:homeId", homeController.refreshInviteCode);
// 2-4. Find InviteCode and Join and Find Home
router.post("/inviteCode/:userId", homeController.joinHomeWithInviteCode);
// 3. Update Home
router.put("/:id", homeController.updateHome);
// 4. Delete Home
router.delete("/:id", homeController.deleteHome);
module.exports = router;
