const models = require("../models");

// 1. Create Room
const createRoom = async (data) => {
  return await models.Room.create(data);
};

// 2-1. Find Rooms By HomeId
const findAllRoom = async (id) => {
  return await models.Room.findAll({
    where: { homeId: id },
  });
};

// 2-2. Find Room By PK
const findRoom = async (id) => {
  return await models.Room.findAll({
    where: { id },
  });
};

// 2-3.Find Rooms By HomeId And Location Info
const getAllRoom = async (id) => {
  try {
    return await models.Room.findAll({
      include: {
        model: models.Location,
        as: "locations",
        attributes: ["id", "locationName", "locationDesc", "roomId"],
      },
      where: { homeId: id },
    });
  } catch (error) {
    throw error;
  }
};

// 3. Update Room
const updateRoom = async (id, data) => {
  return await models.Room.update(data, {
    where: { id },
  });
};

// 4. Delete Room
const deleteRoom = async (id) => {
  return await models.Room.destroy({
    where: { id },
  });
};

module.exports = {
  createRoom,
  findAllRoom,
  findRoom,
  getAllRoom,
  updateRoom,
  deleteRoom,
};
