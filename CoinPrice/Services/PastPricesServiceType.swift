//
//  PastPricesServiceType.swift
//  CoinPrice
//
//  Created by Jan Borowski on 21.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import RxSwift

protocol PastPricesServiceType {

    func pastPrices(ticker: CoinTicker, fiatCurrency: FiatCurrency) -> Observable<[PastPrice]>

}
