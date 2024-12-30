# MyRoom(마룸)
[남부여성발전센터](https://nambu.seoulwomanup.or.kr/nambu/main/main.do) **생성형 AI활용 클라우드 기반 iOS 앱 개발자** 과정의 최종 프로젝트

## 🧑🏻‍🏫 프로젝트 소개
> #### 물건의 모든 순간, 마룸과 함께

**마룸**은 물건 관리와 중고 거래, 커뮤니티를 지원하여 **물건의 지속 가능한 가치를 실현**하기 위한 iOS앱입니다. 

집 안의 물건을 정리하고 추적할 수 있으며, 사용설명서를 간편하게 관리할 수 있습니다. 이를 통해 정확한 중고거래를 지원하고, 커뮤니티를 통해 정보와 노하우를 나눌 수 있도록 합니다.

## ⏱️ 개발기간

* 2024.11.11 ~ 2024.12.19 (38일간)

## 👬 개발자 소개

- 팀장: **신지혜** - 물건 관리, 회원 관리(BE/FE), 통합 및 형상관리, Cloud, AI, 발표 ppt 제작
- 팀원: **이수정** - 중고거래, 커뮤니티 게시판(BE/FE), 실시간 채팅, Cloud, 시연영상 제작

![팀원소개](https://github.com/user-attachments/assets/def6f53d-acad-4ef8-9b9c-c8d5e0f3d33b)

## 📌 주요 기능
#### 물건 위치 추적
- **방 - 위치 별 물건 목록화**: 위치를 터치하여 위치 안의 저장한 모든 물건들을 조회
- **검색하여 위치 추적**: 물건의 이름, 추가 이미지의 텍스트 내용 일부를 검색하여 물건 위치 추적
#### 물건 정보 저장
- **사용 설명서 저장**: 물건의 사용 설명서를 사진을 찍어 업로드하면, Apple Vision Framework를 사용하여 텍스트 추출(OCR)하고, OpenAI로 텍스트 요약하여 데이터를 저장(OCR의 부족함을 OpenAI를 통해 보완)
#### 중고거래 게시판
- **마룸 데이터를 활용하여 거래글을 작성**: 판매자에겐 쉽고 간편한 거래글 작성을 제공, 구매자에겐 신뢰성을 주어 중고거래의 위험성 줄임.
- **실시간 채팅**: 실시간 채팅을 지원하여 앱 안에서의 거래를 간편하게 함.
#### 커뮤니티 게시판
- **아이템 관련 정보 공유 커뮤니티**: 이미지 내 원하는 위치에 아이템 구매 url 연동 버튼을 생성하여 글 작성할 수 있음. 버튼을 클릭하면 웹뷰(구매url)가 보여짐.
#### 로그인
- DB값 검증
- 로그인 시 token 발급
- 소셜 로그인
#### 회원가입
- ID 중복 체크
#### 마이페이지
- **회원정보 변경**: 닉네임, 프로필 사진, 비밀번호 변경
- **동거인 관리**: 집 안 물건 데이터를 공유할 동거인을 추가, 방출할 수 있음.
#### 검색
- **최근검색어 기록**: 검색 기록을 남겨 검색을 편리하게 함.
- **검색 필드 분류**: 통합 검색, 물건 이름 검색, 추가 이미지 검색 총 3가지로 나누어 검색 결과를 확인

## ⚙️ 기술 스택

#### **Frontend (FE)**  
- **Language**: Swift 5  
- **Frameworks**: SwiftUI, Alamofire(AF)  
- **SDKs**: KakaoSDK, Sign In with Apple  
- **IDE**: Xcode
#### **Backend (BE)**  
- **Language**: Node.js
- **ORM**: Sequelize
- **IDE**: Visual Studio Code
#### **Database (DB)**  
- **Primary DB**: Azure Database for PostgreSQL - Flexible Server  
- **Supplementary DB**: Firebase  
- **Management Tool**: DBeaver
#### **Deployment**
- **Tools**: Docker, Azure App Service  
#### **CI/CD**
- **Platform**: GitHub Actions  
#### **Design**  
- **Tool**: Figma  
#### **Collaboration**  
- **Tool**: Notion  
#### **Image Storage**  
- **Platform**: Azure Storage Account (Blob Storage)

## 📺 시연영상
- [마룸 시연영상](https://youtu.be/nC1hHu_jMVE, "Youtube")
