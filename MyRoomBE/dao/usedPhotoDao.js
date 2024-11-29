const models = require("../models");

// write
const createUsedPhotos = async (data) => {
    return await models.UsedPhoto.create(data);
};



const deleteUsedPhotos = async(id) => {
    return await models.UsedPhoto.destroy({
        where: { id },
      });
}


module.exports ={
    createUsedPhotos,
    
    deleteUsedPhotos
}