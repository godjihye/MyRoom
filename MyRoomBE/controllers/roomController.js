const roomService = require("../services/roomService");

// 1. Room 생성
const createRoom = async (req, res) => {
  try {
    const room = await roomService.createRoom(req.body);
    res.status(201).json({ data: room });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
// 2. 한 유저의 Room 전체 조회
const findAllRoom = async (req, res) => {
  try {
    const rooms = await roomService.findAllRoom(req.params.userId);
    res.status(200).json({ data: rooms });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
// 3. Room 상세 조회
const findRoom = async (req, res) => {
  try {
    const room = await roomService.findRoom(req.params.roomId);
    res.status(200).json({ data: room });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
// 4. Room 삭제
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
// 5. Room 수정
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
module.exports = {
  createRoom,
  findAllRoom,
  findRoom,
  deleteRoom,
  updateRoom,
};
