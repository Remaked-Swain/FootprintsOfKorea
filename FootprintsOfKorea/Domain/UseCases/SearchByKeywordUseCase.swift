//
//  SearchByKeywordUseCase.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/6/24.
//

import Foundation

protocol SearchByKeywordUseCase {
    @MainActor func search(by keywork: String) async throws
}

final class DefaultSearchByKeyworkUseCase {
//    private let repository
}

// MARK: SearchByKeyworkUseCase Confirmation
extension DefaultSearchByKeyworkUseCase: SearchByKeywordUseCase {
    @MainActor func search(by keywork: String) async throws {
        // call repository method
    }
}
