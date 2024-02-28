//
//  CoinError.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazUtility

enum CoinError: AppError {
  
  case cannotOverMaximumInterest(max: Int)
  
  var logDescription: String {
    switch self {
      case .cannotOverMaximumInterest:
        return "관심 코인 최대 갯수 초과"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .cannotOverMaximumInterest(let max):
        return "관심 코인은 \(max)개까지만 설정 가능해요!"
    }
  }
}
