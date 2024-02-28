//
//  SearchTableViewCell.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit
import Kingfisher

final class SearchTableViewCell: BaseTableViewCell {
  
  // MARK: - UI
  private let iconImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  private let nameLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17, weight: .semibold)
    $0.textColor = KazCoinAsset.Color.searchCoinName
  }
  
  private let symbolLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.textColor = KazCoinAsset.Color.symbolName
  }
  
  private let interestButton = UIButton().configured {
    $0.configuration = .plain().configured {
      $0.image = .btnStar
    }
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(iconImageView, nameLabel, symbolLabel, interestButton)
  }
  
  override func setConstraint() {
    iconImageView.snp.makeConstraints { make in
      make.leading.equalTo(contentView).inset(16)
      make.centerY.equalTo(contentView)
      make.size.equalTo(44)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(contentView).inset(8)
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
    }
    
    symbolLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(4)
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
      make.bottom.equalTo(contentView).inset(8)
    }
    
    interestButton.snp.makeConstraints { make in
      make.leading.equalTo(nameLabel.snp.trailing).offset(8)
      make.trailing.equalTo(contentView).inset(16)
      make.centerY.equalTo(contentView)
    }
  }
  
  // MARK: - Method
  func updateUI(with item: Coin, interested: Bool) {
    iconImageView.kf.setImage(with: item.iconURL)
    nameLabel.text = item.name
    symbolLabel.text = item.symbol
    interestButton.configuration?.image = interested ? .btnStarFill : .btnStar
  }
  
  func updateTapEvent(_ selector: Selector, target: Any) {
    interestButton.addTarget(target, action: selector, for: .touchUpInside)
  }
}
