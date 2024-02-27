//
//  Coin.swift
//  KazCoin
//
//  Created by 원태영 on 2/27/24.
//

import Foundation
import KazUtility

struct CoinResponse: Entity {
  
  let coins: [Coin]
}

struct Coin: Entity {
  
  let id: String
  let name: String
  let symbol: String
  let icon: String
  let price: Int
  let priceUSD: String
  let marketRank: Int
  let dailyHigh: Int
  let dailyLow: Int
  let priceChangeRate: Double
  let highest: Int
  let hightestAt: Date
  let lowest: Int
  let lowestAt: Date
  let updateAt: Date
  let sparklines: [Double]
  
  var iconURL: URL? {
    return URL(string: icon)
  }
}
