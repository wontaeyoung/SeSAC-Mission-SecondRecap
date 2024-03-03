//
//  AppDelegate.swift
//  KazCoin
//
//  Created by 원태영 on 2/27/24.
//

import UIKit
import Toast
import CoinDesignSystem

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ToastManager.shared.style = ToastStyle().configured {
      $0.backgroundColor = KazCoinAsset.Color.cardBackground
      $0.messageColor = KazCoinAsset.Color.primaryText
      $0.messageFont = .systemFont(ofSize: 15, weight: .semibold)
      $0.titleColor = KazCoinAsset.Color.brand
      $0.titleFont = .systemFont(ofSize: 17, weight: .bold)
      $0.titleAlignment = .center
      $0.activityBackgroundColor = .clear
      $0.activityIndicatorColor = KazCoinAsset.Color.primaryText
    }
    
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
  }
}
