//
//  SearchKeywordViewModel.swift
//  FootprintsOfKorea
//
//  Created by 김경록 on 5/14/24.
//

import Foundation
import RxSwift

protocol SearchKeywordViewModel {
    func fetchData(_ keyword: String) -> Observable<[BasicModel]>
}

final class DefaultSearchKeywordViewModel {
    private let searchByKeywordUseCase: SearchByKeywordUseCase
    
    init(searchByKeywordUseCase: SearchByKeywordUseCase) {
        self.searchByKeywordUseCase = searchByKeywordUseCase
    }
}

// MARK: SearchKeywordViewModel Confirmation
extension DefaultSearchKeywordViewModel: SearchKeywordViewModel {
    func fetchData(_ keyword: String) -> Observable<[BasicModel]> {
        return searchByKeywordUseCase.search(by: keyword)
    }
}
