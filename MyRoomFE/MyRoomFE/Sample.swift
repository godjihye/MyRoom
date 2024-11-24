//
//  Sample.swift
//  MyRoomFE
//
//  Created by jhshin on 11/22/24.
//

import Foundation

//let sampleItem = Item(
//	id: 10,
//	itemName: "치이카와",
//	purchaseDate: "2024-11-22",
//	expiryDate: "2024-11-22",
//	url: "https://namu.wiki/w/%EC%B9%98%EC%9D%B4%EC%B9%B4%EC%99%80",
//	photo: "https://i.namu.wiki/i/6YcTP2X1AObi6MaIIXEDxEiO2-jvGeKZiLg_qZ4udgKMbVUHWqXxTBbbgsZhM0zhYav3IOpnnvvz37uVKvlZPVrZ4ndNo7w-6Ahm5wEcpZzEkVZ3Nk_jQ-1L7AqYgrHBX89KizzS3FK8dvFCAMJjOQ.webp",
//	desc: "치이카와 귀엽죠",
//	color: "Pink",
//	isFav: true,
//	price: 20000,
//	openDate: "2024-11-22",
//	locationId: 1,
//	createdAt: "2024-11-24",
//	updatedAt: "2024-11-24", itemPhotos: <#[ItemPhoto]#>,
//	locationName: "화장대",
//	roomName: "지혜방"
//)
let sampleLocation = Location(id: 1, locationName: "책장", locationDesc: "책상 옆 책장", roomId: 1)
let sampleItem = Item(id: 1, itemName: "아이패드", purchaseDate: Optional("2020-10-20T10:56:00.000Z"), expiryDate: Optional("2024-11-20T10:56:25.000Z"), url: Optional("https://apple.com/kr/ipad-pro"), photo: Optional("https://i.namu.wiki/i/T6CkUjJqyNWEudh3KBic3zcUeUo0Ugpl-V6XvfjZb6Cz3pdJ0ACGRSYlIkO9u6iYQELSPgQnWAZqnw5V1kQyOsFYRPNe203Q3BtyPh4bvWLxJ-CVt0k56aCmwqc_gw5VXFq7U2jPXdm5J1Vs2KY7BA.webp"), desc: Optional("Mac Mini 갖고 싶어요"), color: Optional("rose gold"), isFav: true, price: Optional(2000), openDate: nil, locationId: 5, createdAt: "2024-11-20T10:57:34.255Z", updatedAt: "2024-11-24T05:51:54.322Z", itemPhotos: Optional([MyRoomFE.ItemPhoto(id: 1, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 2, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 3, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 4, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 5, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 6, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 7, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 8, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 9, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 10, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s")]), locations: MyRoomFE.Item_Location(locationName: "화장대", rooms: MyRoomFE.Item_Room(roomName: "jh")))

let sampleItemPhoto = [MyRoomFE.ItemPhoto(id: 1, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 2, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 3, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 4, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 5, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 6, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 7, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 8, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 9, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s"), MyRoomFE.ItemPhoto(id: 10, photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMZfTZxZFhld-4Qp7IwlsG1LMhzwHEqAI9g&s")]
