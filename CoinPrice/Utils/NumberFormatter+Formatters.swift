//
//  NumberFormatter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 18.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

enum NumberFormatterType {

    case price
    case bigNum
    case crypto

}

extension NumberFormatter {

    convenience init(type: NumberFormatterType) {
        self.init()
        switch type {
        case .price:
            numberStyle = .currencyAccounting
        case .bigNum:
            currencyGroupingSeparator = " "
            numberStyle = .currencyAccounting
            maximumFractionDigits = 0
        case .crypto:
            usesGroupingSeparator = true
            groupingSize = 3
            groupingSeparator = " "
        }
    }

    func configure(for price: Decimal) {
        if price >= 1 {
            minimumFractionDigits = 2
            maximumFractionDigits = 2
        } else {
            minimumIntegerDigits = 1
            maximumFractionDigits = 5
        }
    }

    func configure(for currency: FiatCurrency) {
        switch currency {
        case .usd:
            currencySymbol = "$"
        default:
            currencySymbol = ""
        }
    }

}
