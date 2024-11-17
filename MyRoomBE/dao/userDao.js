const models = require("../models");
const createUser = async(data)=> {
    return await models.User.create(data);
}

module.exports = {
    createUser
}