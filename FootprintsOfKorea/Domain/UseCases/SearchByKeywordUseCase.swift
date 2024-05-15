//
//  SearchByKeywordUseCase.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/6/24.
//

import Foundation
import RxSwift

protocol SearchByKeywordUseCase {
    func search(by keyword: String) -> Observable<[BasicModel]>
}

final class DefaultSearchByKeyworkUseCase {
    private let repository: KeywordSearchRepository
    
    init(repository: KeywordSearchRepository) {
        self.repository = repository
    }
}

// MARK: SearchByKeyworkUseCase Confirmation
extension DefaultSearchByKeyworkUseCase: SearchByKeywordUseCase {
    func search(by keyword: String) -> Observable<[BasicModel]> {
        return Observable.create { [weak self] obsever in
            guard let self = self else { return Disposables.create() }
            
            Task {
                do {
                    let models = try await self.repository.search(by: keyword)
                    obsever.onNext(models)
                    obsever.onCompleted()
                } catch {
                    obsever.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
