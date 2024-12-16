"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class UsedPhoto extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      UsedPhoto.belongsTo(models.Used, {
        foreignKey: "usedId",
        onDelete: "CASCADE",
        as: "images",
      });
    }
  }
  UsedPhoto.init(
    {
      image: DataTypes.STRING,
      usedId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "UsedPhoto",
    }
  );
  return UsedPhoto;
};
