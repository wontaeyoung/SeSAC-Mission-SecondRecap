//
//  SearchViewController.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit
import Toast

final class SearchViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var searchBar = UISearchBar().configured {
    $0.placeholder = Constant.LabelTitle.searchCoinPlaceholder
    $0.tintColor = KazCoinAsset.Color.brand
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.becomeFirstResponder()
    $0.delegate = self
    $0.backgroundImage = .init()
  }
  
  private lazy var searchController = UISearchController(searchResultsController: nil).configured {
    $0.searchBar.placeholder = Constant.LabelTitle.searchCoinPlaceholder
    $0.searchBar.tintColor = KazCoinAsset.Color.brand
    $0.searchBar.autocapitalizationType = .none
    $0.searchBar.autocorrectionType = .no
    $0.searchBar.spellCheckingType = .no
    $0.searchBar.becomeFirstResponder()
    $0.searchBar.delegate = self
    $0.searchBar.backgroundImage = .init()
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
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.input.viewWillAppearEvent.onNext(())
  }
  
  override func setHierarchy() {
    view.addSubviews(searchBar, tableView)
  }
  
  override func setAttribute() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: .tabUser, style: .plain, target: self, action: #selector(profileBarButtonTapped))
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
    viewModel.input.viewDidLoadEvent.onNext(())
    
    viewModel.output.interestCoins.subscribe { [weak self] _ in
      guard let self else { return }
      
      tableView.reloadData()
    }
    
    viewModel.output.coins.subscribe { [weak self] _ in
      guard let self else { return }
      
      tableView.reloadData()
    }
    
    viewModel.output.interestToast.subscribe { [weak self] message in
      guard let self else { return }
      
      view.makeToast(
        message,
        duration: 1.0,
        position: .center,
        title: Constant.LabelTitle.interestConfiguration
      )
    }
    
    viewModel.output.loadingIndicatorToggle.subscribe { [weak self] isOn in
      guard let self else { return }
      guard let isOn else { return }
      
      if isOn {
        view.makeToastActivity(.center)
      } else {
        view.hideToastActivity()
      }
    }
  }
  
  // MARK: - Selector
  @objc private func profileBarButtonTapped() {
    viewModel.input.profileButtonTapEvent.onNext(())
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
    let cell = tableView.dequeueReusableCell(
      withIdentifier: SearchTableViewCell.identifier,
      for: indexPath
    ) as! SearchTableViewCell
    let item: Coin = viewModel.itemAt(indexPath)
    let interested: Bool = viewModel.interestedAt(indexPath)
    
    cell.updateUI(
      with: item,
      interested: interested,
      searchText: viewModel.currentSearchText
    )
    
    cell.updateTapEvent { [weak self] in
      guard let self else { return }
      
      viewModel.input.interestButtonTapEvent.onNext(indexPath)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.input.didSelectRowEvent.onNext(indexPath)
  }
}
