//
//  TrendRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

protocol TrendRepository {
  
  func fetch() async throws -> Trend
}
