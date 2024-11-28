'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ItemPhoto extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      ItemPhoto.belongsTo(models.Item,{
        foreignKey:"itemId",
        onDelete: "CASCADE",
        as:"item"
      })
    }
  }
  ItemPhoto.init({
    photo: DataTypes.STRING,
    itemId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'ItemPhoto',
  });
  return ItemPhoto;
};