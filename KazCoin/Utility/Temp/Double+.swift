//
//  Double+.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

extension Double {
  var toRoundedRate: String {
    let isMinus: Bool = self.isLess(than: .zero)
    let preOperator: String = isMinus ? "" : "+"
    
    return preOperator + NumberFormatManager.shared.toRounded(from: self, fractionDigits: 2) + "%"
  }
  
  var toRounded: String {
    return NumberFormatManager.shared.toRounded(from: self, fractionDigits: 3)
  }
  
  var toRoundedDollar: String {
    return NumberFormatManager.shared.toRounded(from: self, fractionDigits: 4)
  }
}
