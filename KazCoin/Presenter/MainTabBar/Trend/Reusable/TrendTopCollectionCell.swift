//
//  TrendTopCollectionCell.swift
//  KazCoin
//
//  Created by 원태영 on 3/3/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit
import Kingfisher

final class TrendTopCollectionCell: BaseCollectionViewCell {
  
  // MARK: - UI
  private let rankLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 21, weight: .semibold)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let iconImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  private let nameLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.textColor = KazCoinAsset.Color.primaryText
    $0.numberOfLines = 1
    $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
  
  private let symbolLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let priceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.textColor = KazCoinAsset.Color.primaryText
    $0.textAlignment = .right
  }
  
  private let priceChangeRateLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textAlignment = .right
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(rankLabel, iconImageView, nameLabel, symbolLabel, priceLabel, priceChangeRateLabel)
  }
  
  override func setConstraint() {
    rankLabel.snp.makeConstraints { make in
      make.leading.equalTo(contentView).inset(16)
      make.centerY.equalTo(iconImageView)
    }
    
    iconImageView.snp.makeConstraints { make in
      make.top.equalTo(contentView).inset(8)
      make.leading.equalTo(rankLabel.snp.trailing).offset(8)
      make.size.equalTo(35)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(contentView).inset(8)
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
    }
    
    symbolLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom)
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.bottom.equalTo(nameLabel)
      make.leading.greaterThanOrEqualTo(nameLabel.snp.trailing).offset(8)
      make.trailing.equalTo(contentView).inset(16)
    }
    
    priceChangeRateLabel.snp.makeConstraints { make in
      make.top.equalTo(symbolLabel)
      make.leading.equalTo(symbolLabel.snp.trailing).offset(8)
      make.trailing.equalTo(contentView).inset(16)
    }
  }
  
  // MARK: - Method
  func updateUI(section: TrendViewModel.TrendSection, with item: any Entity, row: Int) {
      
    switch section {
      case .interest:
        break
        
      case .topCoin:
        guard let coin = item as? Coin else { return }
        rankLabel.text = "\(row + 1)"
        iconImageView.kf.setImage(with: coin.iconURL)
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol.uppercased()
        priceLabel.text = coin.priceUSD.asMarkdownRedneredAttributeString?.string.dollorToRounded
        priceChangeRateLabel.text = coin.priceChangeRate.toRoundedRate
        configPriceChangeRateLabel(with: coin.priceChangeRate)
      
      case .topNFT:
        guard let nft = item as? NFT else { return }
        rankLabel.text = "\(row + 1)"
        iconImageView.kf.setImage(with: nft.iconURL)
        nameLabel.text = nft.name
        symbolLabel.text = nft.symbol.uppercased()
        priceLabel.text = "\(nft.floorPrice.toRounded) \(nft.currencySymbol.uppercased())"
        priceChangeRateLabel.text = nft.floorPriceChangeRate.toRoundedRate
        configPriceChangeRateLabel(with: nft.floorPriceChangeRate)
    }
  }
  
  private func configPriceChangeRateLabel(with rate: Double) {
    priceChangeRateLabel.configure {
      $0.textColor = rate.isLess(than: .zero)
      ? KazCoinAsset.Color.minusLabel
      : KazCoinAsset.Color.plusLabel
    }
  }
}
