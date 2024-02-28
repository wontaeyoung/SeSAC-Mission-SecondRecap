//
//  LiveCoinRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire

final class LiveCoinRepository: CoinRepository {
  
  func fetch(by searchText: String) async throws -> [Coin] {
    return try await AFManager.shared
      .callRequest(responseType: CoinResponseDTO.self, router: SearchRouter.coin(query: searchText))
      .coins
      .map { $0.toEntity() }
  }
  
  func fetch(from idList: [String]) async throws -> [Coin] {
    return try await AFManager.shared
      .callRequest(responseType: [CoinDTO].self, router: CoinRouter.market(idList: idList))
      .map { $0.toEntity() }
  }
}
