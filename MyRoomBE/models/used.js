'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Used extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Used.hasMany(models.UsedPhoto,{
        foreignKey:"usedId",
        as:"images"
      })

      Used.hasMany(models.UsedFav,{
        foreignKey:"usedId",
        as:"usedFav"
      })

      Used.belongsTo(models.User,{
        foreignKey:"userId",
        onDelete: "CASCADE",
        as:"user"
      })
      
    }
  }
  Used.init({
    usedTitle: DataTypes.STRING,
    usedPrice: DataTypes.INTEGER,
    usedDesc: DataTypes.STRING,
    usedPurchaseDate: DataTypes.DATE,
    usedExpiryDate: DataTypes.DATE,
    usedOpenDate: DataTypes.DATE,
    purchasePrice: DataTypes.INTEGER,
    usedViewCnt: DataTypes.INTEGER,
    usedChatCnt: DataTypes.INTEGER,
    usedFavCnt: DataTypes.INTEGER,
    usedStatus: DataTypes.INTEGER,
    userId: DataTypes.INTEGER,
    usedUrl:DataTypes.STRING,
    usedThumbnail: DataTypes.STRING,
    itemName: DataTypes.STRING,
    itemDesc: DataTypes.STRING,
  }, {
    sequelize,
    modelName: 'Used',
  });
  return Used;
};