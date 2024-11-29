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
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'Comments', // 참조할 모델
          key: 'id',          // 참조할 키
        },
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