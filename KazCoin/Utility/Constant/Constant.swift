//
//  Constant.swift
//  KazCoin
//
//  Created by 원태영 on 3/3/24.
//

enum Constant {
  
  enum LabelTitle {
    
    static let emptyInterestCoin: String = "즐겨찾기한 코인이 없어요!"
    static let interestMovedMessage: String = "가 이동했어요."
    static let deleteInterestTitle: String = "즐겨찾기 삭제"
    static let deleteInterestMessage: String = "관심 코인을 모두 삭제할까요?"
    static let deletedIterestMessage: String = "모든 관심 코인이 삭제되었어요."
    static let coinRefeshedTitle: String = "코인 업데이트"
    static let coinRefeshedMessage: String = "코인 정보를 갱신했어요."
    
    static let expandCoin: String = "더 보기"
    static let searchCoinPlaceholder: String = "Coin Name"
    static let today: String = "Today"
    static let highPrice: String = "고가"
    static let lowPrice: String = "저가"
    static let highestPrice: String = "신고점"
    static let lowestPrice: String = "신저점"
    static let interestConfiguration: String = "즐겨찾기 설정"
    static func interestToggleMessage(_ coinName: String, isOn: Bool) -> String {
      return "\(coinName)이 \(isOn ? "추가" : "삭제")되었어요."
    }
  }
  
  enum BusinessLiteral {
    
    static let maxInterestCount: Int = 10
    static let shouldShowFavoriteCoinCount: Int = 2
    static let trendExpandCoinCount: Int = 4
  }
}
