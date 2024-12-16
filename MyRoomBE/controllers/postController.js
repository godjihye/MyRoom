const postService = require("../services/postService");

const createPost = async (req, res) => {
  console.log("postCreate start~~~~~~~~");
  const postData = req.body.postData;
  const buttonData = req.body.buttonData;
  const jsonPostData = JSON.parse(postData);
  const jsonButtonData = JSON.parse(buttonData);
  const photoData = req.files;
  const thumbnailBlobName = photoData.postThumbnail.find(
    (item) => item.fieldname === "postThumbnail"
  ).blobName;
  jsonPostData.postThumbnail = thumbnailBlobName; //postThumbnail 추가
  console.log("photo", photoData);
  try {
    const post = await postService.createPost(
      jsonPostData,
      photoData,
      jsonButtonData
    );

    res.status(201).json({
      success: true,
      posts: [post],
      message: "게시글이 등록되었습니다.",
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const findPostById = async (req, res) => {
  try {
    const post = await postService.findPostById(req.params.id);
    if (post) {
      res.status(200).json({ data: post });
    } else {
      res.status(404).json({ error: `post not found` });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const findAllPost = async (req, res) => {
  try {
    const { page, pageSize } = req.query;
    const pageNum = parseInt(page) || 1;
    const size = parseInt(pageSize) || 10;
    const userId = req.params.userId;
    const posts = await postService.findAllPost(pageNum, size, userId);
    const totalPages = Math.ceil(posts.count / size);

    res.status(201).json({
      success: true,
      posts: posts.rows,
      totalPages: totalPages,
      message: "Post 조회성공",
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const findPostByName = async (req, res) => {
  try {
    const post = await postService.findPostByName(
      req.body.userId,
      req.body.query
    );

    res.status(201).json({
      success: true,
      posts: post,
      message: "Post 조회성공",
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const updatePost = async (req, res) => {
  try {
    const post = await postService.updatePost(req.params.id, req.body);
    if (post) {
      res.status(200).json({ data: post });
    } else {
      res.status(404).json({ error: `post not found` });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const deletePost = async (req, res) => {
  try {
    const result = await postService.deletePost(req.params.id);
    if (result) {
      res.status(200).json({
        success: true,
        message: "게시글이 삭제되었습니다.",
      });
    } else {
      res.status(404).json({ error: `post not found` });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const toggleFavorite = async (req, res) => {
  const postId = req.params.postId;
  const { userId, action } = req.body;
  console.log("action", action);
  console.log(req.body);

  try {
    const result = await postService.toggleFavorite(postId, userId, action);

    if (result) {
      res.status(200).json({ posts: [result] });
    } else {
      res.status(404).json({ error: `post not found` });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const updateViewCnt = async (req, res) => {
  const id = req.params.id;

  try {
    const result = await postService.updateViewCnt(id);

    if (result) {
      res.status(200).json({ postViewCnt: result });
    } else {
      res.status(404).json({ error: `post not found` });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  createPost,
  findPostById,
  findAllPost,
  findPostByName,
  updatePost,
  deletePost,
  toggleFavorite,
  updateViewCnt,
};
