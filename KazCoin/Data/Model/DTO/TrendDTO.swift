//
//  CoinResponse.swift
//  KazCoin
//
//  Created by 원태영 on 2/27/24.
//

import KazUtility

struct TrendDTO: DTO {
  
  let coins: [TrendCoinDTO] // 트렌드 코인
  let nfts: [NFTDTO]        // NFT
  
  func toEntity() -> Trend {
    
    return Trend(
      coins: coins.map { $0.item.toEntity() },
      nfts: nfts.map { $0.toEntity() }
    )
  }
  
  static var defaultValue: TrendDTO {
    
    return TrendDTO(
      coins: [.defaultValue],
      nfts: [.defaultValue]
    )
  }
}

struct TrendCoinDTO: DefaultValueProvidable {
  
  let item: CoinDTO
  
  static var defaultValue: TrendCoinDTO {
    return TrendCoinDTO(item: .defaultValue)
  }
}
