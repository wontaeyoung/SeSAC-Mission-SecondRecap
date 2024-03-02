//
//  TrendViewController.swift
//  KazCoin
//
//  Created by 원태영 on 3/2/24.
//

import UIKit
import KazUtility
import SnapKit

final class TrendViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var collectionViewLayout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
    
    switch self.viewModel.sectionAt(section) {
      case .interest:
        return .makeCardSection(
          cardWidth: 0.6,
          cardHeight: 0.2,
          cardSpacing: 16,
          scrollStyle: .groupPaging,
          sectionInset: .init(top: 16, leading: 16, bottom: 32, trailing: 16),
          header: true
        )
        
      case .topCoin, .topNFT:
        return .makeListCardSection(
          cardListCount: 3,
          listSpacing: 8,
          cardWidth: 0.8,
          cardHeight: 0.5,
          cardSpacing: 16,
          scrollStyle: .groupPaging,
          sectionInset: .init(top: 8, leading: 16, bottom: 32, trailing: 16),
          header: true
        )
    }
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).configured {
    $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    $0.register(
      TrendCollectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: TrendCollectionHeaderView.identifier
    )
    $0.delegate = self
    $0.dataSource = self
  }
  
  // MARK: - Property
  let viewModel: TrendViewModel
  
  // MARK: - Initializer
  init(viewModel: TrendViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(collectionView)
  }
  
  override func setAttribute() {
    
  }
  
  override func setConstraint() {
    collectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    
  }
  
  // MARK: - Method
  
  // MARK: - Selector
}

extension TrendViewController: CollectionControllable {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSection()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch viewModel.sectionAt(section) {
      case .interest:
        return 10
      case .topCoin:
        return 30
      case .topNFT:
        return 30
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
    switch viewModel.sectionAt(indexPath.section) {
      case .interest:
        cell.backgroundColor = .systemRed
      case .topCoin:
        cell.backgroundColor = .systemYellow
      case .topNFT:
        cell.backgroundColor = .systemBlue
    }
    
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    
    guard kind == UICollectionView.elementKindSectionHeader else {
      return .init()
    }
    
    let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: TrendCollectionHeaderView.identifier,
      for: indexPath
    ) as! TrendCollectionHeaderView
    
    return headerView.configured {
      $0.setTitle(viewModel.sectionAt(indexPath.section).title)
    }
  }
}

@available(iOS 17, *)
#Preview {
  let repo = LiveTrendRepository()
  let vm = TrendViewModel(repository: repo)
  return TrendViewController(viewModel: vm)
}
