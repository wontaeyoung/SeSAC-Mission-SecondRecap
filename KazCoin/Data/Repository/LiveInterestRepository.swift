//
//  LiveInterestRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire
import KazRealm
import RealmSwift

final class LiveInterestRepository: InterestRepository {
  
  // MARK: - Property
  private let service: any RealmService
  
  // MARK: - Initializer
  init(service: RealmService) {
    self.service = service
    
    print(try! Realm().configuration.fileURL!)
  }
  
  // MARK: - Method
  func create(with coin: Coin) throws {
    let realmCoins: Results<RealmCoin> = service.fetch()
    
    guard realmCoins.count < Constant.BusinessLiteral.maxInterestCount else {
      throw CoinError.cannotOverMaximumInterest(max: Constant.BusinessLiteral.maxInterestCount)
    }
    
    try service.create(with: CoinMapper.toRealmObject(from: coin))
  }
  
  func fetch() -> [String] {
    let realmCoins: Results<RealmCoin> = service.fetch()
    
    return realmCoins.map { $0.coinID }
  }
  
  func delete(with coin: Coin) throws {
    let realmCoins: Results<RealmCoin> = service.fetch()
    
    guard let realmCoin = realmCoins.where({ $0.coinID == coin.id }).first else {
      throw RealmError.removeFailed(error: nil)
    }
    
    try service.delete(with: realmCoin)
  }
  
  func remake(from coins: [Coin]) throws {
    let realmCoins: Results<RealmCoin> = service.fetch()
    try service.delete(from: realmCoins)
    
    try coins.forEach {
      try service.create(with: CoinMapper.toRealmObject(from: $0))
    }
  }
  
  func deleteAll() throws {
    let realmCoins: Results<RealmCoin> = service.fetch()
    try service.delete(from: realmCoins)
  }
}
