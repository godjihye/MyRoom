const homeServiece = require("../services/homeService");


//홈 생성
const createHome = async (req, res) => {
    try {
        const userId = req.params.userId
        const data = req.body

        const home = await homeServiece.createHome(userId,data);
        res.status(201).json({ home: home });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }	
};


//홈 조회
const findHomeByPK = async(req,res) => {
  try{
    const userId = req.params.userId
    const home = await homeServiece.findHomeByPK(userId)

    res.status(201).json({ home: home });
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}

//홈 수정
const updateHome = async(req,res) => {
  try{
    const homeId = req.params.id
    const data = req.body

    const home = await homeServiece.updateHome(homeId,data)
    if (home) {
      res.status(200).json({ home: home });
    } else {
      res.status(404).json({ error: `home not found` });
    }
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}



module.exports = {
    createHome,
    findHomeByPK,
    updateHome
}