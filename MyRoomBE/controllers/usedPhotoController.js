const usedPhotoService = require("../services/usedPhotoService");

const createUsedPhotos = async(req,res) => {
    try {
        const usedPhotos = await usedPhotoService.createUsedPhotos(req.body);
        res.status(201).json({ usedPhotos: usedPhotos });
      } catch (e) {
        res.status(500).json({ error: e.message });
      }	
}

   

const deleteUsedPhotos = async(req,res) => {
    try{
        const result = await usedPhotoService.deleteUsedPhotos(req.params.id) 
        if(result) {
            res.status(201).json({result:result})
        }else{
            res.status(501).json({error:e.message})
        }
    }catch(e) {
        res.status(500).json({ error: e.message });
    }
}

module.exports = {
    createUsedPhotos,
    deleteUsedPhotos
}