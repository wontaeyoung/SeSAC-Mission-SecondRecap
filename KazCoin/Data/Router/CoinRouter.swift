//
//  CoinRouter.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire
import Alamofire

enum CoinRouter: AFRouter {
  
  case market(idList: [String])
  
  var method: HTTPMethod {
    switch self {
      case .market:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.coingecko.com/api/v3/coins"
  }
  
  var path: String {
    switch self {
      case .market:
        return "markets"
    }
  }
  
  var headers: HTTPHeaders {
    return []
  }
  
  var parameters: Parameters? {
    switch self {
      case .market(let idList):
        return [
          ParameterKey.vs_currency.key: "krw",
          ParameterKey.ids.key: idList.joined(separator: ",")
        ]
    }
  }
  
  enum ParameterKey: String {
    case vs_currency
    case ids
    
    var key: String {
      return self.rawValue
    }
  }
}

