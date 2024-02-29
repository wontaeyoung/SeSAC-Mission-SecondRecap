//
//  Int+.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

import Foundation

extension Int {
  var toCurrency: String {
    return "₩\(NumberFormatManager.shared.toCurrency(from: self))"
  }
}
