//
//  UserCoordinator.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import KazRealm

final class UserCoordinator: Coordinator {
  
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
    showUserView()
  }
  
  func showUserView() {
    let service = LiveRealmService()
    let repository = LiveInterestRepository(service: service)
    let viewModel = UserViewModel(repository: repository)
    let viewController = UserViewController(viewModel: viewModel)
      .navigationTitle(with: MainTabBarPage.user.navigationTitle, displayMode: .always)
      .hideBackTitle()
    
    viewModel.coordinator = self
    self.push(viewController)
  }
}

