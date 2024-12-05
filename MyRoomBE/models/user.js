"use strict";
const { Model } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    static associate(models) {
      User.hasMany(models.Post,{
        foreignKey:"userId",
        as:"Posts"
      })
      User.hasMany(models.Comment,{
        foreignKey:"userId",
        as:"Commnets"
      })
      User.hasMany(models.Used,{
        foreignKey:"userId",
        as:"Useds"
      })
      User.hasMany(models.UsedFav,{
        foreignKey:"userId",
        as:"userFav"
      })
      User.hasMany(models.PostFav,{
        foreignKey:"userId",
        as:"fav"
      })

      User.belongsTo(models.Home, {
        foreignKey:"homeId",
        as: "homeUser"
      })
    }
  }
  User.init({
    userName: DataTypes.STRING,
    password: DataTypes.STRING,
    nickname: DataTypes.STRING,
    homeId: DataTypes.INTEGER,
    userImage: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'User',
  });
  return User;
};
