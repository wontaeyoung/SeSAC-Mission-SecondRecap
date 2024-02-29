//
//  PaddingLabel.swift
//  CoinDesignSystem
//
//  Created by 원태영 on 2/29/24.
//

import UIKit

public final class PaddingLabel: UILabel {
  
  // MARK: - Property
  public var horizontalInset: CGFloat
  public var verticalInset: CGFloat
  
  // MARK: - Initializer
  public init(horizontalInset: CGFloat, verticalInset: CGFloat) {
    self.horizontalInset = horizontalInset
    self.verticalInset = verticalInset
    
    super.init(frame: .zero)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  public override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    super.drawText(in: rect.inset(by: insets))
  }
  
  public override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + horizontalInset * 2,
      height: size.height + verticalInset * 2
    )
  }
  
  public override var bounds: CGRect {
    didSet {
      preferredMaxLayoutWidth = bounds.width - horizontalInset * 2
    }
  }
}
