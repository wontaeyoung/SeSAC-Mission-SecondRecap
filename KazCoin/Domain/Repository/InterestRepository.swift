//
//  InterestRepository.swift
//  KazCoin
//
//  Created by 원태영 on 2/28/24.
//

protocol InterestRepository {
 
  func create(with coin: Coin) throws
  func fetch() -> [String]
  func delete(with coin: Coin) throws
}

