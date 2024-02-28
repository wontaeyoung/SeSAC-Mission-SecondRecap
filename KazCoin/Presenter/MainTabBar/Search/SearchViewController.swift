//
//  SearchViewController.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import SnapKit

final class SearchViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var searchBar = UISearchBar().configured {
    $0.placeholder = "Coin Name"
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.becomeFirstResponder()
    $0.delegate = self
    $0.backgroundImage = .init()
  }
  
  private lazy var searchController = UISearchController(searchResultsController: nil).configured {
    $0.searchBar.placeholder = "Coin Name"
    $0.searchBar.autocapitalizationType = .none
    $0.searchBar.autocorrectionType = .no
    $0.searchBar.spellCheckingType = .no
    $0.searchBar.becomeFirstResponder()
    $0.searchBar.delegate = self
  }
  
  private lazy var tableView = UITableView().configured {
    $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
    $0.separatorStyle = .none
    $0.keyboardDismissMode = .onDrag
  }
  
  // MARK: - Property
  let viewModel: SearchViewModel
  
  // MARK: - Initializer
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(searchBar, tableView)
  }
  
  override func setAttribute() {
    
  }
  
  override func setConstraint() {
    searchBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(view).inset(8)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(searchBar.snp.bottom)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.output.coins.subscribe { [weak self] _ in
      guard let self else { return }
      
      tableView.reloadData()
    }
  }
  
  // MARK: - Method
  
  // MARK: - Selector
  @objc private func interestButtonTapped() {
    print(#function)
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.input.searchButtonTapEvent.onNext(searchBar.text)
  }
}

extension SearchViewController: TableControllable {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
    let item: Coin = viewModel.itemAt(indexPath)
    
    cell.updateUI(with: item, interested: .random())
    cell.updateTapEvent(#selector(interestButtonTapped), target: self)
    
    return cell
  }
}
