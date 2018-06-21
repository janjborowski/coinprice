//
//  DataValueFormatter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 21.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import Charts

final class DateValueFormatter: IAxisValueFormatter {
    
    private let dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "dd/MM"
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }

}
