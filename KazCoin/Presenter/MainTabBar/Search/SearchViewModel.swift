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
    var searchButtonTapEvent: Observable<String?> = .init(nil)
  }
  
  struct Output {
    var coins: Observable<[Coin]> = Observable([])
  }
  
  var input = Input()
  var output = Output()
  
  // MARK: - Property
  weak var coordinator: SearchCoordinator?
  private let repository: any CoinRepository
  
  // MARK: - Initializer
  init(repository: any CoinRepository) {
    self.repository = repository
    
    transform()
  }
  
  // MARK: - Method
  func transform() {
    input.searchButtonTapEvent.subscribe { text in 
      guard let text else { return }
      
      Task { [weak self] in
        guard let self else { return }
        
        do {
          let coins = try await repository.searchFetch(by: text)
          output.coins.onNext(coins)
        } catch {
          guard let error = error as? AppError else { return }
          LogManager.shared.log(with: error, to: .network)
          coordinator?.showErrorAlert(error: error)
        }
      }
    }
  }
  
  func numberOfRows() -> Int {
    return output.coins.current.count
  }
  
  func itemAt(_ indexPath: IndexPath) -> Coin {
    return output.coins.current[indexPath.row]
  }
}
