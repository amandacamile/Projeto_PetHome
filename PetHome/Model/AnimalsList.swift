import Foundation

struct AnimalsList: Decodable {
    let animals: [AnimalDetails]
    let pagination: Pagination
}

struct Pagination: Decodable {
    let countPerPage: Int
    let totalCount: Int
    let currentPage: Int
    let totalPages: Int
    
//    private enum CodingKeys: String, CodingKey {
//        case countPerPage = "count_per_page"
//        case totalCount = "total_count"
//        case currentPage = "current_page"
//        case totalPages = "total_pages"
//    }
}
