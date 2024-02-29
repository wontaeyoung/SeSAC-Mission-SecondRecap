//
//  SearchCoordinator.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import KazRealm

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
    let service = LiveRealmService()
    let interestRepository = LiveInterestRepository(service: service)
    let coinRepository = LiveCoinRepository()
    let viewModel = SearchViewModel(coinRepository: coinRepository, interestRepository: interestRepository)
    let viewController = SearchViewController(viewModel: viewModel)
      .navigationTitle(with: "Search", displayMode: .always)
      .hideBackTitle()
    
    viewModel.coordinator = self
    self.push(viewController)
  }
  
  func connectChartFlow(coinID: String) {
    let coordinator = ChartCoordinator(self.navigationController)
    coordinator.showChartView(coinID: coinID)
    coordinator.delegate = self
    self.addChild(coordinator)
  }
}

extension SearchCoordinator: CoordinatorDelegate {
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.emptyOut()
  }
}
