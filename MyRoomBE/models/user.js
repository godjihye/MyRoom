'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      User.hasMany(models.Post,{
        foreignKey:"userId"
      })

      User.hasMany(models.Comment,{
        foreignKey:"userId"
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
    }
  }
  User.init({
    userName: DataTypes.STRING,
    password: DataTypes.STRING,
    nickname: DataTypes.STRING,
    mateId: DataTypes.INTEGER,
    userImage: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'User',
  });
  return User;
};