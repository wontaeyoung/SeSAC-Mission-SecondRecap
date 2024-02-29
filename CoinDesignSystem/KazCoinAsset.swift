//
//  KazCoinAsset.swift
//  CoinDesignSystem
//
//  Created by 원태영 on 2/27/24.
//

import UIKit

public enum KazCoinAsset {
  
  public enum LabelTitle {
    
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
  
  public enum Color {
    
    public static let brand: UIColor = .init(hex: "914CF5")
    public static let plusLabel: UIColor = .init(hex: "F04452")
    public static let plusBackground: UIColor = .init(hex: "FFEAED")
    public static let minusLabel: UIColor = .init(hex: "3282F8")
    public static let minusBackground: UIColor = .init(hex: "E5F0FF")
    public static let titleName: UIColor = .init(hex: "000000")
    public static let searchCoinName: UIColor = .init(hex: "000000")
    public static let symbolName: UIColor = .init(hex: "828282")
    public static let primaryText: UIColor = .init(hex: "343D4C")
    public static let cardBackground: UIColor = .init(hex: "F3F4F6")
    public static let background: UIColor = .init(hex: "FFFFFF")
  }
}
