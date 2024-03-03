//
//  TrendViewModel.swift
//  KazCoin
//
//  Created by 원태영 on 3/2/24.
//

import Foundation
import KazUtility

final class TrendViewModel: ViewModel {
  
  enum TrendSection: String, CaseIterable {
    case interest = "My Favorite"
    case topCoin = "Top 15 Coin"
    case topNFT = "Top 7 NFT"
    
    var title: String {
      return self.rawValue
    }
  }
  
  struct Input {
    var viewDidLoadEvent: Observable<Void?> = .init(nil)
    var viewWillAppearEvent: Observable<Void?> = .init(nil)
    var didSelectItemEvent: Observable<IndexPath?> = .init(nil)
  }
  
  struct Output {
    var interestCoins: Observable<[Coin]> = .init([])
    var topCoins: Observable<[Coin]> = .init([])
    var topNFT: Observable<[NFT]> = .init([])
    var loadingIndicatorToggle: Observable<Bool?> = .init(nil)
  }
  
  var input = Input()
  var output = Output()
  
  // MARK: - Property
  weak var coordinator: TrendCoordinator?
  private let interestRepository: any InterestRepository
  private let coinRepository: any CoinRepository
  private let trendRepository: any TrendRepository
  private var currentInterestCoins: [String] = []
  
  private var sections: [TrendSection] {
    return shouldFavoriteSectionHidden
    ? [.topCoin, .topNFT]
    : TrendSection.allCases
  }
  
  private var shouldFavoriteSectionHidden: Bool {
    return output.interestCoins.current.count < Constant.BusinessLiteral.shouldShowFavoriteCoinCount
  }
  
  private var favoriteSectionHiddenBuffer: Int {
    return shouldFavoriteSectionHidden ? 1 : 0
  }
  
  // MARK: - Initializer
  init(
    interestRepository: any InterestRepository,
    coinRepository: any CoinRepository,
    trendRepository: any TrendRepository
  ) {
    self.interestRepository = interestRepository
    self.coinRepository = coinRepository
    self.trendRepository = trendRepository
    
    transform()
  }
  
  // MARK: - Method
  func transform() {
    
    input.viewDidLoadEvent.subscribe { [weak self] _ in
      guard let self else { return }
      let newInterestCoins = interestRepository.fetch()
      
      Task { [weak self] in
        guard let self else { return }
        
        output.loadingIndicatorToggle.onNext(true)
        defer { output.loadingIndicatorToggle.onNext(false) }
        
        do {
          let trend = try await trendRepository.fetch()
          let coins = try await coinRepository.fetch(from: newInterestCoins)
          output.topCoins.onNext(trend.coins)
          output.topNFT.onNext(trend.nfts)
          output.interestCoins.onNext(coins)
          currentInterestCoins = newInterestCoins
        } catch {
          LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
    }
    
    input.viewWillAppearEvent.subscribe { [weak self] _ in
      guard let self else { return }
      let newInterestCoins = interestRepository.fetch()
      let isInterestChagned: Bool = currentInterestCoins != newInterestCoins
      
      guard isInterestChagned else { return }
      
      Task { [weak self] in
        guard let self else { return }
        
        output.loadingIndicatorToggle.onNext(true)
        defer { output.loadingIndicatorToggle.onNext(false) }
        
        do {
          let coins = try await coinRepository.fetch(from: newInterestCoins)
          output.interestCoins.onNext(coins)
          currentInterestCoins = newInterestCoins
        } catch {
          LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
    }
    
    input.didSelectItemEvent.subscribe { [weak self] indexPath in
      guard let self else { return }
      guard let indexPath else { return }
      
      switch sectionAt(indexPath) {
        case .interest, .topCoin:
          guard let coin = itemAt(indexPath) as? Coin else { return }
          
          coordinator?.connectChartFlow(coinID: coin.id)
        case .topNFT:
          break
      }
    }
  }
  
  func numberOfSection() -> Int {
    return sections.count
  }
  
  func sectionAt(_ index: Int) -> TrendSection {
    return sections[index]
  }
  
  func sectionAt(_ indexPath: IndexPath) -> TrendSection {
    return sections[indexPath.section]
  }
  
  func numberOfItems(_ section: Int) -> Int {
    switch sectionAt(section) {
      case .interest:
        return output.interestCoins.current.count
      case .topCoin:
        return output.topCoins.current.count
      case .topNFT:
        return output.topNFT.current.count
    }
  }
  
  func itemAt(_ indexPath: IndexPath) -> any Entity {
    switch sectionAt(indexPath) {
      case .interest:
        return output.interestCoins.current[indexPath.row]
      case .topCoin:
        return output.topCoins.current[indexPath.row]
      case .topNFT:
        return output.topNFT.current[indexPath.row]
    }
  }
}
