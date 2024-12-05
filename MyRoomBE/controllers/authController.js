const homeServiece = require("../services/homeService");


//홈 생성
const createHome = async (req, res) => {
    try {
        const userId = req.params.userId
        const data = req.body

        const home = await homeServiece.createHome(userId,data);
        res.status(201).json({ data: home });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }	
};


//홈 조회
const findAllHome = async(req,res) => {
  try{
    const commnet = await homeServiece.findAllHome({
      postId : req.params.postId,
      parentId : req.params.parentId,
      where: { parentId: null }, // 부모 댓글만 가져옴
      include: [{
        model: models.Comment,
        as: 'replies', 
        
      }]
    })
    res.status(201).json({ data: commnet });
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}

//홈 수정
const updateHome = async(req,res) => {
  try{
    const comment = await homeServiece.updateHome(req.params.id,req.body)
    if (comment) {
      res.status(200).json({ data: comment });
    } else {
      res.status(404).json({ error: `comment not found` });
    }
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}



module.exports = {
    createHome,
    findAllHome,
    updateHome
}