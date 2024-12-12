const homeService = require("../services/homeService");

//홈 생성
const createHome = async (req, res) => {
  try {
    const userId = req.params.userId;
    const data = req.body;

    const home = await homeService.createHome(userId, data);
    res.status(201).json({
      success: true,
      message: "성공적으로 집을 등록했습니다.",
      home: home,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

//홈 조회
const findHomeByPK = async (req, res) => {
  try {
    const userId = req.params.userId;
    const home = await homeService.findHomeByPK(userId);

    res.status(201).json({ home: home });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

//홈 수정
const updateHome = async (req, res) => {
  try {
    const homeId = req.params.id;
    const data = req.body;

    const home = await homeService.updateHome(homeId, data);
    if (home) {
      res.status(200).json({ home: home });
    } else {
      res.status(404).json({ error: `home not found` });
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const generateInviteCode = async (req, res) => {
  try {
    const inviteCode = await homeService.generateInviteCode(req.params.homeId);
    res.status(201).json({
      success: true,
      message: "초대코드를 생성했습니다.",
      data: inviteCode,
    });
  } catch (e) {
    res.status(500).json({ success: false, message: "알 수 없는 오류" });
  }
};

const joinHomeWithInviteCode = async (req, res) => {
  try {
    const result = await homeService.joinHomeWithInviteCode(
      req.params.userId,
      req.body.inviteCode
    );
    res
      .status(200)
      .json({ success: true, message: "집 입장 성공", home: result });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const findInviteCode = async (req, res) => {
  try {
    const { inviteCode } = await homeService.findInviteCode(req.params.homeId);

    res.status(200).json({ inviteCode });

    //res.status(404).json({error: "home not found"})
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};

const refreshInviteCode = async (req, res) => {
  try {
    const inviteCode = await homeService.refreshInviteCode(req.params.homeId);
    res.status(200).json({ inviteCode: inviteCode });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};

const deleteHome = async (req, res) => {
  try {
    const result = await homeService.deleteHome(req.params.homeId);
    res.status(200).json({ success: true, message: "홈 삭제 완료" });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
};
module.exports = {
  createHome,
  findHomeByPK,
  updateHome,
  generateInviteCode,
  joinHomeWithInviteCode,
  findInviteCode,
  refreshInviteCode,
  deleteHome,
};
