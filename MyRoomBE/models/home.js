'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Home extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      
      Home.hasMany(models.Room,{
          foreignKey:"homeId",
          as:"homeRoom"
          
      })
      Home.hasMany(models.User,{
        foreignKey:"homeId",
        as:"homeUser"
        
    })
    }
  }
  Home.init({
    homeName: DataTypes.STRING,
    homeDesc: DataTypes.STRING,
    inviteCode: DataTypes.STRING
  }, {
    sequelize,
    modelName: 'Home',
  });
  return Home;
};