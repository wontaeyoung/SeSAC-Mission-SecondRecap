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
  private let maxInterestCount: Int = 10
  
  // MARK: - Initializer
  init(service: RealmService) {
    self.service = service
    
    print(try! Realm().configuration.fileURL!)
  }
  
  // MARK: - Method
  func create(with coin: Coin) throws {
    let realmCoins: Results<RealmCoin> = service.fetch()
    
    guard realmCoins.count < maxInterestCount else {
      throw CoinError.cannotOverMaximumInterest(max: maxInterestCount)
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
}

