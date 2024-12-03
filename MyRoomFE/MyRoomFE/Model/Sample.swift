//
//  Sample.swift
//  MyRoomFE
//
//  Created by jhshin on 11/22/24.

//

import Foundation

let sampleUserId = 3
// let sampleUserId = 4
let sampleLocation = Location(id: 1, locationName: "책장", locationDesc: "책상 옆 책장", roomId: 1)
let sampleItem = Item(id: 1, itemName: "아이패드", purchaseDate: Optional("2020-10-20T10:56:00.000Z"), expiryDate: Optional("2024-11-20T10:56:25.000Z"), url: Optional("https://apple.com/kr/ipad-pro"), photo: Optional("https://i.namu.wiki/i/T6CkUjJqyNWEudh3KBic3zcUeUo0Ugpl-V6XvfjZb6Cz3pdJ0ACGRSYlIkO9u6iYQELSPgQnWAZqnw5V1kQyOsFYRPNe203Q3BtyPh4bvWLxJ-CVt0k56aCmwqc_gw5VXFq7U2jPXdm5J1Vs2KY7BA.webp"), desc: Optional("Mac Mini 갖고 싶어요"), color: Optional("rose gold"), isFav: true, price: Optional(2000), openDate: nil, locationId: 5, createdAt: "2024-11-20T10:57:34.255Z", updatedAt: "2024-11-24T05:51:54.322Z", itemPhotos: Optional([MyRoomFE.ItemPhoto(id: 1, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 2, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjg0/MDAxNzIyNzU1NDc0MTA3.72jR12vhy6UOEIjD18Ku-mwEKt1aSx3z8Mkw7MqXoNYg.rlBxyJ7Rc9kAXw5uEmixRjCdGQ1JjO9aRhXD7f3Zj6Ag.JPEG/1722755473126.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 3, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 4, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 5, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjI5/MDAxNzIyNzU1NDE0MTQ5.gevr23_H7cZd_TFFvMwxxxknSY64mOvjRsBbNjwSopsg.57UoK7G4ioWfjIuEYDBQ0qmYnwd-hbBfETbTa13Y8tcg.JPEG/20230801%EF%BC%BF092949.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 7, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 8, photo: "data:image/jpeg;base64,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"), MyRoomFE.ItemPhoto(id: 9, photo: "https://postfiles.pstatic.net/MjAyNDA4MDRfMjg0/MDAxNzIyNzU1NDc0MTA3.72jR12vhy6UOEIjD18Ku-mwEKt1aSx3z8Mkw7MqXoNYg.rlBxyJ7Rc9kAXw5uEmixRjCdGQ1JjO9aRhXD7f3Zj6Ag.JPEG/1722755473126.jpg?type=w580"), MyRoomFE.ItemPhoto(id: 10, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s")]), location: MyRoomFE.Item_Location(locationName: "화장대", room: MyRoomFE.Item_Room(roomName: "jh")))

let sampleItemPhoto = [MyRoomFE.ItemPhoto(id: 1, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 2, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAs95IL4RniwtEkYVUldCYSgl9synmYGjDxbUmlNqslC7XbTDv9ij756E&s"), MyRoomFE.ItemPhoto(id: 3, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 4, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 5, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAs95IL4RniwtEkYVUldCYSgl9synmYGjDxbUmlNqslC7XbTDv9ij756E&s"), MyRoomFE.ItemPhoto(id: 6, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 7, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 8, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAs95IL4RniwtEkYVUldCYSgl9synmYGjDxbUmlNqslC7XbTDv9ij756E&s"), MyRoomFE.ItemPhoto(id: 9, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 10, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAs95IL4RniwtEkYVUldCYSgl9synmYGjDxbUmlNqslC7XbTDv9ij756E&s")]

let samplePost = Post(id: 1, postTitle: "7평원룸 수납꿀팁", postContent: "수납침대를 이용하여 자주쓰지 않는 물건들을 안보이도록 정리해요 정말쉽죠 한번 같이해봐요 이렇게 쉬울수가없어요 돈만있음 다할 수 있습니다", postThumbnail: "test1.jpeg", user: User(nickname: "마루미", userImage: "soo1.jpeg"), postFav: [PostFavData(id: 1,postId: 4, userId: 4)],isFavorite:false, postFavCnt: 280, postViewCnt: 728,updatedAt: "2024-11-24T05:51:54.322Z",createdAt: "2024-11-24T05:51:54.322Z", images: [PostPhotoData(id: 1, image: "test1.jpeg"),PostPhotoData(id: 2, image: "test2.jpeg")])
