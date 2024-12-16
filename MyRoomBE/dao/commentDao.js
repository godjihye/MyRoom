const models = require("../models");

// 댓글 작성
const createComment = async(comment, parentId, postId, userId ) => {

   return newComment = await models.Comment.create({ comment, parentId, postId, userId }, { logging: console.log });
 
   
}

// 대댓글작성
const createReply = async(comment, parentId, postId, userId ) => {

    const parentComment = await models.Comment.findByPk(parentId); //대댓글을 달 댓글 조회
    
    if (!parentComment) {
        return res.status(404).json({ error: 'Parent comment not found' });
    }

    const reply = await models.Comment.create({
        comment,
        postId, 
        userId,
        parentId,
      });

    return reply
}

//댓글 조회
const findAllComment = async(postId) => {
    return await models.Comment.findAll({
        where: { postId, parentId:null },
        include: [
            {
                model: models.User,
                as: 'user',
                attributes: ['nickname', 'userImage'],
            },
            {
                model: models.Comment,
                as: 'replies',
                include: [
                    {
                        model: models.User,
                        as: 'user',  
                        attributes: ['nickname', 'userImage'],
                    },
                ],
            },
        ],
    });
}


//edit
const updateComment = async(id,commnet) => {
    return await models.Comment.update(commnet, {
        where: { id },
    })
}

//delete
const deleteCommnet = async(id) => {
    return await models.Comment.destroy({
        where: {id}
    })
}


module.exports = {

    createComment,
    createReply,
    findAllComment,
    updateComment,
    deleteCommnet

}