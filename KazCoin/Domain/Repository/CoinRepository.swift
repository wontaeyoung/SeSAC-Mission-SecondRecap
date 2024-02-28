//
//  CoinRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

protocol CoinRepository {
  
  func searchFetch(by searchText: String) async throws -> [Coin]
  func marketFetch(from idList: [String]) async throws -> [Coin]
}
