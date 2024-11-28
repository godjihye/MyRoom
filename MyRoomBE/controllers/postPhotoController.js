// const postPhotoService = require("../services/postPhotoService")

// const createPostPhoto = async (req, res) => {
//     console.log(req.body.image)
//     console.log(req.params.id)

//     try {
//     const postPhoto = await postPhotoService.createPostPhoto( {
//         image: req.body.image,
//         postId: req.params.id,
       
//       });
//     res.status(201).json({ data: postPhoto });
//   } catch (e) {
//     res.status(500).json({ error: e.message });
//   }	
// };




// module.exports = {
//     createPostPhoto

// }