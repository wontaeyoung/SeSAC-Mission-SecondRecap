//
//  ChartViewController.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit
import Kingfisher
import Toast

final class ChartViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private let iconImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  private let nameLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 29, weight: .heavy)
    $0.textColor = KazCoinAsset.Color.titleName
  }
  
  private let priceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 29, weight: .heavy)
    $0.textColor = KazCoinAsset.Color.titleName
  }
  
  private let priceChangeRateLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
  }
  
  private let todayLabel = UILabel().configured {
    $0.text = KazCoinAsset.LabelTitle.today
    $0.font = .systemFont(ofSize: 15, weight: .semibold)
    $0.textColor = KazCoinAsset.Color.symbolName
  }
  
  private let highTitleLabel = UILabel().configured {
    $0.text = KazCoinAsset.LabelTitle.highPrice
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = KazCoinAsset.Color.plusLabel
  }
  
  private let highPriceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let lowTitleLabel = UILabel().configured {
    $0.text = KazCoinAsset.LabelTitle.lowPrice
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = KazCoinAsset.Color.minusLabel
  }
  
  private let lowPriceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let highestTitleLabel = UILabel().configured {
    $0.text = KazCoinAsset.LabelTitle.highestPrice
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = KazCoinAsset.Color.plusLabel
  }
  
  private let highestPriceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let lowestTitleLabel = UILabel().configured {
    $0.text = KazCoinAsset.LabelTitle.lowestPrice
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textColor = KazCoinAsset.Color.minusLabel
  }
  
  private let lowestPriceLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 17)
    $0.textColor = KazCoinAsset.Color.primaryText
  }
  
  private let updateAtLabel = UILabel().configured {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.textColor = KazCoinAsset.Color.symbolName
    $0.textAlignment = .right
  }
  
  // MARK: - Property
  let viewModel: ChartViewModel
  
  // MARK: - Initializer
  init(viewModel: ChartViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      iconImageView,
      nameLabel,
      priceLabel,
      priceChangeRateLabel,
      todayLabel,
      highTitleLabel,
      highPriceLabel,
      lowTitleLabel,
      lowPriceLabel,
      highestTitleLabel,
      highestPriceLabel,
      lowestTitleLabel,
      lowestPriceLabel,
      updateAtLabel
    )
  }
  
  override func setAttribute() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: nil, style: .done, target: self,
      action: #selector(interestBarButtonTapped)
    )
  }
  
  override func setConstraint() {
    iconImageView.snp.makeConstraints { make in
      make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.size.equalTo(44)
    }
    
    nameLabel.snp.makeConstraints { make in
      make.centerY.equalTo(iconImageView)
      make.leading.equalTo(iconImageView.snp.trailing).offset(8)
      make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.top.equalTo(iconImageView.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(view).inset(16)
    }
    
    priceChangeRateLabel.snp.makeConstraints { make in
      make.top.equalTo(priceLabel.snp.bottom).offset(8)
      make.leading.equalTo(view).inset(16)
    }
    
    todayLabel.snp.makeConstraints { make in
      make.top.equalTo(priceLabel.snp.bottom).offset(8)
      make.leading.equalTo(priceChangeRateLabel.snp.trailing).offset(8)
      make.trailing.equalTo(view).inset(16)
    }
    
    highTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(priceChangeRateLabel.snp.bottom).offset(16)
      make.leading.equalTo(view).inset(16)
      make.width.equalTo(UIScreen.main.bounds.width / 2 - 48)
    }
    
    highPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(highTitleLabel.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(highestTitleLabel)
    }
    
    lowTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(highTitleLabel)
      make.leading.equalTo(highestTitleLabel.snp.trailing).offset(16)
      make.trailing.equalTo(view).inset(16)
    }
    
    lowPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(highPriceLabel)
      make.horizontalEdges.equalTo(lowTitleLabel)
    }
    
    highestTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(highPriceLabel.snp.bottom).offset(16)
      make.horizontalEdges.equalTo(highTitleLabel)
    }
    
    highestPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(highestTitleLabel.snp.bottom).offset(8)
      make.horizontalEdges.equalTo(highTitleLabel)
    }
    
    lowestTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(highestTitleLabel)
      make.horizontalEdges.equalTo(lowTitleLabel)
    }
    
    lowestPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(highestPriceLabel)
      make.horizontalEdges.equalTo(lowTitleLabel)
    }
    
    updateAtLabel.snp.makeConstraints { make in
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
  }
  
  override func bind() {
    viewModel.output.coin.subscribe { [weak self] coin in
      guard let self else { return }
      guard let coin else { return }
      
      updateUI(with: coin)
    }
    
    viewModel.output.interestToggle.subscribe { [weak self] interest in
      guard let self else { return }
      guard let interest else { return }
      
      updateInterestButton(interest)
    }
    
    viewModel.output.loadingIndicatorToggle.subscribe { [weak self] isOn in
      guard let self else { return }
      guard let isOn else { return }
      
      if isOn {
        view.makeToastActivity(.center)
      } else {
        view.hideToastActivity()
      }
    }
    
    viewModel.input.viewDidLoadEvent.onNext(())
  }
  
  // MARK: - Method
  private func updateInterestButton(_ interest: Bool) {
    navigationItem.rightBarButtonItem?.image = interest ? .btnStarFill : .btnStar
  }
  
  private func updateUI(with coin: Coin) {
    iconImageView.kf.setImage(with: coin.iconURL)
    nameLabel.text = coin.name
    priceLabel.text = coin.price.toCurrency
    priceChangeRateLabel.text = coin.priceChangeRate.toRoundedRate
    configPriceChangeRateLabel(with: coin.priceChangeRate)
    highPriceLabel.text = coin.dailyHigh.toCurrency
    lowPriceLabel.text = coin.dailyLow.toCurrency
    highestPriceLabel.text = coin.highest.toCurrency
    lowestPriceLabel.text = coin.lowest.toCurrency
    updateAtLabel.text = DateManager.shared.toString(with: coin.updateAt, formatString: "MM/dd HH:mm:dd 업데이트")
  }
  
  private func configPriceChangeRateLabel(with rate: Double) {
    priceChangeRateLabel.textColor = rate.isLess(than: .zero)
    ? KazCoinAsset.Color.minusLabel
    : KazCoinAsset.Color.plusLabel
  }
  
  // MARK: - Selector
  @objc private func interestBarButtonTapped() {
    
  }
}
