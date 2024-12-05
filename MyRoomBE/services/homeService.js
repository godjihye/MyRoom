const homeDao = require("../dao/homeDao")

const createHome = async (userId,data) => {
	return await homeDao.createHome(userId,data);
}


const findHomeByPK = async(id) => {
    return await homeDao.findHomeByPK(id)
}

const updateHome = async(homeId,data) => {
    return await homeDao.updateHome(homeId,data)
}



module.exports = {
    createHome,
    findHomeByPK,
    updateHome,
}

