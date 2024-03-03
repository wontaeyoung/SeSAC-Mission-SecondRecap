//
//  MainTabBarPage.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit

enum MainTabBarPage: Int, CaseIterable {
  case trend
  case search
  case portfolio
  case user
  
  var index: Int {
    self.rawValue
  }
  
  var navigationTitle: String {
    switch self {
      case .trend:
        return "Crypto Coin"
      case .search:
        return "Search"
      case .portfolio:
        return "Favorite Coin"
      case .user:
        return "Profile"
    }
  }
  
  var icon: UIImage {
    switch self {
      case .trend:
        return .tabTrendInactive
      case .search:
        return .tabSearchInactive
      case .portfolio:
        return .tabPortfolioInactive
      case .user:
        return .tabUserInactive
    }
  }
  
  var selectedIcon: UIImage {
    switch self {
      case .trend:
        return .tabTrend
      case .search:
        return .tabSearch
      case .portfolio:
        return .tabPortfolio
      case .user:
        return .tabUser
    }
  }
  
  var tabBarItem: UITabBarItem {
    return UITabBarItem(
      title: nil,
      image: icon,
      selectedImage: selectedIcon
    )
  }
}
