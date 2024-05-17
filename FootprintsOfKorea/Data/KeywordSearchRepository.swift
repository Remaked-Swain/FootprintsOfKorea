import Foundation

protocol KeywordSearchRepository {
    func search(by keyword: String) async throws -> [BasicModel]
    func fetchImage(url: String) async throws -> Data
}

enum KeywordSearchRepositoryError: Error, CustomDebugStringConvertible {
    case fetchFailed
    
    var debugDescription: String {
        switch self {
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
    
    private func mapToBasicModel(with entity: KeywordSearchResponseModel) -> [BasicModel] {
        
        guard let entity = entity.response?.body?.items?.item else { return [] }
        return entity.map { $0.toDTO() }
    }
}

// MARK: KeywordSearchRepository Confirmation
extension DefaultKeywordSearchRepository: KeywordSearchRepository {
    func search(by keyword: String) async throws -> [BasicModel] {
        do {
            let query = Endpoint.searchKeyword(osType: .ios,
                                               arrangeType: .byModifiedTime,
                                               keyword: keyword)
            let model = try await networkService.request(query: query, for: KeywordSearchResponseModel.self)
            return mapToBasicModel(with: model)
        } catch let error {
            throw error
        }
    }
    
    func fetchImage(url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw KeywordSearchRepositoryError.fetchFailed }
        let data = try await networkService.data(url: url)
        return data
    }
}
