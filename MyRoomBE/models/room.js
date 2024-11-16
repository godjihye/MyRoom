"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Room extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Room.belongsTo(models.User, {
        foreignKey: "id",
        onDelete: "CASCADE",
      });
      Room.hasMany(models.Location, {
        foreignKey: "id",
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
