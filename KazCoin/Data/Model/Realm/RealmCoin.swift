//
//  RealmCoin.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazRealm
import RealmSwift

final class RealmCoin: Object, RealmModel {
  
  enum Column: String {
    
    case id
    case coinID
  }
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted(indexed: true) var coinID: String
  
  convenience init(id: String) {
    self.init()
    self.coinID = id
  }
}
