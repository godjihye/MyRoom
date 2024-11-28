const models = require("../models");

//write
const createComment = async(data) => {
    return await models.Comment.create(data)
}

//대댓글작성
const createReply = async(data) => {
    return await models.Comment.create(data)
}

//get
const findAllComment = async(data) => {
    return await models.Comment.findAll(data,{
        include: [{
            model: models.Comment,
            as: 'replies', // 대댓글을 'replies'로 가져옴
            
          }]
    });
}

//edit
const updateComment = async(id,data) => {
    return await models.Comment.update(data, {
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