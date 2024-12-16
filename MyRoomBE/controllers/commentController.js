const commentService = require("../services/commentService");
const models = require("../models");

//댓글작성
const createCommnet = async (req, res) => {
  console.log("comment start")
  console.log(req.params.parentId)
  const parentId = req.params.parentId || null;
  const {postId, userId} = req.params
  const text = req.body.comment
  console.log(parentId,postId,userId,text)

    try {
    const comment = await commentService.createComment( text, parentId, postId, userId );
    res.status(201).json({ comment: comment });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }	
};

//대댓글작성
const createReply = async(req,res) => {
  const {parentId,postId,userId} = req.params
  const comment = req.body.comment

  try{
        const reply = await commentService.createReply(comment, parentId, postId, userId )
        res.status(201).json({ comment: reply });
    }catch(e){
        res.status(500).json({ error: e.message })
    }
}

// 댓글 조회
const findAllComment = async(req,res) => {
  
  const postId = req.params.postId
  try{
    const commnet = await commentService.findAllComment(
      postId
    )
    res.status(201).json({ comments: commnet });
  }catch(e) {
    res.status(500).json({ error: e.message });
  }
}

const updateComment = async(req,res) => {
  try{
    
    const comment = await commentService.updateComment(req.params.id,req.body)
    if (comment) {
      res.status(200).json({ comment: comment });
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
      res.status(200).json({ message: "댓글이 삭제되었습니다." });
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