//
//  PortfolioViewModel.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

import Foundation
import KazUtility

final class PortfolioViewModel: ViewModel {
  
  // MARK: - I/O
  struct Input {
    var viewDidLoadEvent: Observable<Void?> = .init(nil)
    var viewWillAppearEvent: Observable<Void?> = .init(nil)
    var viewWillDisAppearEvent: Observable<Void?> = .init(nil)
    var didSelectItemEvent: Observable<IndexPath?> = .init(nil)
    var didItemMovedEvent: Observable<(from: IndexPath, to: IndexPath)?> = .init(nil)
    var profileButtonTapEvent: Observable<Void?> = .init(nil)
  }
  
  struct Output {
    var coins: Observable<[Coin]> = .init([])
    var loadingIndicatorToggle: Observable<Bool?> = .init(nil)
    var interestMoved: Observable<String?> = .init(nil)
    var timerActionProceeded: Observable<Void?> = .init(nil)
  }
  
  var input = Input()
  var output = Output()
  
  // MARK: - Property
  weak var coordinator: PortfolioCoordinator?
  private let coinRepository: any CoinRepository
  private let interestRepository: any InterestRepository
  private var currentInterestCoins: [String] = []
  private var timer: Timer?
  
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
      let newInterestCoins = interestRepository.fetch()
      guard !newInterestCoins.isEmpty else { return }
      
      Task { [weak self] in
        guard let self else { return }
        
        output.loadingIndicatorToggle.onNext(true)
        defer { output.loadingIndicatorToggle.onNext(false) }
        
        do {
          let coins = try await coinRepository.fetch(from: newInterestCoins)
          output.coins.onNext(coins)
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
      startTimer()
      
      let newInterestCoins = interestRepository.fetch()
      guard isInterestChanged(current: currentInterestCoins, new: newInterestCoins) else { return }
      
      guard !newInterestCoins.isEmpty else {
        output.coins.onNext([])
        currentInterestCoins = []
        return
      }
      
      Task { [weak self] in
        guard let self else { return }
        
        output.loadingIndicatorToggle.onNext(true)
        defer { output.loadingIndicatorToggle.onNext(false) }
        
        do {
          let coins = try await coinRepository.fetch(from: newInterestCoins)
          output.coins.onNext(coins)
          currentInterestCoins = newInterestCoins
        } catch {
          LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
    }
    
    input.viewWillDisAppearEvent.subscribe { [weak self] _ in
      guard let self else { return }
      timer?.invalidate()
    }
    
    input.didSelectItemEvent.subscribe { [weak self] indexPath in
      guard let self else { return }
      guard let indexPath else { return }
      
      let selectedCoinID = output.coins.current[indexPath.row].id
      coordinator?.connectChartFlow(coinID: selectedCoinID)
    }
    
    input.didItemMovedEvent.subscribe { [weak self] move in
      guard let self else { return }
      guard let move else { return }
      
      let item = output.coins.value.remove(at: move.from.row)
      output.coins.value.insert(item, at: move.to.row)
      
      do {
        let toastMessage = "\(item.name) \(Constant.LabelTitle.interestMovedMessage) \(move.from.row) → \(move.to.row)"
        try interestRepository.remake(from: output.coins.current)
        output.interestMoved.onNext(toastMessage)
      } catch {
        LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
        LogManager.shared.log(with: error, to: .network)
        coordinator?.showErrorAlert(error: error)
      }
    }
    
    input.profileButtonTapEvent.subscribe { [weak self] _ in
      guard let self else { return }
      
      coordinator?.moveTab(to: .user)
    }
  }
  
  func numberOfItems() -> Int {
    return output.coins.current.count
  }
  
  func itemAt(_ indexPath: IndexPath) -> Coin {
    return output.coins.current[indexPath.row]
  }
  
  private func isInterestChanged(current: [String], new: [String]) -> Bool {
    return current != new
  }
  
  private func startTimer() {
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
      Task { [weak self] in
        guard let self else { return }
        
        do {
          let coins = try await coinRepository.fetch(from: currentInterestCoins)
          output.coins.onNext(coins)
          output.timerActionProceeded.onNext(())
        } catch {
          LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
    }
  }
}
