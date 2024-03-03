//
//  UserViewModel.swift
//  KazCoin
//
//  Created by 원태영 on 3/4/24.
//

import Foundation
import KazUtility

enum UserConfiguration: String, CaseIterable {
  case interest = "관심 코인"
  case deleteAllInterest = "모든 관심 코인 삭제"
  
  var title: String {
    return self.rawValue
  }
}

final class UserViewModel: ViewModel {
  
  struct Input {
    var viewDidLoadEvent: Observable<Void?> = .init(nil)
    var viewWillAppearEvent: Observable<Void?> = .init(nil)
    var didSelectRowEvent: Observable<IndexPath?> = .init(nil)
  }
  
  struct Output {
    var interestCount: Observable<Int> = .init(0)
    var interestDeleted: Observable<String?> = .init(nil)
  }
  
  var input = Input()
  var output = Output()
  
  // MARK: - Property
  weak var coordinator: UserCoordinator?
  private let repository: any InterestRepository
  
  // MARK: - Initializer
  init(repository: any InterestRepository) {
    self.repository = repository
    
    transform()
  }
  
  // MARK: - Method
  func transform() {
    
    input.viewDidLoadEvent.subscribe { [weak self] _ in
      guard let self else { return }
      output.interestCount.onNext(repository.fetch().count)
    }
    
    input.viewWillAppearEvent.subscribe { [weak self] _ in
      guard let self else { return }
      output.interestCount.onNext(repository.fetch().count)
    }
    
    input.didSelectRowEvent.subscribe { [weak self] indexPath in
      guard let self else { return }
      guard let indexPath else { return }
      
      switch configAt(indexPath) {
        case .interest:
          break
        case .deleteAllInterest:
          coordinator?.showAlert(
            title: Constant.LabelTitle.deleteInterestTitle,
            message: Constant.LabelTitle.deleteInterestMessage,
            okStyle: .destructive,
            isCancelable: true
          ) { [weak self] in
            guard let self else { return }
            
            do {
              try repository.deleteAll()
              output.interestDeleted.onNext(Constant.LabelTitle.deleteInterestMessage)
            } catch {
              LogManager.shared.log(with: error.localizedDescription, to: .network, level: .debug)
              LogManager.shared.log(with: error, to: .network)
              coordinator?.showErrorAlert(error: error)
            }
          }
      }
    }
  }
  
  func numberOfRows() -> Int {
    return UserConfiguration.allCases.count
  }
  
  func configAt(_ indexPath: IndexPath) -> UserConfiguration {
    return UserConfiguration.allCases[indexPath.row]
  }
  
  func cellTitleAt(_ indexPath: IndexPath) -> String {
    let config = configAt(indexPath)
    
    switch config {
      case .interest:
        return "\(config.title) [\(interestCount())]"
      case .deleteAllInterest:
        return config.title
    }
  }
  
  func interestCount() -> String {
    return "\(output.interestCount.current) / \(Constant.BusinessLiteral.maxInterestCount)"
  }
}

