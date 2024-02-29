//
//  PortfolioCollectionViewCell.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit
import Kingfisher

final class PortfolioCollectionViewCell: BaseCollectionViewCell {
  
  // MARK: - UI
  private let iconImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  private let nameLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let symbolLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = KazCoinAsset.Color.symbolName
  }
  
  private let priceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.textColor = KazCoinAsset.Color.primaryText
    $0.textAlignment = .right
  }
  
  private let priceChangeRateLabel = PaddingLabel(horizontalInset: 8, verticalInset: 4).configured {
    $0.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(iconImageView, nameLabel, symbolLabel, priceLabel, priceChangeRateLabel)
  }
  
  override func setAttribute() {
    contentView.configure {
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 20
      $0.layer.borderWidth = 1
      $0.layer.borderColor = KazCoinAsset.Color.cardBackground.cgColor
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
      make.trailing.equalTo(contentView).inset(16)
      make.bottom.equalTo(priceChangeRateLabel.snp.top).offset(-4)
    }
    
    priceChangeRateLabel.snp.makeConstraints { make in
      make.bottom.trailing.equalTo(contentView).inset(16)
    }
  }
  
  // MARK: - Method
  func updateUI(with item: Coin) {
    iconImageView.kf.setImage(with: item.iconURL)
    nameLabel.text = item.name
    symbolLabel.text = item.symbol
    priceLabel.text = NumberFormatManager.shared.toCurrency(from: item.price)
    configPriceChangeRateLabel(with: item.priceChangeRate)
  }
  
  private func configPriceChangeRateLabel(with rate: Double) {
    priceChangeRateLabel.configure {
      $0.textColor = rate.isLess(than: .zero)
      ? KazCoinAsset.Color.minusLabel
      : KazCoinAsset.Color.plusLabel
      
      $0.backgroundColor = rate.isLess(than: .zero)
      ? KazCoinAsset.Color.minusBackground
      : KazCoinAsset.Color.plusBackground
    }
  }
}
