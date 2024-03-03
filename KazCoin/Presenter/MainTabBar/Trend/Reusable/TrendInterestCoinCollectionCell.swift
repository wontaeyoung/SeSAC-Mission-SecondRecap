//
//  TrendInterestCoinCollectionCell.swift
//  KazCoin
//
//  Created by 원태영 on 3/2/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit
import Kingfisher

final class TrendInterestCoinCollectionCell: BaseCollectionViewCell {
  
  // MARK: - UI
  private let iconImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  private let nameLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let symbolLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.textColor = KazCoinAsset.Color.symbolName
  }
  
  private let priceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = KazCoinAsset.Color.primaryText
    $0.textAlignment = .right
  }
  
  private let priceChangeRateLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(iconImageView, nameLabel, symbolLabel, priceLabel, priceChangeRateLabel)
  }
  
  override func setAttribute() {
    contentView.configure {
      $0.backgroundColor = KazCoinAsset.Color.cardBackground
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 20
    }
  }
  
  override func setConstraint() {
    iconImageView.snp.makeConstraints { make in
      make.top.leading.equalTo(contentView).inset(16)
      make.size.equalTo(44)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.top.trailing.equalTo(contentView).inset(16)
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
    }
    
    symbolLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(4)
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
      make.trailing.equalTo(contentView).inset(16)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(iconImageView.snp.bottom).offset(8)
      make.leading.equalTo(contentView).inset(16)
      make.bottom.equalTo(priceChangeRateLabel.snp.top).offset(-8)
    }
    
    priceChangeRateLabel.snp.makeConstraints { make in
      make.bottom.leading.equalTo(contentView).inset(16)
    }
  }
  
  // MARK: - Method
  func updateUI(with item: Coin) {
    iconImageView.kf.setImage(with: item.iconURL)
    nameLabel.text = item.name
    symbolLabel.text = item.symbol.uppercased()
    priceLabel.text = item.price.toCurrency
    priceChangeRateLabel.text = item.priceChangeRate.toRoundedRate
    configPriceChangeRateLabel(with: item.priceChangeRate)
  }
  
  private func configPriceChangeRateLabel(with rate: Double) {
    priceChangeRateLabel.configure {
      $0.textColor = rate.isLess(than: .zero)
      ? KazCoinAsset.Color.minusLabel
      : KazCoinAsset.Color.plusLabel
    }
  }
}
