//
//  ChartViewModel.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

import Foundation
import KazUtility

final class ChartViewModel: ViewModel {
  
  // MARK: - I/O
  struct Input {
    var viewDidLoadEvent: Observable<Void?> = .init(nil)
    var interestButtonTapEvent: Observable<Void?> = .init(nil)
    var viewWillAppearEvent: Observable<Void?> = .init(nil)
    var viewDeinitEvent: Observable<Void?> = .init(nil)
  }
  
  struct Output {
    var coin: Observable<Coin?> = .init(nil)
    var interestToggle: Observable<Bool?> = .init(nil)
    var interestToast: Observable<String?> = .init(nil)
    var loadingIndicatorToggle: Observable<Bool?> = .init(nil)
  }
  
  var input = Input()
  var output = Output()
  
  // MARK: - Property
  weak var coordinator: ChartCoordinator?
  private let coinRepository: any CoinRepository
  private let interestRepository: any InterestRepository
  private let coinID: String
  
  // MARK: - Initializer
  init(coinRepository: any CoinRepository, interestRepository: any InterestRepository, coinID: String) {
    self.coinRepository = coinRepository
    self.interestRepository = interestRepository
    self.coinID = coinID
    
    transform()
  }
  
  deinit {
    coordinator?.end()
  }
  
  // MARK: - Method
  func transform() {
    
    input.viewDidLoadEvent.subscribe { [weak self] _ in
      guard let self else { return }
      let interest: Bool = interestRepository.fetch().contains(coinID)
      
      Task { [weak self] in
        guard let self else { return }
        
        output.loadingIndicatorToggle.onNext(true)
        defer { output.loadingIndicatorToggle.onNext(false) }
        
        do {
          guard let coin = try await coinRepository.fetch(from: [coinID]).first else {
            showNoResultAlert()
            return
          }
          
          output.interestToggle.onNext(interest)
          output.coin.onNext(coin)
        } catch {
          LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error) { [weak self] in
            guard let self else { return }
            coordinator?.pop()
          }
        }
      }
    }
    
    input.interestButtonTapEvent.subscribe { [weak self] _ in
      guard let self else { return }
      guard let coin = output.coin.current else { return }
      
      let interest: Bool = interestRepository.fetch().contains(coinID)
      let toastMessage: String = Constant.LabelTitle.interestToggleMessage(coin.name, isOn: !interest)
      
      do {
        if interest {
          try interestRepository.delete(with: coin)
          output.interestToggle.onNext(false)
          output.interestToast.onNext(toastMessage)
        } else {
          try interestRepository.create(with: coin)
          output.interestToggle.onNext(true)
          output.interestToast.onNext(toastMessage)
        }
      } catch {
        LogManager.shared.log(with: error, to: .local)
        coordinator?.showErrorAlert(error: error)
      }
    }
    
    input.viewWillAppearEvent.subscribe { [weak self] _ in
      guard let self else { return }
      let newInterestCoins = interestRepository.fetch()
      output.interestToggle.onNext(newInterestCoins.contains(coinID))
    }
    
    input.viewDeinitEvent.subscribe { _ in
      self.coordinator?.end()
    }
  }
  
  private func showNoResultAlert() {
    coordinator?.showAlert(title: CoinError.noResultWithID(id: coinID).alertDescription, message: "") { [weak self] in
      guard let self else { return }
      coordinator?.pop()
    }
  }
}
