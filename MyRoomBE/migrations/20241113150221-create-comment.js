'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Comments', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      postId: {
        type: Sequelize.INTEGER,
        allowNull:false,
        references: {
          model: "Posts",
          key: "id",
        },
      },
      userId: {
        type: Sequelize.INTEGER,
        allowNull:false,
        references: {
          model: "Users",
          key: "id",
        },
      },
      comment: {
        type: Sequelize.STRING
      },
      commentGroup: {
        type: Sequelize.INTEGER
      },
      parentId: {
        type: Sequelize.INTEGER
      },
      createdDate: {
        type: Sequelize.DATE
      },
      updatedDate: {
        type: Sequelize.DATE
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Comments');
  }
};