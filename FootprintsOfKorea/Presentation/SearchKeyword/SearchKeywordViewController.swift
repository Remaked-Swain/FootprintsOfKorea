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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "찾고 싶은 키워드를 입력해주세요"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let resultTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: RxSwift
    private var disposeBag = DisposeBag()
    
    //MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        configureUI()
        setConstraints()
        bindViewModel()
    }
    
    private func configureUI() {
        view.addSubview(resultTableView)
        view.addSubview(searchBar)
    }
    
    private func bindViewModel() {
        searchKeywordViewModel.items.bind(
            to: resultTableView.rx.items(
                cellIdentifier: "Cell",
                cellType: ResultTableViewCell.self
            )
        ) { (row,model,cell) in
            cell.bindModel(model: model)
            cell.heightAnchor.constraint(equalToConstant: 120).isActive = true
        }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            resultTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            resultTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            resultTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            resultTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
        ])
    }
}

extension SearchKeywordViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchKeywordViewModel.searchKeyword(searchText)
    }
}
