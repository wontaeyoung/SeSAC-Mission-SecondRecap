//
//  CoinError.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazUtility

enum CoinError: AppError {
  
  case cannotOverMaximumInterest(max: Int)
  case noResultWithID(id: String)
  case tooManyRequest
  
  var logDescription: String {
    switch self {
      case .cannotOverMaximumInterest:
        return "관심 코인 최대 갯수 초과"
        
      case .noResultWithID(let id):
        return "\(id) 코인 마켓 조회 결과 없음"
        
      case .tooManyRequest:
        return "API 요청 횟수 초과"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .cannotOverMaximumInterest(let max):
        return "관심 코인은 \(max)개까지만 설정 가능해요!"
        
      case .noResultWithID:
        return "코인 정보를 찾을 수 없어요. 확인을 누르면 이전 화면으로 돌아가요."
        
      case .tooManyRequest:
        return "요청 횟수가 초과되었어요. 잠시 후에 다시 시도해주세요!"
    }
  }
}
