const { json } = require("sequelize");
const usedService = require("../services/usedService");


const createUsed = async(req,res) => {
  console.log("createUsed start ---------")
    const data = req.body.usedData
    const usedData = JSON.parse(data)
    // const usedData = req.body  --postman test용
    const photoData = req.files
    
    
    console.log('photo',photoData)
    const thumbnailBlobName = photoData.usedThumbnail.find(item => item.fieldname === 'usedThumbnail').blobName;
    usedData.usedThumbnail = thumbnailBlobName //usedThumbnail 추가 

    try {
        const used = await usedService.createUsed(usedData,photoData);
        res.status(201).json({ 
          success: true,
          useds: [used],
          message: '게시글 등록이 완료되었습니다.'
          });
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

const findUsedByName = async (req,res) => {
  try {
    const used = await usedService.findUsedByName(
      req.body.userId,
      req.body.query
    );

    res.status(201).json({ 
      success: true,
      useds: used.rows,
      message: 'Used 조회성공'
      });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}

const findUsedById = async(req, res) => {
  try {
    const {id,userId} = req.params
    console.log(id)
    console.log(userId)
    const used = await usedService.findUsedById(id,userId);
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
  console.log(req.body.usedData)
  console.log(req.params.id)
  try{
    const used = await usedService.updateUsed(req.params.id,req.body)
    if(used) {
      res.status(201).json({used:used})
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
      res.status(200).json({ 
        success : true,
        message: "게시글이 삭제되었습니다." 
      });
    } else {
      res.status(404).json({ error: `used not found` });
    }
  }catch(e) {
    res.status(500).json({error:e.message})
  }
}

const toggleFavorite = async(req,res) => {
  const usedId = req.params.usedId
  const {userId,action} = req.body
  console.log('action',action)
  console.log(req.body);
  
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

const updateUsedStatus = async(req,res) => {
  const id = req.params.id
  const usedStatus = req.body

  try{
    const result = await usedService.updateUsedStatus(usedStatus,id)
    
    if (result) {
        res.status(200).json({ usedStatus: result });
      } else {
        res.status(404).json({ error: `used not found` });
      }
  }catch(e) {
    res.status(500).json({error:e.message})
  }
}

const updateViewCnt = async(req,res) => {
  const id = req.params.id

  try {
    const result = await usedService.updateViewCnt(id)
    
    if (result) {
        res.status(200).json({ usedViewCnt: result });
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
  findUsedByName,
  findUsedById,
  updateUsed,
  deleteUsed,
  toggleFavorite,
  updateUsedStatus,
  updateViewCnt
}