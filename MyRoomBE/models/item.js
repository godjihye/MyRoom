"use strict";

const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Item extends Model {
    static associate(models) {
      Item.belongsTo(models.Location, {
        foreignKey: "locationId",
        as: "location",
        onDelete: "CASCADE",
      });
      Item.hasMany(models.ItemPhoto, {
        foreignKey: "itemId",
        as: "itemPhoto",
        onDelete: "CASCADE",
      });
    }
  }

  Item.init(
    {
      itemName: DataTypes.STRING,
      purchaseDate: DataTypes.DATE,
      expiryDate: DataTypes.DATE,
      url: DataTypes.STRING,
      photo: DataTypes.STRING,
      desc: DataTypes.STRING,
      color: DataTypes.STRING,
      isFav: DataTypes.BOOLEAN,
      price: DataTypes.INTEGER,
      openDate: DataTypes.DATE,
      locationId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Item",
    }
  );
  return Item;
};
