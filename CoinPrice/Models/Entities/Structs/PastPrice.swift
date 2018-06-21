//
//  PastPrice.swift
//  CoinPrice
//
//  Created by Jan Borowski on 21.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

struct PastPrice: Codable {

    let time: Date
    let open: Decimal?
    let high: Decimal?
    let low: Decimal?
    let close: Decimal?

    init(time: Date, open: Decimal?, high: Decimal?, low: Decimal?, close: Decimal?) {
        self.time = time
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }

}
