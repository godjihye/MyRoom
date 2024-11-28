'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    await queryInterface.removeConstraint('UsedFavs', 'UsedFavs_userId_fkey');
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.addConstraint('UsedFavs', {
      fields: ['userId'], // 외래 키가 적용된 컬럼
      type: 'foreign key',
      name: 'UsedFavs_userId_fkey', // 원래 외래 키 이름으로 복구
      references: {
        table: 'Users', // 참조 테이블
        field: 'id',    // 참조 컬럼
      },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    });
  }
};
