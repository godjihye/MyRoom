'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Comment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Comment.belongsTo(models.Post,{
        foreignKey:"id",
        onDelete: "CASCADE",
      })
      Comment.belongsTo(models.User,{
        foreignKey:"id",
        onDelete: "CASCADE",
      })

      // 자기참조 관계 설정
      Comment.hasMany(models.Comment, {
        foreignKey: 'parentId', 
        as: 'replies',
      });
      Comment.belongsTo(models.Comment, {
        foreignKey: 'parentId',
        onDelete: "CASCADE",
      });


    }
  }
  Comment.init({
    postId: DataTypes.INTEGER,
    userId: DataTypes.INTEGER,
    comment: DataTypes.STRING,
    commentGroup: DataTypes.INTEGER,
    parentId: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Comment',
  });
  return Comment;
};