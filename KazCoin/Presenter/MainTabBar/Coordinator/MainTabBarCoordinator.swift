//
//  MainTabBarCoordinator.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility

protocol TabBarDelegate: AnyObject {
  func moveTab(to tab: MainTabBarPage)
}

extension MainTabBarCoordinator: TabBarDelegate {
  func moveTab(to tab: MainTabBarPage) {
    tabBarController.selectedIndex = tab.index
  }
}

final class MainTabBarCoordinator: Coordinator {
  
  // MARK: - Property
  weak var delegate: CoordinatorDelegate?
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]
  var tabBarController: UITabBarController
  
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
    self.tabBarController = UITabBarController()
  }
  
  
  // MARK: - Method
  func start() {
    let rootNavigationControllers = MainTabBarPage.allCases.map { page in
      makeNavigationController(with: page)
    }
    
    configureTabBarController(with: rootNavigationControllers)
    self.push(tabBarController)
  }
  
  private func configureTabBarController(with controllers: [UINavigationController]) {
    tabBarController.configure {
      $0.setViewControllers(controllers, animated: false)
      $0.selectedIndex = MainTabBarPage.trend.index
    }
  }
  
  private func makeNavigationController(with page: MainTabBarPage) -> UINavigationController {
    return UINavigationController().configured {
      $0.tabBarItem = page.tabBarItem
      connectTabFlow(page: page, tabPageController: $0)
    }
    .navigationLargeTitleEnabled()
  }
  
  private func connectTabFlow(page: MainTabBarPage, tabPageController: UINavigationController) {
    switch page {
      case .trend:
        let coordinator = TrendCoordinator(tabPageController)
        coordinator.start()
        coordinator.tabBarDelegate = self
        self.addChild(coordinator)
        
      case .search:
        let coordinator = SearchCoordinator(tabPageController)
        coordinator.start()
        coordinator.tabBarDelegate = self
        self.addChild(coordinator)
        
      case .portfolio:
        let coordinator = PortfolioCoordinator(tabPageController)
        coordinator.start()
        coordinator.tabBarDelegate = self
        self.addChild(coordinator)
        
      case .user:
        let coordinator = UserCoordinator(tabPageController)
        coordinator.start()
        self.addChild(coordinator)
    }
  }
}
