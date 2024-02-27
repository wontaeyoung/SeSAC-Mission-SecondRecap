//
//  TrendRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire

protocol TrendRepository {
  
  func fetch(router: AFRouter) async throws -> Trend
}
