//
//  Constant.swift
//  KazCoin
//
//  Created by 원태영 on 3/3/24.
//

enum Constant {
  enum LabelTitle {
    
    public static let searchCoinPlaceholder: String = "Coin Name"
    
    public static let today: String = "Today"
    public static let highPrice: String = "고가"
    public static let lowPrice: String = "저가"
    public static let highestPrice: String = "신고점"
    public static let lowestPrice: String = "신저점"
    
    public static let interestConfiguration: String = "즐겨찾기 설정"
    public static func interestToggleMessage(_ coinName: String, isOn: Bool) -> String {
      return "\(coinName)이 \(isOn ? "추가" : "삭제")되었어요."
    }
  }
  
  enum BusinessLiteral {
    
  }

}
