const itemService = require("../services/itemService");

const createItem = async (req, res) => {
  try {
    const item = await itemService.createItem(req.body);
    res.status(201).json({ data: item });
  } catch (e) {
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
const findFavList = async (req, res) => {
  try {
    const result = await itemService.findFavList(req.params.locationId);
    res.status(200).json({ documents: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
module.exports = {
  createItem,
  findAllItem,
  findItem,
  deleteItem,
  updateItem,
  findFavList,
};
