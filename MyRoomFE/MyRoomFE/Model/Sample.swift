//
//  Sample.swift
//  MyRoomFE
//
//  Created by jhshin on 11/22/24.
//

import Foundation

let sampleUserId = 3
// let sampleUserId = 4
let sampleHome = Home(id: 1, homeName: "마룸집", homeDesc: "마룸의집", updatedAt: "2024-12-11T23:25:51.311Z", createdAt: "2024-12-11T23:25:51.311Z", inviteCode: "123456")
let sampleUser = User(id: 1, userName: "김마룸", nickname: "마루미", userImage: "https://stmyroom.blob.core.windows.net/myrooomdb/itemPhoto1733132798297.jpg", createdAt: "2024-12-05", updatedAt: "2024-12-05", homeId: 1, mates: nil, homeUser: sampleHome)
let sampleUser2 = User(id: 47, userName: "myroom@aaa.com", nickname: "마루미", userImage: nil, createdAt: "2024-12-05T09:31:59.536Z", updatedAt: "2024-12-05T09:31:59.536Z", homeId: nil, mates: nil, homeUser: sampleHome)

let sampleLocation = Location(id: 1, locationName: "책장", locationDesc: "책상 옆 책장", roomId: 1)


//let sampleItem = Item(id: 1, itemName: "아이패드", purchaseDate: Optional("2020-10-20T10:56:00.000Z"), expiryDate: Optional("2024-11-20T10:56:25.000Z"), url: Optional("https://apple.com/kr/ipad-pro"), photo: Optional("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), desc: Optional("Mac Mini 갖고 싶어요"), color: Optional("rose gold"), isFav: true, price: Optional(2000), openDate: nil, locationId: 5, createdAt: "2024-11-20T10:57:34.255Z", updatedAt: "2024-11-24T05:51:54.322Z", itemPhoto: Optional([MyRoomFE.ItemPhoto(id: 1, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 2, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjg0/MDAxNzIyNzU1NDc0MTA3.72jR12vhy6UOEIjD18Ku-mwEKt1aSx3z8Mkw7MqXoNYg.rlBxyJ7Rc9kAXw5uEmixRjCdGQ1JjO9aRhXD7f3Zj6Ag.JPEG/1722755473126.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 3, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 4, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 5, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjI5/MDAxNzIyNzU1NDE0MTQ5.gevr23_H7cZd_TFFvMwxxxknSY64mOvjRsBbNjwSopsg.57UoK7G4ioWfjIuEYDBQ0qmYnwd-hbBfETbTa13Y8tcg.JPEG/20230801%EF%BC%BF092949.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 7, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 8, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 9, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjg0/MDAxNzIyNzU1NDc0MTA3.72jR12vhy6UOEIjD18Ku-mwEKt1aSx3z8Mkw7MqXoNYg.rlBxyJ7Rc9kAXw5uEmixRjCdGQ1JjO9aRhXD7f3Zj6Ag.JPEG/1722755473126.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 10, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s")]), location: MyRoomFE.Item_Location(locationName: "화장대", room: MyRoomFE.Item_Room(roomName: "jh")))

//let sampleItem = Item(id: 1, itemName: "아이패드", purchaseDate: Optional("2020-10-20T10:56:00.000Z"), expiryDate: Optional("2024-11-20T10:56:25.000Z"), url: Optional("https://apple.com/kr/ipad-pro"), photo: Optional("https://i.namu.wiki/i/T6CkUjJqyNWEudh3KBic3zcUeUo0Ugpl-V6XvfjZb6Cz3pdJ0ACGRSYlIkO9u6iYQELSPgQnWAZqnw5V1kQyOsFYRPNe203Q3BtyPh4bvWLxJ-CVt0k56aCmwqc_gw5VXFq7U2jPXdm5J1Vs2KY7BA.webp"), desc: Optional("Mac Mini 갖고 싶어요"), color: Optional("rose gold"), isFav: true, price: Optional(2000), openDate: nil, locationId: 5, createdAt: "2024-11-20T10:57:34.255Z", updatedAt: "2024-11-24T05:51:54.322Z", itemPhotos: Optional([MyRoomFE.ItemPhoto(id: 1, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 2, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjg0/MDAxNzIyNzU1NDc0MTA3.72jR12vhy6UOEIjD18Ku-mwEKt1aSx3z8Mkw7MqXoNYg.rlBxyJ7Rc9kAXw5uEmixRjCdGQ1JjO9aRhXD7f3Zj6Ag.JPEG/1722755473126.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 3, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 4, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 5, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjI5/MDAxNzIyNzU1NDE0MTQ5.gevr23_H7cZd_TFFvMwxxxknSY64mOvjRsBbNjwSopsg.57UoK7G4ioWfjIuEYDBQ0qmYnwd-hbBfETbTa13Y8tcg.JPEG/20230801%EF%BC%BF092949.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 7, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 8, photo: "https://i.pinimg.com/736x/76/9a/16/769a16eddbd88bd852b81ce7d277e7c7.jpg"), MyRoomFE.ItemPhoto(id: 9, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjg0/MDAxNzIyNzU1NDc0MTA3.72jR12vhy6UOEIjD18Ku-mwEKt1aSx3z8Mkw7MqXoNYg.rlBxyJ7Rc9kAXw5uEmixRjCdGQ1JjO9aRhXD7f3Zj6Ag.JPEG/1722755473126.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 10, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s")]), location: MyRoomFE.Item_Location(locationName: "화장대", room: MyRoomFE.Item_Room(roomName: "jh")))


let sampleItemPhoto = [MyRoomFE.ItemPhoto(id: 1, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s", photoText: nil, photoTextAI: nil), MyRoomFE.ItemPhoto(id: 2, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAs95IL4RniwtEkYVUldCYSgl9synmYGjDxbUmlNqslC7XbTDv9ij756E&s", photoText: nil, photoTextAI: nil), MyRoomFE.ItemPhoto(id: 3, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s", photoText: nil, photoTextAI: nil)]


//let samplePost = Post(id: 1, postTitle: "7평원룸 수납꿀팁", postContent: "수납침대를 이용하여 자주쓰지 않는 물건들을 안보이도록 정리해요 정말쉽죠 한번 같이해봐요 이렇게 쉬울수가없어요 돈만있음 다할 수 있습니다", postThumbnail: "test1.jpeg", user: sampleUser, itemUrl: ["naver.com"], postFav: [PostFavData(id: 1,postId: 4, userId: 4)],isFavorite:false, postFavCnt: 280, postViewCnt: 728,updatedAt: "2024-11-24T05:51:54.322Z",createdAt: "2024-11-24T05:51:54.322Z", images: [PostPhotoData(id: 1, image: "test1.jpeg"),PostPhotoData(id: 2, image: "test2.jpeg")])

let testURLs = [
             URL(string: "https://sayangpaysj.blob.core.windows.net/yangpa/test1"),
             URL(string: "https://sayangpaysj.blob.core.windows.net/yangpa/test2"),
             URL(string: "https://sayangpaysj.blob.core.windows.net/yangpa/test3")
     ].compactMap({ $0 })  // compactMap을 사용하여 nil 제거
