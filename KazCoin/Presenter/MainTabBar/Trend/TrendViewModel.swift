//
//  TrendViewModel.swift
//  KazCoin
//
//  Created by 원태영 on 3/2/24.
//

import KazUtility

final class TrendViewModel: ViewModel {
  
  enum TrendSection: String, CaseIterable {
    case interest = "My Favorite"
    case topCoin = "Top 15 Coin"
    case topNFT = "Top 7 NFT"
    
    var title: String {
      return self.rawValue
    }
  }
  
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  // MARK: - Property
  weak var coordinator: TrendCoordinator?
  private let repository: any TrendRepository
  var sections: [TrendSection] {
    return TrendSection.allCases
  }
  
  // MARK: - Initializer
  init(repository: any TrendRepository) {
    self.repository = repository
    
    transform()
  }
  
  // MARK: - Method
  func transform() {
    
  }
  
  func numberOfSection() -> Int {
    return sections.count
  }
  
  func sectionAt(_ index: Int) -> TrendSection {
    return sections[index]
  }
}

