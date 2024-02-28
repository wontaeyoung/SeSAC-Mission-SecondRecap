//
//  NFTDTO.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazUtility

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
