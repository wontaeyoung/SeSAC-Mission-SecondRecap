//
//  PortfolioCoordinator.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import KazRealm

final class PortfolioCoordinator: Coordinator {
  
  // MARK: - Property
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  // MARK: - Initializer
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  // MARK: - Method
  func start() {
    showPortfolioView()
  }
  
  func showPortfolioView() {
    let service = LiveRealmService()
    let interestRepository = LiveInterestRepository(service: service)
    let coinRepository = LiveCoinRepository()
    let viewModel = PortfolioViewModel(coinRepository: coinRepository, interestRepository: interestRepository)
    let viewController = PortfolioViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.portfolio.navigationTitle, displayMode: .always)
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

extension PortfolioCoordinator: CoordinatorDelegate {
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.emptyOut()
  }
}
