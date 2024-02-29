//
//  NumberFormatManager.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import Foundation

public final class NumberFormatManager {
  
  public static let shared = NumberFormatManager()
  private init() { configFormatter() }
  
  // MARK: - Property
  private let formatter = NumberFormatter()

  // MARK: - Method
  private func configFormatter() {
    formatter.numberStyle = .decimal
    formatter.roundingMode = .halfUp
    formatter.maximumFractionDigits = 2
  }
  
  func toCurrency(from number: Int) -> String {
    return formatter.string(from: number as NSNumber) ?? String(number)
  }
  
  func toRounded(from number: Double) -> String {
    return formatter.string(from: number as NSNumber) ?? String(number)
  }
}
