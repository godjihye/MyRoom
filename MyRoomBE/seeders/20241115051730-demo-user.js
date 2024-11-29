"use strict";

const { query } = require("express");
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
    await queryInterface.bulkInsert("Users", [
      {
        userName: "teamshini@abc.com",
        password: "1234",
        nickname: "팀시니",
        createdAt: now(),
        updatedAt: now(),
      },
      {
        userName: "teamshini2@abc.com",
        password: "1234",
        nickname: "팀시니1",
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
