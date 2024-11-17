const roomService = require("../services/roomService");
const createRoom = async (req, res) => {
  try {
    const room = await roomService.createRoom(req.body);
    
    res.status(201).json({ data: room });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const findRoomById = async (req, res) => {
  try {
    const room = await roomService.findRoomById(req.params.id);
    if (room) {
      res.status(200).json({ data: room });
    } else {
      res.status(404).json({ error: "Room Not Found" });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
const findAllRoom = async (req, res) => {
  try {
    const rooms = await roomService.findAllRoom();
    res.status(200).json({ data: rooms });
  } catch (e) {
    res.status(500).json({ error: e.error });
  }
};
const deleteRoom = async (req, res) => {
  try {
    const result = await roomService.deleteRoom(req.params.id);
    if (result) {
      res.status(200).json({ message: "success" });
    }
  } catch (e) {
    res.status(500).json({ error: e.error });
  }
};

const updateRoom = async(req, res) => {
  try {
  const result = await roomService.updateRoom(req.params.id, req.body)
  if(result) {
    res.status(200).json({result: req.body})
  } }catch(e) {
    res.status(500).json({error: e.error})
  }
}
module.exports = {
  createRoom,
  findRoomById,
  findAllRoom,
  deleteRoom,
  updateRoom,
};