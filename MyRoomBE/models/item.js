"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Item extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Item.belongsTo(models.Location, {
        foreignKey: "locationId",
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
