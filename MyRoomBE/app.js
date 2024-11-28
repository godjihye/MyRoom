const express = require("express");
const morgan = require("morgan");
const dotenv = require("dotenv");
const app = express();
const PORT = 3000;
// const roomRouter = require("./routers/myroomsRouter");
// const userRouter = require("./routers/usersRouter");
const postRouter = require("./routers/postsRouter");
// const postPhotoRouter = require("./routers/postPhotoRouter");
const commentsRouter = require("./routers/commentsRouter");
const usedRouter = require("./routers/usedsRouter");
const usedPhotosRouter = require("./routers/usedPhotosRouter");
const imageRouter = require('./routers/imageRouter');
const itemRouter = require("./routers/itemsRouter");


app.use(morgan("dev"));
app.use(express.json());

// app.use("/room", roomRouter);
app.use("/posts", postRouter);
// app.use("/postPhotos", postPhotoRouter);
app.use("/comments",commentsRouter)
// app.use("/users", userRouter);
app.use("/useds", usedRouter);
app.use("/useds/photos", usedPhotosRouter);
app.use("/items", itemRouter);

app.use((_, res) => {
  res.status(404).json({ success: false, token: "", message: "요청이 잘못됨" });
});
app.listen(PORT, () => {
  console.log(`${PORT}에서 서버 실행중`);
});
