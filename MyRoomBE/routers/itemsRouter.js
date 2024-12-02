const express = require("express");
const itemController = require("../controllers/itemController");
const router = express.Router();
const upload = require("./uploadImage");
router.post("/", upload.single("photo"));
router.post("/", itemController.createItem);
router.get("/:locationId", itemController.findAllItem);
router.get("/detail/:itemId", itemController.findItem);
router.post("/search", itemController.findItemByName);
router.delete("/:itemId", itemController.deleteItem);
router.put("/:itemId", itemController.updateItem);
router.get("/fav/:userId", itemController.findAllFavItem);
router.get("/allItem/:userId", itemController.findAllItemByUserId);
router.post("/test", (req, res) => {
  console.log(req.body);
  console.log(req.filename);
  //res.status(200).json({ body: req.body, photo: req.photo });
});
module.exports = router;
