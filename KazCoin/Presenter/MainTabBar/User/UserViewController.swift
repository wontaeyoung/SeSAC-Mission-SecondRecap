//
//  UserViewController.swift
//  KazCoin
//
//  Created by 원태영 on 3/4/24.
//

import UIKit
import KazUtility
import CoinDesignSystem
import SnapKit

final class UserViewController: BaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var tableView = UITableView(frame: .zero, style: .plain).configured {
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    $0.delegate = self
    $0.dataSource = self
  }
  
  // MARK: - Property
  let viewModel: UserViewModel
  
  // MARK: - Initializer
  init(viewModel: UserViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    viewModel.input.viewWillAppearEvent.onNext(())
  }
  
  override func setHierarchy() {
    view.addSubview(tableView)
  }
  
  override func setConstraint() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    viewModel.output.interestCount.subscribe { [weak self] _ in
      guard let self else { return }
      
      tableView.reloadData()
    }
    
    viewModel.input.viewDidLoadEvent.onNext(())
  }
}

extension UserViewController: TableControllable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let config = viewModel.configAt(indexPath)
    
    cell.textLabel?.text = viewModel.cellTitleAt(indexPath)
    cell.selectionStyle = config == .interest ? .none : .default
    cell.textLabel?.textColor = config == .interest
    ? KazCoinAsset.Color.primaryText
    : KazCoinAsset.Color.plusLabel
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.input.didSelectRowEvent.onNext(indexPath)
    tableView.reloadRow(row: indexPath.row)
  }
}
