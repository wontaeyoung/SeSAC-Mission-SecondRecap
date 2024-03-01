//
//  PortfolioViewController.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

import UIKit
import KazUtility
import SnapKit
import Toast

final class PortfolioViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setLayout()).configured {
    $0.register(PortfolioCollectionViewCell.self, forCellWithReuseIdentifier: PortfolioCollectionViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
  }
  
  private let emptyInterestLabel = UILabel().configured {
    $0.text = "즐겨찾기한 코인이 없어요!"
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textAlignment = .center
  }
  
  // MARK: - Property
  let viewModel: PortfolioViewModel
  
  // MARK: - Initializer
  init(viewModel: PortfolioViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.input.viewWillAppearEvent.onNext(())
  }
  
  override func setHierarchy() {
    view.addSubviews(collectionView, emptyInterestLabel)
  }
  
  override func setAttribute() {
    
  }
  
  override func setConstraint() {
    collectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    emptyInterestLabel.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.input.viewDidLoadEvent.onNext(())
    
    viewModel.output.coins.subscribe { [weak self] coins in
      guard let self else { return }
      collectionView.reloadData()
      emptyInterestLabel.isHidden = !coins.isEmpty
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
  }
}

extension PortfolioViewController: CollectionControllable {
  func setLayout() -> UICollectionViewFlowLayout {
    let cellCount: Int = 2
    let cellSpacing: CGFloat = 16
    let cellWidth: CGFloat = (UIScreen.main.bounds.width - (cellSpacing * CGFloat(2 + cellCount - 1))) / CGFloat(cellCount)
    
    return UICollectionViewFlowLayout().configured {
      $0.itemSize = CGSize(width: cellWidth, height: cellWidth)
      $0.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
      $0.minimumLineSpacing = cellSpacing
      $0.minimumInteritemSpacing = cellSpacing
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioCollectionViewCell.identifier, for: indexPath) as! PortfolioCollectionViewCell
    let coin: Coin = viewModel.itemAt(indexPath)
    
    cell.updateUI(with: coin)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.input.didSelectItemEvent.onNext(indexPath)
  }
}
