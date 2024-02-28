//
//  UINavigationController+.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit

extension UINavigationController {
  
  func navigationLargeTitleEnabled() -> Self {
    self.navigationBar.prefersLargeTitles = true
    
    return self
  }
  
  func navigationBarHidden() -> Self {
    self.setNavigationBarHidden(true, animated: false)
    
    return self
  }
}

