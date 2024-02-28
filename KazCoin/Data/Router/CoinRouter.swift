//
//  CoinRouter.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire
import Alamofire

enum CoinRouter: AFRouter {
  
  case trend
  case coin(query: String)
  case market(idList: [String])
  
  var method: HTTPMethod {
    switch self {
      case .trend:
        return .get
        
      case .coin:
        return .get
        
      case .market:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.coingecko.com/api/v3"
  }
  
  var path: String {
    switch self {
      case .trend:
        return "search/trending"
        
      case .coin:
        return "search"
        
      case .market:
        return "coins/markets"
    }
  }
  
  var headers: HTTPHeaders {
    return []
  }
  
  var parameters: Parameters? {
    switch self {
      case .trend:
        return nil
        
      case .coin(let query):
        return [ParameterKey.query.key: query]
        
      case .market(let idList):
        return [
          ParameterKey.vs_currency.key: "krw",
          ParameterKey.ids.key: idList.joined(separator: ",")
        ]
    }
  }
  
  enum ParameterKey: String {
    case query
    case vs_currency
    case ids
    
    var key: String {
      return self.rawValue
    }
  }
}
