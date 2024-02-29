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
    
    return preOperator + NumberFormatManager.shared.toRounded(from: self) + "%"
  }
}
