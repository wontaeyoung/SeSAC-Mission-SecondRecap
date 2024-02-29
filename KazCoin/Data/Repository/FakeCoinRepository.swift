//
//  FakeCoinRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

import KazUtility
import Foundation

final class FakeCoinRepository: CoinRepository {
  
  func fetch(by searchText: String) async throws -> [Coin] {
    guard let path = Bundle.main.path(forResource: "SearchCoin", ofType: "json"),
          let jsonString = try? String(contentsOfFile: path),
          let data = jsonString.data(using: .utf8)
    else {
      return []
    }
    
    return try JsonCoder.shared.decode(to: CoinResponseDTO.self, from: data)
      .coins
      .map { $0.toEntity() }
  }
  
  func fetch(from idList: [String]) async throws -> [Coin] {
    guard let path = Bundle.main.path(forResource: "MarketCoin", ofType: "json"),
          let jsonString = try? String(contentsOfFile: path),
          let data = jsonString.data(using: .utf8)
    else {
      return []
    }
    
    return try JsonCoder.shared.decode(to: [CoinDTO].self, from: data)
      .map { $0.toEntity() }
      .filter { idList.contains($0.id) }
  }
}

