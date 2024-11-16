const express = require("express");
const morgan = require("morgan");
const dotenv = require("dotenv");
const app = express();
const PORT = 3000;
const roomRouter = require("./routers/roomsRouter");
const userRouter = require("./routers/usersRouter");
const postRouter = require("./routers/postsRouter");
const usedRouter = require("./routers/usedsRouter");
app.use(morgan("dev"));

app.use("/room", roomRouter);
app.use("/posts", postRouter);
app.use("/users", userRouter);
app.use("/useds", usedRouter);
app.use((_, res) => {
  res.status(404).json({ success: false, token: "", message: "요청이 잘못됨" });
});
app.listen(PORT, () => {
  console.log(`${PORT}에서 서버 실행중`);
});
