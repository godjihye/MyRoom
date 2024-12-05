const postService = require("../services/postService");

const createPost = async (req, res) => {
  try {
    const post = await postService.createPost({
      title: req.body.title,
      content: req.body.content,
      userId: 4,
    });
    res.status(201).json({ data: post });
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
    const posts = await postService.findAllPost();
    res.status(201).json({ data: posts });
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
      res.status(200).json({ message: "success" });
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
  updatePost,
  deletePost,
};
