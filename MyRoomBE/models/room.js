"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Room extends Model {
    static associate(models) {
      // define association here
      Room.belongsTo(models.Home, {
        foreignKey: "homeId",
        as: "homeRoom",
      });
      Room.hasMany(models.Location, {
        foreignKey: "roomId",
        as: "locations",
        onDelete: "CASCADE",
      });
    }
  }
  Room.init(
    {
      roomName: DataTypes.STRING,
      roomDesc: DataTypes.STRING,
      homeId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Room",
    }
  );
  return Room;
};
