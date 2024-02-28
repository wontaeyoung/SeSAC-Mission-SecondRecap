//
//  CoinMapper.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

final class CoinMapper {
  
  static func toRealmObject(from coin: Coin) -> RealmCoin {
    return RealmCoin(id: coin.id)
  }
}
