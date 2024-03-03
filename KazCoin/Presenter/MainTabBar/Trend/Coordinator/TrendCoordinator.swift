//
//  TrendCoordinator.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import KazRealm

final class TrendCoordinator: Coordinator {
  
  // MARK: - Property
  weak var delegate: CoordinatorDelegate?
  weak var tabBarDelegate: TabBarDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  // MARK: - Initializer
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  // MARK: - Method
  func start() {
    showTrendView()
  }
  
  func showTrendView() {
    let service = LiveRealmService()
    let interestRepository = LiveInterestRepository(service: service)
    let coinRepository = LiveCoinRepository()
    let trendRepository = LiveTrendRepository()
    let viewModel = TrendViewModel(interestRepository: interestRepository, coinRepository: coinRepository, trendRepository: trendRepository)
    let viewController = TrendViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.trend.navigationTitle, displayMode: .always)
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
  
  func moveTab(to tab: MainTabBarPage) {
    tabBarDelegate?.moveTab(to: tab)
  }
}

extension TrendCoordinator: CoordinatorDelegate {
  func coordinatorDidEnd(_ childCoordinator: Coordinator) {
    self.emptyOut()
  }
}
