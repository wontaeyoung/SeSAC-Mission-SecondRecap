//
//  SearchRouter.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazAlamofire
import Alamofire

enum SearchRouter: AFRouter {
  
  case trend
  case coin(query: String)
  
  var method: HTTPMethod {
    switch self {
      case .trend:
        return .get
        
      case .coin:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.coingecko.com/api/v3/search"
  }
  
  var path: String {
    switch self {
      case .trend:
        return "trending"
        
      case .coin:
        return ""
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
    }
  }
  
  enum ParameterKey: String {
    case query
    
    var key: String {
      return self.rawValue
    }
  }
}
