//
//  ViewController.swift
//  FootprintsOfKorea
//
//  Created by Swain Yun on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchKeywordViewController: UIViewController {
    // MARK: Dependencies
    private let searchKeywordViewModel: SearchKeywordViewModel = {
        let sessionManager = DefaultNetworkSessionManager()
        let networkService = DefaultNetworkService(networkSessionManager: sessionManager)
        let repository = DefaultKeywordSearchRepository(networkService: networkService)
        let usecase = DefaultSearchByKeyworkUseCase(repository: repository)
        let viewModel = DefaultSearchKeywordViewModel(searchByKeywordUseCase: usecase)
        return viewModel
    }()
    
    // MARK: View Components
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: RxSwift
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        hierarchy()
        layout()
        
        searchKeywordViewModel.fetchData("강원")
            .observe(on: MainScheduler.instance)
            .subscribe { model in
                self.label.text = model.first!.title
            } onError: { error in
                self.label.text = error.localizedDescription
            }
            .disposed(by: disposeBag)
    }
    
    private func hierarchy() {
        view.addSubview(label)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
