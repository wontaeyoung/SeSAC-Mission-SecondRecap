//
//  RealmError+.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import KazRealm
import KazUtility

extension RealmError: AppError {
  
  public static var contactDeveloperMessage = "문제가 지속되면 개발자에게 알려주세요."
  
  public var logDescription: String {
    switch self {
      case .getRealmFailed:
        return "Realm 데이터베이스 객체를 생성하는데 실패했습니다."
        
      case .observedChangeError(let error):
        return "감지된 변경사항에서 에러가 발생했습니다. \(error?.localizedDescription ?? "")"
        
      case .addFailed(let error):
        return "데이터 추가에 실패했습니다. \(error?.localizedDescription ?? "")"
        
      case .updateFailed(let error):
        return "데이터 업데이트에 실패했습니다. \(error?.localizedDescription ?? "")"
        
      case .removeFailed(let error):
        return "데이터 삭제에 실패했습니다. \(error?.localizedDescription ?? "")"
        
      case .fetchFailed(let error):
        return "데이터 로드에 실패했습니다. \(error?.localizedDescription ?? "")"
      
      case .objectNotFoundWithID(let id):
        return "ID에 해당하는 객체를 찾을 수 없습니다. ID: \(id.stringValue)"
    }
  }
  
  public var alertDescription: String {
    switch self {
      case .getRealmFailed, .observedChangeError, .fetchFailed, .objectNotFoundWithID:
        return "정보를 가져오는데 실패했어요. \(RealmError.contactDeveloperMessage)"
        
      case .addFailed:
        return "데이터를 추가하지 못했어요. \(RealmError.contactDeveloperMessage)"
        
      case .updateFailed:
        return "데이터를 수정하지 못했어요. \(RealmError.contactDeveloperMessage)"
        
      case .removeFailed:
        return "데이터를 삭제하지 못했어요. \(RealmError.contactDeveloperMessage)"
    }
  }
}
