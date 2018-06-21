//
//  LineChartView+Rx.swift
//  CoinPrice
//
//  Created by Jan Borowski on 21.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import Charts
import RxSwift
import RxCocoa

extension Reactive where Base: ChartViewBase {

    var chartData: Binder<ChartData> {
        return Binder(self.base) { (chartView: ChartViewBase, data: ChartData) in
            chartView.data = data
        }
    }

}
