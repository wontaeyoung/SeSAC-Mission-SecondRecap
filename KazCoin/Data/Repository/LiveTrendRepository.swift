//
//  LiveTrendRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire

final class LiveTrendRepository: TrendRepository {
  
  func fetch() async throws -> Trend {
    return try await AFManager.shared
      .callRequest(responseType: TrendDTO.self, router: SearchRouter.trend)
      .toEntity()
  }
}
