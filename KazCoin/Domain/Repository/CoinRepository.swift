//
//  CoinRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

protocol CoinRepository {
  
  func fetch(by searchText: String) async throws -> [Coin]
  func fetch(from idList: [String]) async throws -> [Coin]
}
