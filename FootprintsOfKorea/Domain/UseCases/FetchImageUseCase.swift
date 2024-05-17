//
//  FetchImageUseCase.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/17/24.
//

import Foundation
import RxSwift

protocol FetchImageUseCase {
    func fetchImage(_ url: String) -> Observable<Data>
}

final class DefaultFetchImageUseCase {
    private let repository: KeywordSearchRepository
    
    init(repository: KeywordSearchRepository) {
        self.repository = repository
    }
}

// MARK: FetchImageUseCase Confirmation
extension DefaultFetchImageUseCase: FetchImageUseCase {
    func fetchImage(_ url: String) -> Observable<Data> {
        return Observable.create { [weak self] obsever in
            guard let self = self else { return Disposables.create() }
            
            Task {
                do {
                    let data = try await self.repository.fetchImage(url: url)
                    obsever.onNext(data)
                    obsever.onCompleted()
                } catch {
                    obsever.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
