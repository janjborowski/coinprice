//
//  SettingsDataProvider.swift
//  CoinPrice
//
//  Created by Jan Borowski on 24.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsDataProvider {

    private let bag = DisposeBag()

    private enum DefaultsKey: String {

        case currency

    }

    let currency = BehaviorRelay<FiatCurrency>(value: FiatCurrency.base)

    init() {
        restore()

        currency.subscribe(onNext: saveCurrency)
            .disposed(by: bag)
    }

    private func restore() {
        if let rawCurrency = UserDefaults.standard.string(forKey: DefaultsKey.currency.rawValue),
            let fiatCurrency = FiatCurrency(rawValue: rawCurrency) {
            currency.accept(fiatCurrency)
        }
    }

    private func saveCurrency(currency: FiatCurrency) {
        UserDefaults.standard.set(currency.rawValue, forKey: DefaultsKey.currency.rawValue)
    }

}
