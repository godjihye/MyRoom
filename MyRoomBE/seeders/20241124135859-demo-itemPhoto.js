'use strict';

const { now } = require('sequelize/lib/utils');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    /**
     * Add seed commands here.
     *
     * Example:
     * await queryInterface.bulkInsert('People', [{
     *   name: 'John Doe',
     *   isBetaMember: false
     * }], {});
    */
   await queryInterface.bulkInsert('ItemPhotos', [
    {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
   {
    itemId: 1,
    photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s",
    createdAt: now(),
    updatedAt: now(),
   },
  ])
  },

  async down (queryInterface, Sequelize) {
    /**
     * Add commands to revert seed here.
     *
     * Example:
     * await queryInterface.bulkDelete('People', null, {});
     */
  }
};
