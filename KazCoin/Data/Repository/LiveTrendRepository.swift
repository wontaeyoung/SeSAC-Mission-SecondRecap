//
//  LiveTrendRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire

final class LiveTrendRepository: TrendRepository {
  
  func fetch() async throws -> Trend {
    print("HERE : \(try! CoinRouter.trend.asURLRequest().url!)")
    return try await HTTPClient.shared
      .callRequest(responseType: TrendDTO.self, router: CoinRouter.trend)
      .toEntity()
  }
}
