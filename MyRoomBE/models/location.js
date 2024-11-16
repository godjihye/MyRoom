"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Location extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Location.belongsTo(models.Room, {
        foreignKey: "id",
        onDelete: "CASCADE",
      });
      Location.hasMany(models.Item, {
        foreignKey: "id",
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
