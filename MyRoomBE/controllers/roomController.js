const roomService = require("../services/roomService");

// 1. Create Room
const createRoom = async (req, res) => {
  try {
    const room = await roomService.createRoom(req.body);
    res.status(201).json({ data: room });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2-1. Find Rooms By HomeId
const findAllRoom = async (req, res) => {
  try {
    const rooms = await roomService.findAllRoom(req.params.homeId);
    res.status(200).json({ data: rooms });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2-2. Find Room By PK
const findRoom = async (req, res) => {
  try {
    const room = await roomService.findRoom(req.params.roomId);
    res.status(200).json({ data: room });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 2-3.Find Rooms By HomeId And Location Info
const getAllRoom = async (req, res) => {
  try {
    const result = await roomService.getAllRoom(req.params.homeId);
    if (result) {
      res.status(200).json({ documents: result });
    }
  } catch (e) {
    res.status(500).json({ error: e });
  }
};

// 3. Update Room
const updateRoom = async (req, res) => {
  try {
    const result = await roomService.updateRoom(req.params.roomId, req.body);
    if (result) {
      res.status(200).json({ result: req.body });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

// 4. Delete Room
const deleteRoom = async (req, res) => {
  try {
    const result = await roomService.deleteRoom(req.params.roomId);
    if (result) {
      res.status(200).json({ message: "success" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  createRoom,
  findAllRoom,
  findRoom,
  getAllRoom,
  updateRoom,
  deleteRoom,
};
