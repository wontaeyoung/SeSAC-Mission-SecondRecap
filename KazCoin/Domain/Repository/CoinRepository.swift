//
//  CoinRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire

protocol CoinRepository {
  
  func searchFetch(router: AFRouter) async throws -> [Coin]
  func marketFetch(router: AFRouter) async throws -> [Coin]
}
