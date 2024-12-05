const usedPhotoDao = require("../dao/usedPhotoDao");

const createUsedPhotos = async (data) => {
  return await usedPhotoDao.createUsedPhotos(data);
};

const deleteUsedPhotos = async (id) => {
  return await usedPhotoDao.deleteUsedPhotos(id);
};

module.exports = {
  createUsedPhotos,
  deleteUsedPhotos,
};
