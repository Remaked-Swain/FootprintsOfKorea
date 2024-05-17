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
    func fetchImage(from url: String) -> Observable<Data>
    var items: PublishSubject<[BasicModel]> { get }
}

final class DefaultSearchKeywordViewModel {
    private let searchByKeywordUseCase: SearchByKeywordUseCase
    private let fetchImageUseCase: FetchImageUseCase
    var items = PublishSubject<[BasicModel]>()
    
    var disposeBag = DisposeBag()
    
    init(
        searchByKeywordUseCase: SearchByKeywordUseCase,
        fetchImageUseCase: FetchImageUseCase
    ) {
        self.searchByKeywordUseCase = searchByKeywordUseCase
        self.fetchImageUseCase = fetchImageUseCase
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
    
    func fetchImage(from url: String) -> Observable<Data> {
        return fetchImageUseCase.fetchImage(url)
            .observe(on: MainScheduler.asyncInstance)
    }
}
