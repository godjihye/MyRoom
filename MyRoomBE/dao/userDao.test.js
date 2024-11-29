const { DESCRIBE } = require("sequelize/lib/query-types");
const userDao = require("./userDao");

describe("Test Dao", () => {
    test("should", async () => {
        const data = {
            userName: "테스터1",
            password: "1234",
        };

        // roomDao 객체의 createRoom 메서드를 호출하여 데이터를 삽입
        const result = await userDao.createUser(data);

        // 결과 객체의 roomName이 입력한 데이터와 같은지 확인
        expect(result.userName).toBe(data.userName);
    });
});
