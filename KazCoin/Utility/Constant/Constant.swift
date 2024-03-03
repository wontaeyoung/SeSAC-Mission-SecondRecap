//
//  Constant.swift
//  KazCoin
//
//  Created by 원태영 on 3/3/24.
//

enum Constant {
  
  enum LabelTitle {
    
    static let emptyInterestCoin: String = "즐겨찾기한 코인이 없어요!"
    static let interestMovedMessage: String = "위치가 이동했어요."
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
