//
//  Coin.swift
//  KazCoin
//
//  Created by 원태영 on 2/27/24.
//

import KazUtility

struct CoinResponseDTO: DTO {
  
  let coins: [CoinDTO]
  
  func toEntity() -> CoinResponse {
    
    return CoinResponse(coins: coins.map { $0.toEntity() })
  }
  
  static var defaultValue: CoinResponseDTO {
    
    return CoinResponseDTO(coins: [.defaultValue])
  }
}

struct CoinDTO: DTO {
  
  let id: String
  let name: String
  let symbol: String
  let thumb: String
  let current_price: Int
  let market_cap_rank: Int
  let high_24h: Int
  let low_24h: Int
  let price_change_percentage_24h: Double
  let ath: Double
  let ath_date: String
  let atl: Double
  let atl_date: String
  let last_updated: String
  let sparkline_in_7d: [Double]
  let priceUSD: String
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case symbol
    case thumb
    case image
    case current_price
    case market_cap_rank
    case high_24h
    case low_24h
    case price_change_percentage_24h
    case ath
    case ath_date
    case atl
    case atl_date
    case last_updated
    case sparkline_in_7d
    case data
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decodeWithDefaultValue(String.self, forKey: .id)
    self.name = try container.decodeWithDefaultValue(String.self, forKey: .name)
    self.symbol = try container.decodeWithDefaultValue(String.self, forKey: .symbol)
    self.current_price = try container.decodeWithDefaultValue(Int.self, forKey: .current_price)
    self.market_cap_rank = try container.decodeWithDefaultValue(Int.self, forKey: .market_cap_rank)
    self.high_24h = try container.decodeWithDefaultValue(Int.self, forKey: .high_24h)
    self.low_24h = try container.decodeWithDefaultValue(Int.self, forKey: .low_24h)
    self.price_change_percentage_24h = try container.decodeWithDefaultValue(Double.self, forKey: .price_change_percentage_24h)
    self.ath = try container.decodeWithDefaultValue(Double.self, forKey: .ath)
    self.ath_date = try container.decodeWithDefaultValue(String.self, forKey: .ath_date)
    self.atl = try container.decodeWithDefaultValue(Double.self, forKey: .atl)
    self.atl_date = try container.decodeWithDefaultValue(String.self, forKey: .atl_date)
    self.last_updated = try container.decodeWithDefaultValue(String.self, forKey: .last_updated)
    self.sparkline_in_7d = try container.decodeWithDefaultValue(SparklineDTO.self, forKey: .sparkline_in_7d).price
    self.priceUSD = try container.decodeWithDefaultValue(TrendCoinPriceDTO.self, forKey: .data).price
    
    if let thumb = try container.decodeIfPresent(String.self, forKey: .thumb) {
      self.thumb = thumb
    } else {
      self.thumb = try container.decodeWithDefaultValue(String.self, forKey: .image)
    }
  }
  
  init(
    id: String,
    name: String,
    symbol: String,
    thumb: String,
    current_price: Int,
    market_cap_rank: Int,
    high_24h: Int,
    low_24h: Int,
    price_change_percentage_24h: Double,
    ath: Double,
    ath_date: String,
    atl: Double,
    atl_date: String,
    last_updated: String,
    sparkline_in_7d: [Double],
    priceUSD: String
  ) {
    self.id = id
    self.name = name
    self.symbol = symbol
    self.thumb = thumb
    self.current_price = current_price
    self.market_cap_rank = market_cap_rank
    self.high_24h = high_24h
    self.low_24h = low_24h
    self.price_change_percentage_24h = price_change_percentage_24h
    self.ath = ath
    self.ath_date = ath_date
    self.atl = atl
    self.atl_date = atl_date
    self.last_updated = last_updated
    self.sparkline_in_7d = sparkline_in_7d
    self.priceUSD = priceUSD
  }
  
  func toEntity() -> Coin {
    
    return Coin(
      id: id,
      name: name,
      symbol: symbol,
      icon: thumb,
      price: current_price,
      priceUSD: priceUSD,
      marketRank: market_cap_rank,
      dailyHigh: high_24h,
      dailyLow: low_24h,
      priceChangeRate: price_change_percentage_24h,
      highest: Int(ath), 
      hightestAt: DateManager.shared.isoStringtoDate(with: ath_date),
      lowest: Int(atl),
      lowestAt: DateManager.shared.isoStringtoDate(with: atl_date),
      updateAt: DateManager.shared.isoStringtoDate(with: last_updated),
      sparklines: sparkline_in_7d
    )
  }
  
  static var defaultValue: CoinDTO {
    
    return CoinDTO(
      id: .defaultValue,
      name: .defaultValue,
      symbol: .defaultValue,
      thumb: .defaultValue,
      current_price: .defaultValue,
      market_cap_rank: .defaultValue, 
      high_24h: .defaultValue,
      low_24h: .defaultValue,
      price_change_percentage_24h: .defaultValue,
      ath: .defaultValue,
      ath_date: .defaultValue,
      atl: .defaultValue,
      atl_date: .defaultValue,
      last_updated: .defaultValue,
      sparkline_in_7d: [], 
      priceUSD: .defaultValue
    )
  }
}

struct SparklineDTO: DefaultValueProvidable {
  
  let price: [Double]
  
  static var defaultValue: SparklineDTO {
    
    return SparklineDTO(price: [.defaultValue])
  }
}
