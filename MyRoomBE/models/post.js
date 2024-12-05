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
        foreignKey:"userId",
        onDelete: "CASCADE",
        as:"user"
      })

      Post.hasMany(models.PostPhoto,{
        foreignKey:"postId",
        as:"images"
      })

      Post.hasMany(models.Comment,{
        foreignKey:"postId",
        onDelete:"CASCADE",
        as:"commnet"
      })

      Post.hasMany(models.PostFav,{
        foreignKey:"postId",
        as: "postFav"
      })
    }
  }
  Post.init({
    postTitle: DataTypes.STRING,
    postContent: DataTypes.STRING,
    itemUrl: DataTypes.STRING,
    postFavCnt: DataTypes.INTEGER,
    postThumbnail: DataTypes.STRING,
    postViewCnt: DataTypes.INTEGER,
    userId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Post',
  });
  return Post;
};