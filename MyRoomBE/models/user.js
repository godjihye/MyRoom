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
        foreignKey:"id"
      })

      User.hasMany(models.Comment,{
        foreignKey:"id"
      })
    }
  }
  User.init({
    userName: DataTypes.STRING,
    password: DataTypes.STRING,
    nickname: DataTypes.STRING,
    mateId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'User',
  });
  return User;
};