const commentService = require("../services/commentService");
const models = require("../models");
//댓글작성
const createCommnet = async (req, res) => {
    try {
    const comment = await commentService.createComment( {
        comment: req.body.comment,
        userId: 4,
        postId : req.params.id
      });
    res.status(201).json({ data: comment });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }	
};

//대댓글작성
const createReply = async(req,res) => {
  try{
        const reply = await commentService.createReply({
            comment: req.body.comment,
            userId : 5,
            postId : req.params.id,
            parentId : req.params.parentId
        })
        res.status(201).json({ data: reply });
    }catch(e){
        res.status(500).json({ error: e.message })
    }
}

const findAllComment = async(req,res) => {
  try{
    const commnet = await commentService.findAllComment({
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

const updateComment = async(req,res) => {
  try{
    const comment = await commentService.updateComment(req.params.id,req.body)
    if (comment) {
      res.status(200).json({ data: comment });
    } else {
      res.status(404).json({ error: `comment not found` });
    }
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}

const deleteCommnet = async(req,res) => {
  try{
    const result = await commentService.deleteCommnet(req.params.id)
    if (result) {
      res.status(200).json({ message: "success" });
    } else {
      res.status(404).json({ error: `comment not found` });
    }
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}


module.exports = {
    createCommnet,
    createReply,
    findAllComment,
    updateComment,
    deleteCommnet
}