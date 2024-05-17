//
//  SearchKeywordViewModel.swift
//  FootprintsOfKorea
//
//  Created by 김경록 on 5/14/24.
//

import Foundation
import RxSwift

protocol SearchKeywordViewModel {
    func searchKeyword(_ keyword: String)
    var items: PublishSubject<[BasicModel]> { get }
}

final class DefaultSearchKeywordViewModel {
    private let searchByKeywordUseCase: SearchByKeywordUseCase
    var items = PublishSubject<[BasicModel]>()
    
    var disposeBag = DisposeBag()
    
    init(searchByKeywordUseCase: SearchByKeywordUseCase) {
        self.searchByKeywordUseCase = searchByKeywordUseCase
    }
}

// MARK: SearchKeywordViewModel Confirmation
extension DefaultSearchKeywordViewModel: SearchKeywordViewModel {
    func searchKeyword(_ keyword: String)  {
        searchByKeywordUseCase.search(by: keyword)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] model in
                self?.items.onNext(model)
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}
