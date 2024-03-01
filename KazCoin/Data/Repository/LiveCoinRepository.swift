//
//  LiveCoinRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire

final class LiveCoinRepository: CoinRepository {
  
  // MARK: - Method
  func fetch(by searchText: String) async throws -> [Coin] {
    return try await AFManager.shared
      .callRequest(responseType: CoinResponseDTO.self, router: CoinRouter.coin(query: searchText))
      .toEntity()
      .coins
  }
  
  func fetch(from idList: [String]) async throws -> [Coin] {
    return try await AFManager.shared
      .callRequest(responseType: [CoinDTO].self, router: CoinRouter.market(idList: idList))
      .map { $0.toEntity() }
  }
}
