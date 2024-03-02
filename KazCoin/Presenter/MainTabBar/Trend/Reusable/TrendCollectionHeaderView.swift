//
//  TrendCollectionHeaderView.swift
//  KazCoin
//
//  Created by 원태영 on 3/2/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit

final class TrendCollectionHeaderView: UICollectionReusableView {
  
  static var identifier: String {
    return self.description()
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().configured {
    $0.textColor = KazCoinAsset.Color.titleName
    $0.font = .systemFont(ofSize: 29, weight: .heavy)
  }
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setHierarchy()
    setConstraint()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  private func setHierarchy() {
    addSubview(titleLabel)
  }
  
  private func setConstraint() {
    titleLabel.snp.makeConstraints { make in
      make.edges.equalTo(self)
    }
  }
  
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
}
