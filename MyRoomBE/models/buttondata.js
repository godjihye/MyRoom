'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ButtonData extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      ButtonData.belongsTo(models.PostPhoto,{
        foreignKey:"postPhotoId",
        onDelete: "CASCADE",
        as:"btnData"
      })
    }
  }
  ButtonData.init({
    positionX: DataTypes.DOUBLE,
    positionY: DataTypes.DOUBLE,
    itemUrl: DataTypes.STRING,
    postPhotoId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'ButtonData',
  });
  return ButtonData;
};