import Foundation

protocol KeywordSearchRepository {
    func search(by keyword: String) async throws -> [BasicModel]
}

enum KeywordSearchRepositoryError: Error, CustomDebugStringConvertible {
    case invalidKey
    case fetchFailed
    
    var debugDescription: String {
        switch self {
        case .invalidKey: "키가 유효하지 않음"
        case .fetchFailed: "값을 가져올 수 없음"
        }
    }
}

final class DefaultKeywordSearchRepository {
    private typealias Key = String
    
    private let networkService: NetworkService
    private let apiKey: String? = Bundle.main.korServiceAPIKey
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private func validateAPIKey() throws -> Key {
        guard let key = apiKey else { throw KeywordSearchRepositoryError.invalidKey }
        return key
    }
    
    private func mapToBasicModel(with entity: KeywordSearchResponseModel) -> [BasicModel] {
        return entity.response.body.items.item.map { $0.toDTO() }
    }
}

// MARK: KeywordSearchRepository Confirmation
extension DefaultKeywordSearchRepository: KeywordSearchRepository {
    func search(by keyword: String) async throws -> [BasicModel] {
        do {
            let apiKey = try validateAPIKey()
            let query = Endpoint.searchKeyword(osType: .ios,
                                               arrangeType: .byModifiedTime,
                                               keyword: keyword,
                                               key: apiKey)
            let model = try await networkService.request(query: query, for: KeywordSearchResponseModel.self)
            return mapToBasicModel(with: model)
        } catch let error {
            throw error
        }
    }
}
