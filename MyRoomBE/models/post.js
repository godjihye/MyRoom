'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Post extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Post.belongsTo(models.User,{
        foreignKey:"id",
        onDelete: "CASCADE",
      })

      Post.hasMany(models.PostPhoto,{
        foreignKey:"id"
      })

      Post.hasMany(models.Comment,{
        foreignKey:"id"
      })
    }
  }
  Post.init({
    title: DataTypes.STRING,
    content: DataTypes.STRING,
    itemUrl: DataTypes.STRING,
    postFavCnt: DataTypes.INTEGER,
    thumbnail: DataTypes.STRING,
    postViewCnt: DataTypes.INTEGER,
    userId: DataTypes.INTEGER,
    createdDate: DataTypes.DATE,
    updatedDate: DataTypes.DATE
  }, {
    sequelize,
    modelName: 'Post',
  });
  return Post;
};