//
//  CurrencySettingsViewModel.swift
//  CoinPrice
//
//  Created by Jan Borowski on 24.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation
import RxSwift

final class CurrencySettingsViewModel {

    private let bag = DisposeBag()
    private let settingsDataProvider: SettingsDataProvider

    let cellFormatters: Observable<[CurrencySettingsCellFormatter]>

    init(settingsDataProvider: SettingsDataProvider) {
        self.settingsDataProvider = settingsDataProvider

        cellFormatters = Observable.combineLatest(
                Observable.of(FiatCurrency.all),
                settingsDataProvider.currency.asObservable()
            )
            .map { (arg) -> [CurrencySettingsCellFormatter] in
                let (currencies, picked) = arg
                return currencies.map { (currency) -> CurrencySettingsCellFormatter in
                    return CurrencySettingsCellFormatter(currency: currency, picked: picked)
                }
            }
    }

    func update(fiatCurrency: FiatCurrency) {
        settingsDataProvider.currency.accept(fiatCurrency)
    }

}
