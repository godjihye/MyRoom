'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class UsedFav extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      UsedFav.belongsTo(models.Used,{
        foreignKey:"usedId",
        onDelete: "CASCADE",
        as:"usedFav"
      })

     
    }
  }
  UsedFav.init({
    usedId: DataTypes.INTEGER,
    userId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'UsedFav',
  });
  return UsedFav;
};