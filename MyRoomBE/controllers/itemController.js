const itemService = require("../services/itemService");

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
      req.body.userId,
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
  try {
    const result = await itemService.updateItem(req.params.itemId, req.body);
    res.status(200).json({ result: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const findAllFavItem = async (req, res) => {
  try {
    const result = await itemService.findAllFavItem(req.params.userId);
    res.status(200).json({ documents: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const findAllItemByUserId = async (req, res) => {
  try {
    const result = await itemService.findAllItemByUserId(req.params.userId);
    res.status(200).json({ documents: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
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
  findAllItemByUserId,
};
