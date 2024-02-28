//
//  SearchCoordinator.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility

final class SearchCoordinator: Coordinator {
  
  // MARK: - Property
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [any Coordinator]
  
  // MARK: - Initializer
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  // MARK: - Method
  func start() {
    showSearchView()
  }
  
  func showSearchView() {
    let repository = LiveCoinRepository()
    let viewModel = SearchViewModel(repository: repository)
    let viewController = SearchViewController(viewModel: viewModel)
      .navigationTitle(with: "Search", displayMode: .always)
      .hideBackTitle()
    
    self.push(viewController)
  }
}

