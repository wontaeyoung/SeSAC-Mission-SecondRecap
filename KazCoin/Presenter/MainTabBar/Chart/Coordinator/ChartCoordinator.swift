//
//  ChartCoordinator.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

import UIKit
import KazUtility
import KazRealm

final class ChartCoordinator: Coordinator {
  
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }
  
  func start() {
    
  }
  
  func showChartView(coinID: String) {
    let service = LiveRealmService()
    let interestRepository = LiveInterestRepository(service: service)
    let coinRepository = LiveCoinRepository()
    let viewModel = ChartViewModel(coinRepository: coinRepository, interestRepository: interestRepository, coinID: coinID)
    let viewController = ChartViewController(viewModel: viewModel)
      .navigationTitle(with: "", displayMode: .never)
    
    viewModel.coordinator = self
    self.push(viewController)
  }
}

