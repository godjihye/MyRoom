const locationService = require("../services/locationService");
const createLocation = async (req, res) => {
  try {
    const location = locationService.createLocation(req.body);
    res.status(201).json({ data: location });
  } catch (e) {
    res.status(500).json({ error: e.error });
  }
};
const findAllLocation = async (req, res) => {
  try {
    const locations = locationService.findAllLocation(req.params.id);
    res.status(200).json({ data: locations });
  } catch (e) {
    res.status(500).json({ error: e.error });
  }
};
const findLocation = async (req, res) => {
  try {
    const location = locationService.findLocation(req.params.id);
    res.status(200).json({ data: location });
  } catch (e) {
    res.status(500).json({ error: e.error });
  }
};
const deleteLocation = async (req, res) => {
  try {
    locationService.deleteLocation(req.params.id);
    res.status(202).json({ success: "true" });
  } catch (e) {
    res.status(500).json({ error: e.error });
  }
};
const updateLocation = async (req, res) => {
  try {
    const result = locationService.updateLocation(req.params.id, req.body);
    res.status(200).json({ data: result });
  } catch (e) {
    res.status(500).json({ error: e.error });
  }
};

module.exports = {
  createLocation,
  findAllLocation,
  findLocation,
  deleteLocation,
  updateLocation,
};
