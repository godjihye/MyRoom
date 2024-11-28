'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Useds', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      usedTitle: {
        type: Sequelize.STRING
      },
      usedPrice: {
        type: Sequelize.INTEGER
      },
      usedDesc: {
        type: Sequelize.STRING
      },
      usedPurchaseDate: {
        type: Sequelize.DATE
      },
      usedExpiryDate: {
        type: Sequelize.DATE
      },
      usedOpenDate: {
        type: Sequelize.DATE
      },
      purchasePrice: {
        type: Sequelize.INTEGER
      },
      usedViewCnt: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      usedChatCnt: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      usedFavCnt: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
      usedStatus: {
        type: Sequelize.INTEGER,
        defaultValue:0
      },
     
      userId: {
        type: Sequelize.INTEGER,
        references: {
          model: "Users",
          key: "id",
        },
      },
      usedUrl: {
        type: Sequelize.STRING
      },
      usedThumbnail: {
        type: Sequelize.STRING
      },
      isFavorite: {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
      },
      itemName: {
        type: Sequelize.STRING
      },
      itemDesc: {
        type: Sequelize.STRING
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
    await queryInterface.dropTable('Useds');
  }
};