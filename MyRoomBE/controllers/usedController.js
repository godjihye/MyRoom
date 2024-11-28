const usedService = require("../services/usedService");


const createUsed = async(req,res) => {
  console.log("createUsed start ---------")
    const usedData = req.body
    const photoData = req.files
    const thumbnailBlobName = photoData.usedThumbnail.find(item => item.fieldname === 'usedThumbnail').blobName;
    usedData.usedThumbnail = thumbnailBlobName //usedThumbnail 추가 

    try {
        const used = await usedService.createUsed(usedData,photoData);
        res.status(201).json({ used: used });
      } catch (e) {
        res.status(500).json({ error: e.message });
      }	
}


const findAllUsed = async(req,res) => {
    try {
        const { page, pageSize } = req.query;
        const pageNum = parseInt(page) || 1; 
        const size = parseInt(pageSize) || 10; 
        const userId = req.params.userId

        const useds = await usedService.findAllUsed(pageNum, size,userId)
        const totalPages = Math.ceil(useds.count /size);
        
        res.status(201).json({ 
        success: true,
        useds: useds.rows,
        totalPages: totalPages,
        message: 'Used 조회성공'
        });

    } catch (e) {
        res.status(500).json({ error: e.message });
    }	

}

const findUsedById = async(req, res) => {
  try {
    const used = await usedService.findUsedById(req.params.id);
    if(used) {
      res.status(201).json({useds:[used]})
    }else{
      res.status(501).json({error: "used not found"})
    }
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}

const updateUsed = async(req,res) => {
  try{
    const used = await usedService.updateUsed(req.params.id,req.body)
    if(used) {
      res.status(201).json({data:used})
    }else{
      res.status(501).json({error: "used not found"})
    }
  }catch (e) {
    res.status(500).json({ error: e.message });
  }
}

const deleteUsed = async(req,res) => {
  try{
    const result = await usedService.deleteUsed(req.params.id)
    if (result) {
      res.status(200).json({ message: "success" });
    } else {
      res.status(404).json({ error: `used not found` });
    }
  }catch(e) {
    res.status(500).json({error:e.message})
  }
}

const toggleFavorite = async(req,res) => {
  console.log(req.params)
  console.log(req.body)
  const usedId = req.params.usedId
  const {userId,action} = req.body
  
  try{
    const result = await usedService.toggleFavorite(usedId,userId,action)
    

    if (result) {
        res.status(200).json({ usedFav: result });
      } else {
        res.status(404).json({ error: `used not found` });
      }
  }catch(e) {
    res.status(500).json({error:e.message})
  }
}



module.exports = {
  createUsed,
  findAllUsed,
  findUsedById,
  updateUsed,
  deleteUsed,
  toggleFavorite
}