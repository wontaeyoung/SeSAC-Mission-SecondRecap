//
//  SearchViewModel.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import Foundation
import KazUtility

final class SearchViewModel: ViewModel {
  
  // MARK: - I/O
  struct Input {
    var viewDidLoadEvent: Observable<Void?> = .init(nil)
    var viewWillAppearEvent: Observable<Void?> = .init(nil)
    var searchButtonTapEvent: Observable<String?> = .init(nil)
    var interestButtonTapEvent: Observable<IndexPath?> = .init(nil)
    var didSelectRowEvent: Observable<IndexPath?> = .init(nil)
  }
  
  struct Output {
    var coins: Observable<[Coin]> = .init([])
    var interestCoins: Observable<[String]> = .init([])
    var interestToast: Observable<String> = .init("")
    var loadingIndicatorToggle: Observable<Bool?> = .init(nil)
  }
  
  var input = Input()
  var output = Output()
  
  // MARK: - Property
  weak var coordinator: SearchCoordinator?
  private let coinRepository: any CoinRepository
  private let interestRepository: any InterestRepository
  private(set) var currentSearchText: String = ""
  
  // MARK: - Initializer
  init(coinRepository: any CoinRepository, interestRepository: any InterestRepository) {
    self.coinRepository = coinRepository
    self.interestRepository = interestRepository
    
    transform()
  }
  
  // MARK: - Method
  func transform() {
    
    input.viewDidLoadEvent.subscribe { [weak self] _ in
      guard let self else { return }
      
      let interestCoins = interestRepository.fetch()
      output.interestCoins.onNext(interestCoins)
    }
    
    input.viewWillAppearEvent.subscribe { [weak self] _ in
      guard let self else { return }
      output.interestCoins.onNext(interestRepository.fetch())
    }
    
    input.searchButtonTapEvent.subscribe { [weak self] text in
      guard let self else { return }
      guard let text else { return }
      
      Task { [weak self] in
        guard let self else { return }
        
        output.loadingIndicatorToggle.onNext(true)
        defer { output.loadingIndicatorToggle.onNext(false) }
        
        do {
          let coins = try await coinRepository.fetch(by: text)
          output.coins.onNext(coins)
          currentSearchText = text
        } catch {
          LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
    }
    
    input.interestButtonTapEvent.subscribe { [weak self] indexPath in
      guard let self else { return }
      guard let indexPath else { return }
      let selectedCoin: Coin = output.coins.current[indexPath.row]
      
      do {
        guard let index = output.interestCoins.current.firstIndex(of: selectedCoin.id) else {
          try interestRepository.create(with: selectedCoin)
          output.interestCoins.value.append(selectedCoin.id)
          output.interestToast.onNext(Constant.LabelTitle.interestToggleMessage(selectedCoin.name, isOn: true))
          return
        }
        
        try interestRepository.delete(with: selectedCoin)
        output.interestCoins.value.remove(at: index)
        output.interestToast.onNext(Constant.LabelTitle.interestToggleMessage(selectedCoin.name, isOn: false))
        
      } catch {
        LogManager.shared.log(with: error, to: .local)
        coordinator?.showErrorAlert(error: error)
      }
    }
    
    input.didSelectRowEvent.subscribe { [weak self] indexPath in
      guard let self else { return }
      guard let indexPath else { return }
      
      let selectedCoinID = output.coins.current[indexPath.row].id
      coordinator?.connectChartFlow(coinID: selectedCoinID)
    }
  }
  
  func numberOfRows() -> Int {
    return output.coins.current.count
  }
  
  func itemAt(_ indexPath: IndexPath) -> Coin {
    return output.coins.current[indexPath.row]
  }
  
  func interestedAt(_ indexPath: IndexPath) -> Bool {
    return output.interestCoins.current.contains(itemAt(indexPath).id)
  }
}
