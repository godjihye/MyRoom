const itemService = require("../services/itemService");

const createItem = async (req, res) => {
  const itemData = req.body;
  itemData.photo = req.filename;
  console.log(`req.filename: ${req.filename}`);
  try {
    const item = await itemService.createItem(itemData);
    res
      .status(201)
      .json({
        success: true,
        message: "아이템을 성공적으로 등록했습니다.",
        item: item,
      });
  } catch (e) {
    console.log(e);
    res.status(500).json({ success: false, error: e.message });
  }
};

const findAllItem = async (req, res) => {
  try {
    const items = await itemService.findAllItem(req.params.locationId);
    res.status(200).json({ documents: items });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const findItem = async (req, res) => {
  try {
    const item = await itemService.findItem(req.params.itemId);
    res.status(200).json({ documents: item });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const findItemByName = async (req, res) => {
  try {
    const item = await itemService.findItemByName(
      req.body.homeId,
      req.body.query
    );

    res.status(200).json({ documents: item });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const deleteItem = async (req, res) => {
  try {
    const result = await itemService.deleteItem(req.params.itemId);
    res.status(200).json({ result: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const updateItem = async (req, res) => {
  const itemData = req.body;
  itemData.photo = req.filename;

  try {
    const result = await itemService.updateItem(req.params.itemId, itemData);
    res
      .status(200)
      .json({
        success: true,
        message: "아이템을 성공적으로 수정했습니다.",
        item: result,
      });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const findAllFavItem = async (req, res) => {
  try {
    const result = await itemService.findAllFavItem(req.params.homeId);
    res.status(200).json({ documents: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const findAllItemByHomeId = async (req, res) => {
  try {
    const result = await itemService.findAllItemByUserId(req.params.homeId);
    res.status(200).json({ documents: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

/*
const createItem = async (req, res) => {
  const itemData = req.body;
  itemData.photo = req.filename;
  console.log(`req.filename: ${req.filename}`);
  try {
    const item = await itemService.createItem(itemData);
    res.status(201).json({ documents: item });
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
};
*/

const updateAdditionalPhotos = async (req, res) => {
  const photos = req.files;
  try {
    const result = await itemService.uploadAdditionalPhotos(
      photos,
      req.params.itemId
    );
    res.status(201).json({
      success: true,
      message: "아이템 추가 정보 사진이 성공적으로 등록되었습니다.",
      photos: result,
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

const deleteAdditionalPhoto = async (req, res) => {
  try {
    const result = await itemService.deleteAdditionalPhoto(req.params.photoId);
    res.status(200).json({
      success: true,
      message: "성공적으로 삭제되었습니다.",
      data: result,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};
module.exports = {
  createItem,
  findAllItem,
  findItem,
  findItemByName,
  deleteItem,
  updateItem,
  findAllFavItem,
  findAllItemByHomeId,
  updateAdditionalPhotos,
  deleteAdditionalPhoto,
};
