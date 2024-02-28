//
//  String+.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit

extension String {
  
  func colorAttributed(in rangeText: String, color: UIColor) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: self)
    
    attributedString.addAttribute(
      .foregroundColor,
      value: color,
      range: (self as NSString).range(of: rangeText, options: .caseInsensitive)
    )
    
    return attributedString
  }
}
