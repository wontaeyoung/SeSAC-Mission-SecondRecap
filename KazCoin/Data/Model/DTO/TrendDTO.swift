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

struct NFTDTO: DTO {
  
  let name: String                              // NFT 토큰명
  let symbol: String                            // NFT 식별자 심볼
  let thumb: String                             // NFT 아이콘 리소스 URL
  let native_currency_symbol: String            // NFT 거래 기본 화폐 단위
  let floor_price_in_native_currency: Double    // NFT 컬렉션 최저가
  let floor_price_24h_percentage_change: Double // NFT 컬렉션 최저가 변동률
  
  func toEntity() -> NFT {
    
    return NFT(
      name: name,
      symbol: symbol,
      icon: thumb,
      currencySymbol: native_currency_symbol,
      floorPrice: floor_price_in_native_currency,
      floorPriceChangeRate: floor_price_24h_percentage_change
    )
  }
  
  static var defaultValue: NFTDTO {
    
    return NFTDTO(
      name: .defaultValue,
      symbol: .defaultValue,
      thumb: .defaultValue,
      native_currency_symbol: .defaultValue,
      floor_price_in_native_currency: .defaultValue,
      floor_price_24h_percentage_change: .defaultValue
    )
  }
}
