//
//  NFT.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import Foundation
import KazUtility

struct NFT: Entity {
  
  let name: String                              // NFT 토큰명
  let symbol: String                            // NFT 식별자 심볼
  let icon: String                              // NFT 아이콘 리소스 URL
  let currencySymbol: String                    // NFT 거래 기본 화폐 단위
  let floorPrice: Double                        // NFT 컬렉션 최저가
  let floorPriceChangeRate: Double              // NFT 컬렉션 최저가 변동률
  
  var iconURL: URL? {
    return URL(string: icon)
  }
}
