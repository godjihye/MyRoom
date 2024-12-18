"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Comment extends Model {
    static associate(models) {
      Comment.belongsTo(models.Post, {
        foreignKey: "postId",
        onDelete: "CASCADE",
        as: "postComments",
      });
      Comment.belongsTo(models.User, {
        foreignKey: "userId",
        onDelete: "CASCADE",
        as: "user",
      });
      Comment.hasMany(models.Comment, {
        foreignKey: "parentId",
        as: "replies",
        onDelete: "SET NULL",
      });
      Comment.belongsTo(models.Comment, {
        foreignKey: "parentId",
        as: "parent",
      });
    }
  }
  Comment.init(
    {
      postId: DataTypes.INTEGER,
      userId: DataTypes.INTEGER,
      comment: DataTypes.STRING,
      parentId: DataTypes.INTEGER,
    },
    {
      sequelize,
      modelName: "Comment",
    }
  );
  return Comment;
};
