import Foundation

struct KeywordSearchReponseModel: Decodable {
    let response: Response
}

struct Response: Decodable {
    let header: Header
    let body: Body
}

struct Header: Decodable {
    let resultCode, resultMessage: String
    
    enum CodingKeys: String, CodingKey {
        case resultCode
        case resultMessage = "resultMsg"
    }
}

struct Body: Decodable {
    let items: Items
    let numberOfRows, pageNumber, totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case items, totalCount
        case numberOfRows = "numOfRows"
        case pageNumber = "pageNo"
    }
}

struct Items: Decodable {
    let item: [Item]
}

struct Item: Decodable {
    let address, detailAddress, areacode, booktour: String
    let categoryFirst, categorySecond, categoryThird, contentId: String
    let contentTypeId, createdTime: String
    let primaryImage, secondaryImage: String
    let copyrightDivisionCode, coordinateX, coordinateY, mapLevel: String
    let modifiedTime, sigungucode, telephoneNumber, title: String

    enum CodingKeys: String, CodingKey {
        case areacode, booktour, title, sigungucode
        case address = "addr1"
        case detailAddress = "addr2"
        case categoryFirst = "cat1"
        case categorySecond = "cat2"
        case categoryThird = "cat3"
        case contentId = "contentid"
        case contentTypeId = "contenttypeid"
        case createdTime = "createdtime"
        case primaryImage = "firstimage"
        case secondaryImage = "firstimage2"
        case copyrightDivisionCode = "cpyrhtDivCd"
        case coordinateX = "mapx"
        case coordinateY = "mapy"
        case mapLevel = "mlevel"
        case modifiedTime = "modifiedtime"
        case telephoneNumber = "tel"
    }
}
