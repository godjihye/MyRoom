'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.removeColumn('UsedPhotos', 'usedThumbnail');
    await queryInterface.addColumn('Useds', 'usedThumbnail', {
      type: Sequelize.STRING,
      allowNull: true,
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.addColumn('UsedPhotos', 'usedThumbnail', {
      type: Sequelize.STRING,
      allowNull: true, // 이 필드가 null을 허용할지 설정
    });

    await queryInterface.removeColumn('Useds', 'usedThumbnail');
  }
};
