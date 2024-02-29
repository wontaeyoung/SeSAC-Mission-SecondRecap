//
//  PortfolioViewModel.swift
//  KazCoin
//
//  Created by 원태영 on 2/29/24.
//

import Foundation
import KazUtility
import KazRealm

final class PortfolioViewModel: ViewModel {
  
  // MARK: - I/O
  struct Input {
    var viewDidLoadEvent: Observable<Void?> = .init(nil)
    var viewWillAppearEvent: Observable<Void?> = .init(nil)
  }
  
  struct Output {
    var coins: Observable<[Coin]> = .init([])
  }
  
  var input = Input()
  var output = Output()
  
  // MARK: - Property
  weak var coordinator: PortfolioCoordinator?
  private let coinRepository: any CoinRepository
  private let interestRepository: any InterestRepository
  private var currentInterestCoins: [String] = []
  
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
      currentInterestCoins = interestRepository.fetch()
      
      Task { [weak self] in
        guard let self else { return }
        
        do {
          let coins = try await coinRepository.fetch(from: currentInterestCoins)
          
          output.coins.onNext(coins)
        } catch {
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
    }
    
    input.viewWillAppearEvent.subscribe { [weak self] _ in
      guard let self else { return }
      
      let newInterestCoins = interestRepository.fetch()
      guard isInterestChanged(current: currentInterestCoins, new: newInterestCoins) else { return }
      
      Task { [weak self] in
        guard let self else { return }
        
        do {
          let coins = try await coinRepository.fetch(from: newInterestCoins)
          currentInterestCoins = newInterestCoins
          
          output.coins.onNext(coins)
        } catch {
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
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
}
