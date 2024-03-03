//
//  TrendViewController.swift
//  KazCoin
//
//  Created by 원태영 on 3/2/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit
import Toast

final class TrendViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var collectionViewLayout = UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
    
    switch self.viewModel.sectionAt(section) {
      case .interest:
        return .makeCardSection(
          cardWidth: 0.6,
          cardHeight: .fractionalWidth(0.6 * 0.75),
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
          cardHeight: .fractionalWidth(0.53),
          cardSpacing: 16,
          scrollStyle: .groupPaging,
          sectionInset: .init(top: 8, leading: 16, bottom: 32, trailing: 16),
          header: true
        )
    }
  }
  
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).configured {
    
    $0.register(
      TrendCollectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: TrendCollectionHeaderView.identifier
    )
    $0.register(
      TrendInterestCoinCollectionCell.self,
      forCellWithReuseIdentifier: TrendInterestCoinCollectionCell.identifier
    )
    $0.register(
      TrendTopCollectionCell.self,
      forCellWithReuseIdentifier: TrendTopCollectionCell.identifier
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
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.input.viewWillAppearEvent.onNext(())
  }
  
  override func setHierarchy() {
    view.addSubviews(collectionView)
  }
  
  override func setAttribute() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: .tabUser, style: .plain, target: self, action: #selector(profileBarButtonTapped))
  }
  
  override func setConstraint() {
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.output.interestCoins.subscribe { [weak self] coins in
      guard let self else { return }
      collectionView.reloadData()
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
  
  // MARK: - Selector
  @objc private func profileBarButtonTapped() {
    viewModel.input.profileButtonTapEvent.onNext(())
  }
}

extension TrendViewController: CollectionControllable {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return viewModel.numberOfSection()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch viewModel.sectionAt(indexPath.section) {
      case .interest:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: TrendInterestCoinCollectionCell.identifier,
          for: indexPath
        ) as! TrendInterestCoinCollectionCell
        guard let coin = viewModel.itemAt(indexPath) as? Coin else { return cell }
        
        cell.updateUI(with: coin)
        return cell
        
      case .topCoin, .topNFT:
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: TrendTopCollectionCell.identifier,
          for: indexPath
        ) as! TrendTopCollectionCell
        let section = viewModel.sectionAt(indexPath)
        let item = viewModel.itemAt(indexPath)
        let row = indexPath.row
        
        cell.updateUI(section: section, with: item, row: row)
        return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.input.didSelectItemEvent.onNext(indexPath)
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
