const axios = require("axios");
require("dotenv").config();

const headers = {
  "api-key": process.env.GPT_APIKEY,
  "Content-Type": "application/json",
};

const endpoint = `${process.env.GPT_ENDPOINT}`;

const data = `"18:58 미 #먼작귀 nowistravel 먹는것엔 진심한편 캐릭터 음료 구매 시 L/EX Size + 스트로우 데코 1종 랜덤 스티커 1종 R Size 컵홀더 (일반음료에도 제공) ※ 매장별 한정수량으로 소진 시 제공이 어려울 수 있습니다. 기프트카드 기프트카드 2만 원권 구매방법 오프라인 매장에서 구매 SOIYA CONNE 27 Q2 V 465 nowistravel #이디야 X 치이카와 콜라보 떴다!! 17일에 무조건 이디야로 달려가야함 ㅠㅠㅠㅠㅠㅠ ... 더 보기 7시간 전 추천 릴스 저거 보호필름 아님?? 떼면 안될텐데?...0 +"` + ` 이 글을 요약해줘`
axios
  .post(endpoint, data, {
    headers,
  })
  .then((res) => {
    const description = res.choices.message.content;
    console.log(`tags: ${description}`);
  })
  .catch((error) => {
    console.error(error);
  });
