//
//  PersistenceMapper.swift
//  CoinPrice
//
//  Created by Jan Borowski on 14.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

protocol PersistenceMapper {

    associatedtype Value
    associatedtype Persisted

    func mapToPersisted(_ values: [Value]) -> [Persisted]

    func mapToValue(_ savedEntities: [Persisted]) -> [Value]

}
