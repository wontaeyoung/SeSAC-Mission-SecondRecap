//
//  LiveCoinRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire

final class LiveCoinRepository: CoinRepository {
  
  func searchFetch(router: AFRouter) async throws -> [Coin] {
    return try await AFManager.shared
      .callRequest(responseType: CoinResponseDTO.self, router: router)
      .coins
      .map { $0.toEntity() }
  }
  
  func marketFetch(router: AFRouter) async throws -> [Coin] {
    return try await AFManager.shared
      .callRequest(responseType: [CoinDTO].self, router: router)
      .map { $0.toEntity() }
  }
}
