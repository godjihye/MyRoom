const locationService = require("../services/locationService");

// 1. Location 생성
const createLocation = async (req, res) => {
  try {
    const location = await locationService.createLocation(req.body);
    res.status(201).json({ location: location });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2. Room하나의 Location 전체 조회
const findAllLocation = async (req, res) => {
  try {
    const locations = await locationService.findAllLocation(req.params.roomId);
    res.status(200).json({ data: locations });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

//3. Location 상세 조회
const findLocation = async (req, res) => {
  try {
    const location = await locationService.findLocation(req.params.locationId);
    res.status(200).json({ data: location });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 4. Location 삭제
const deleteLocation = async (req, res) => {
  try {
    await locationService.deleteLocation(req.params.locationId);
    res.status(202).json({ success: "true" });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 5. Location 수정
const updateLocation = async (req, res) => {
  try {
    const result = await locationService.updateLocation(
      req.params.locationId,
      req.body
    );
    res.status(200).json({ data: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  createLocation,
  findAllLocation,
  findLocation,
  deleteLocation,
  updateLocation,
};
