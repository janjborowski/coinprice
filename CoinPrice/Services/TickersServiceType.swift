//
//  PricesServiceType.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import RxSwift

protocol TickersServiceType {

    func tickers(with fiatCurrency: FiatCurrency) -> Observable<[CoinTicker]>

}
