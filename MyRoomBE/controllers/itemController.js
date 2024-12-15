const itemService = require("../services/itemService");

// 1. Create Item
const createItem = async (req, res) => {
  const itemData = req.body;
  itemData.photo = req.filename;
  itemData.isFav = false;
  console.log(`req.filename: ${req.filename}`);
  try {
    console.log(`{
      success: true,
      message: "아이템을 성공적으로 등록했습니다.",
      item: item,
    }`);
    const item = await itemService.createItem(itemData);
    res.status(201).json({
      success: true,
      message: "아이템을 성공적으로 등록했습니다.",
      item: item,
    });
  } catch (e) {
    console.log(e);
    res.status(500).json({ success: false, error: e.message });
  }
};

// 2. Find Item
// 2-1. Find All Items By LocationId
const findAllItem = async (req, res) => {
  try {
    const items = await itemService.findAllItem(req.params.locationId);
    res.status(200).json({ documents: items });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2-2. Find All Items By HomeId
const findAllItemByHomeId = async (req, res) => {
  console.log(req.query.filterByItemUrl)
  try {
    const result = await itemService.findAllItemByHomeId(req.params.homeId,req.query.filterByItemUrl);
    res.status(200).json({ documents: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2-3. Find All Favorites By HomeId
const findAllFavItem = async (req, res) => {
  try {
    const result = await itemService.findAllFavItem(req.params.homeId);
    res.status(200).json({ documents: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2-4. Find Item By PK
const findItem = async (req, res) => {
  try {
    const item = await itemService.findItem(req.params.itemId);
    res.status(200).json({ documents: item });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2-5. Find Item By ItemName
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

// 3. Update Item
// 3-1. Update Item
const updateItem = async (req, res) => {
  const itemData = req.body;
  itemData.photo = req.filename;
  try {
    const result = await itemService.updateItem(req.params.itemId, itemData);
    res.status(200).json({
      success: true,
      message: "아이템을 성공적으로 수정했습니다.",
      item: result,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

// 3-2. Update Item Add Additional Photos
const updateAdditionalPhotos = async (req, res) => {
  const photos = req.files;
  try {
    const result = await itemService.uploadAdditionalPhotos(
      photos,
      req.params.itemId
    );
    console.log(result);
    res.status(201).json({
      success: true,
      message: "아이템 추가 정보 사진이 성공적으로 등록되었습니다.",
      photos: result,
    });
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
};

// 4. Delete Item
// 4-1. Delete Item
const deleteItem = async (req, res) => {
  try {
    const result = await itemService.deleteItem(req.params.itemId);
    res.status(200).json({ result: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 4-2. Delete Additional Photo
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
  findAllItemByHomeId,
  findAllFavItem,
  findItem,
  findItemByName,
  updateItem,
  updateAdditionalPhotos,
  deleteItem,
  deleteAdditionalPhoto,
};
