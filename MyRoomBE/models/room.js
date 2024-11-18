"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Room extends Model {
    static associate(models) {
      // define association here
      Room.belongsTo(models.User, {
        foreignKey: "userId",
        onDelete: "CASCADE",
      });
      Room.hasMany(models.Location, {
        foreignKey: "roomId",
        onDelete: "CASCADE",
      });
    }
  }
  Room.init(
    {
      roomName: DataTypes.STRING,
      roomDesc: DataTypes.STRING,
      userId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Room",
    }
  );
  return Room;
};
