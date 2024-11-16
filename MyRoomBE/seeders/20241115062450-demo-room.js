"use strict";
const { now } = require("sequelize/lib/utils");
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    /**
     * Add seed commands here.
     *
     * Example:
     * await queryInterface.bulkInsert('People', [{
     *   name: 'John Doe',
     *   isBetaMember: false
     * }], {});
     */
    await queryInterface.bulkInsert("Rooms", [
      {
        roomName: "침실",
        roomDesc: "침실.",
        userId: 3,
        createdAt: now(),
        updatedAt: now(),
      },
      {
        roomName: "침실",
        roomDesc: "침실.",
        userId: 3,
        createdAt: now(),
        updatedAt: now(),
      },
    ]);
  },

  async down(queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  },
};