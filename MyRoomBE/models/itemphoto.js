"use strict";

const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class ItemPhoto extends Model {
    static associate(models) {
      ItemPhoto.belongsTo(models.Item, {
        foreignKey: "itemId",
        as: "item",
        onDelete: "CASCADE",
      });
    }
  }
  ItemPhoto.init(
    {
      itemId: DataTypes.INTEGER,
      photo: DataTypes.STRING,
      photoText: DataTypes.STRING,
      photoTextAI: DataTypes.STRING,
    },
    {
      sequelize,
      modelName: "ItemPhoto",
    }
  );
  return ItemPhoto;
};
