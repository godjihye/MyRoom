'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {

    await queryInterface.removeConstraint('UsedPhotos', 'UsedPhotos_usedId_fkey');
    
    await queryInterface.addConstraint('UsedPhotos', {
      fields: ['usedId'],
      type: 'foreign key',
      name: 'UsedPhotos_usedId_fkey', // 제약 조건의 이름
      references: {
        table: 'Useds', // 참조할 테이블 이름
        field: 'id', // 참조할 필드
      },
      onDelete: 'CASCADE', // 부모 데이터 삭제 시 자식 데이터 삭제
    });
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.removeConstraint('UsedPhotos', 'UsedPhotos_usedId_fkey');
  }
};
