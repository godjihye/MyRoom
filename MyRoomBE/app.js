const models = require("./models");
const express = require("express");
const morgan = require("morgan");
const dotenv = require("dotenv");
dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;

const homeRouter = require("./routers/homeRouter")
const roomRouter = require("./routers/roomsRouter");
const locationRouter = require("./routers/locationRouter");
const itemRouter = require("./routers/itemsRouter");
const userRouter = require("./routers/userRouter");
const postRouter = require("./routers/postsRouter");
const usedRouter = require("./routers/usedsRouter");
const imageRouter = require("./routers/imageRouter")

app.use(morgan("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/home",homeRouter)
app.use("/rooms", roomRouter);
app.use("/locations", locationRouter);
app.use("/items", itemRouter);
app.use("/posts", postRouter);
app.use("/users", userRouter);
app.use("/useds", usedRouter);

app.use((_, res) => {
  res.status(404).json({ success: false, token: "", message: "요청이 잘못됨" });
});

app.listen(PORT, () => {
  // models.sequelize
  //   .sync({ force: false })
  //   .then(() => {
  //     console.log("db 연결 성공");
  //   })
  //   .catch((err) => {
  //     console.log(`db 연결 실패 : ${err}`);
  //     process.exit();
  //   });
  console.log(`server on ${PORT}`);
});
