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
    $0.addGestureRecognizer(longPressGesture)
    $0.refreshControl = refeshControl
  }
  
  private let emptyInterestLabel = UILabel().configured {
    $0.text = Constant.LabelTitle.emptyInterestCoin
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 17, weight: .bold)
    $0.textAlignment = .center
  }
  
  private lazy var longPressGesture = UILongPressGestureRecognizer(
    target: self,
    action: #selector(handleLongPress(gestureRecognizer:))
  )
  
  private lazy var refeshControl = UIRefreshControl().configured {
    $0.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    viewModel.input.viewWillDisAppearEvent.onNext(())
  }
  
  override func setHierarchy() {
    view.addSubviews(collectionView, emptyInterestLabel)
  }
  
  override func setAttribute() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: .tabUser, style: .plain, target: self, action: #selector(profileBarButtonTapped))
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
    
    viewModel.output.interestMoved.subscribe { [weak self] message in
      guard let self else { return }
      guard let message else { return }
      
      view.makeToast(
        message,
        duration: 1.0,
        position: .center,
        title: Constant.LabelTitle.interestConfiguration
      )
    }
    
    viewModel.output.timerActionProceeded.subscribe { [weak self] _ in
      guard let self else { return }
      
      view.makeToast(
        Constant.LabelTitle.coinRefeshedMessage,
        duration: 1.0,
        position: .bottom,
        title: Constant.LabelTitle.coinRefeshedTitle
      )
    }
  }
  
  // MARK: - Selector
  @objc private func profileBarButtonTapped() {
    viewModel.input.profileButtonTapEvent.onNext(())
  }
  
  @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    switch gestureRecognizer.state {
      case .began:
        guard let selectedIndexPath = collectionView.indexPathForItem(
          at: gestureRecognizer.location(in: collectionView)
        ) else {
          break
        }
        
        collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
      
      case .changed:
        collectionView.updateInteractiveMovementTargetPosition(
          gestureRecognizer.location(in: gestureRecognizer.view!)
        )
      
      case .ended:
        collectionView.endInteractiveMovement()
      
      default:
        collectionView.cancelInteractiveMovement()
    }
  }
  
  @objc private func refresh() {
    viewModel.input.viewWillAppearEvent.onNext(())
    refeshControl.endRefreshing()
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
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PortfolioCollectionViewCell.identifier,
      for: indexPath
    ) as! PortfolioCollectionViewCell
    let coin: Coin = viewModel.itemAt(indexPath)
    
    cell.updateUI(with: coin)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    viewModel.input.didItemMovedEvent.onNext((from: sourceIndexPath, to: destinationIndexPath))
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.input.didSelectItemEvent.onNext(indexPath)
  }
}
