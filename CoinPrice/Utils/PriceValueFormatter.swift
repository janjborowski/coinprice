//
//  PriceValueFormatter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 22.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import Charts

final class PriceValueFormatter: IAxisValueFormatter {

    private let numberFormatter = NumberFormatter()

    init() {
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.paddingPosition = .beforePrefix
        numberFormatter.paddingCharacter = "0"
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value >= 10 {
            numberFormatter.maximumFractionDigits = 0
        } else if value >= 1 {
            numberFormatter.maximumFractionDigits = 2
        } else {
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 5
        }
        return numberFormatter.string(for: value) ?? ""
    }

}
