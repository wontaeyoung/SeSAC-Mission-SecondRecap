//
//  AppError.swift
//  KazCoin
//
//  Created by 원태영 on 5/9/24.
//

protocol AppError: Error {
  var logDescription: String { get }
  var alertDescription: String { get }
}

enum CommonError: AppError {
  
  case unknownError(error: Error?)
  
  public var logDescription: String {
    switch self {
      case .unknownError(let error):
        return "알 수 없는 오류 발생 \(error?.localizedDescription ?? .defaultValue)"
    }
  }
  
  public var alertDescription: String {
    switch self {
      case .unknownError:
        return "알 수 없는 오류가 발생했어요. 문제가 지속되면 개발자에게 알려주세요."
    }
  }
}
