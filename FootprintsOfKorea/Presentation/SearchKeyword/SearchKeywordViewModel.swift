//
//  SearchKeywordViewModel.swift
//  FootprintsOfKorea
//
//  Created by 김경록 on 5/14/24.
//

import Foundation
import RxSwift

final class SearchKeywordViewModel {
    private let networkSerVice: NetworkService
    
    init(networkSerVice: NetworkService) {
        self.networkSerVice = networkSerVice
    }
    
    func fetchData(_ keyword: String) -> Observable<KeywordSearchReponseModel> {
        let query = Endpoint.searchKeyword(
            osType: .ios,
            arrangeType: .byModifiedTime,
            keyword: keyword,
            key: ""
        )
        
        return Observable.create { [weak self] obsever in
            guard let self = self else { return Disposables.create() }
            
            Task {
                do {
                    let data: KeywordSearchReponseModel = try await self.networkSerVice.request(query: query,
                                                                                                for: KeywordSearchReponseModel.self)
                    
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
