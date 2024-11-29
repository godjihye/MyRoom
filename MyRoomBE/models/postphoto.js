'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class PostPhoto extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      PostPhoto.belongsTo(models.Post,{
        foreignKey:"postId",
        onDelete: "CASCADE",
      })
    }
  }
  PostPhoto.init({
    image: DataTypes.STRING,
    postId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'PostPhoto',
  });
  return PostPhoto;
};