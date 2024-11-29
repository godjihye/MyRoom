"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Location extends Model {
    static associate(models) {
      Location.belongsTo(models.Room, {
        foreignKey: "roomId",
        as: "room",
        onDelete: "CASCADE",
      });
      Location.hasMany(models.Item, {
        foreignKey: "locationId",
        as: "items",
        onDelete: "CASCADE",
      });
    }
  }
  Location.init(
    {
      locationName: DataTypes.STRING,
      locationDesc: DataTypes.STRING,
      roomId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Location",
    }
  );
  return Location;
};
