import Foundation

protocol KeywordSearchRepository {
    func search(by keyword: String) -> Void
}
