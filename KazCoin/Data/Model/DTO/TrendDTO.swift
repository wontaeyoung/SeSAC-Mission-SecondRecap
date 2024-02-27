//
//  CoinResponse.swift
//  KazCoin
//
//  Created by 원태영 on 2/27/24.
//

import KazUtility

struct TrendResponseDTO: DTO {
  
  let trendCoins: [TrendCoinDTO] // 트렌드 코인
  let nfts: [NFTDTO]             // NFT
  
  func toEntity() -> TrendResponse {
    
    return TrendResponse(
      trendCoins: trendCoins.map { $0.toEntity() },
      nfts: nfts.map { $0.toEntity() }
    )
  }
  
  static var defaultValue: TrendResponseDTO {
    
    return TrendResponseDTO(
      trendCoins: [.defaultValue],
      nfts: [.defaultValue]
    )
  }
}

struct TrendCoinDTO: DTO {
    
  let item: TrendCoinItemDTO // 코인 정보
  
  func toEntity() -> TrendCoin {
    
    return TrendCoin(
      id: item.id,
      name: item.name,
      symbol: item.symbol,
      icon: item.small,
      marketRank: item.market_cap_rank,
      price: item.data.price,
      priceChangeRateKRW: item.data.price_change_percentage_24h.krw
    )
  }
  
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


struct TrendCoinItemDTO: DefaultValueProvidable {
  
  let id: String              // 코인 ID
  let name: String            // 코인 이름
  let symbol: String          // 코인 식별자 심볼
  let market_cap_rank: Int    // 코인 랭킹
  let small: String           // 코인 아이콘 리소스 URL
  let data: TrendCoinPriceDTO // 코인 가격 정보
  
  static var defaultValue: TrendCoinItemDTO {
    
    return TrendCoinItemDTO(
      id: .defaultValue,
      name: .defaultValue,
      symbol: .defaultValue,
      market_cap_rank: .defaultValue,
      small: .defaultValue,
      data: .defaultValue
    )
  }
}

struct TrendCoinPriceDTO: DefaultValueProvidable {
  
  let price: String                                        // 코인 현재가
  let price_change_percentage_24h: TrendCoinPriceChangeDTO // 국가별 24시간 코인 변동률
  
  static var defaultValue: TrendCoinPriceDTO {
    
    return TrendCoinPriceDTO(
      price: .defaultValue,
      price_change_percentage_24h: .defaultValue
    )
  }
}

struct TrendCoinPriceChangeDTO: DefaultValueProvidable {
  
  let krw: Double // 한국 코인 24시간 변동률
  
  static var defaultValue: TrendCoinPriceChangeDTO {
    
    return TrendCoinPriceChangeDTO(krw: .defaultValue)
  }
}
