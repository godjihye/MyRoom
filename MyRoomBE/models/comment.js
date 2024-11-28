"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Comment extends Model {
    static associate(models) {
      Comment.belongsTo(models.Post, {
        foreignKey: "id",
        onDelete: "CASCADE",
      });
      Comment.belongsTo(models.User, {
        foreignKey: "id",
        onDelete: "CASCADE",
      });
      Comment.hasMany(models.Comment, {
        foreignKey: "parentId",
        as: "replies",
      });
      Comment.belongsTo(models.Comment, {
        foreignKey: "parentId",
        onDelete: "CASCADE",
      });
    }
  }
  Comment.init(
    {
      postId: DataTypes.INTEGER,
      userId: DataTypes.INTEGER,
      comment: DataTypes.STRING,
      commentGroup: DataTypes.INTEGER,
      parentId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Comment",
    }
  );
  return Comment;
};
