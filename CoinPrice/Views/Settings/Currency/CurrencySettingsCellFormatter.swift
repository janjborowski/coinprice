//
//  CurrencySettingsViewFormatter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 24.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

struct CurrencySettingsCellFormatter {

    let currency: FiatCurrency
    let picked: FiatCurrency

    var name: String {
        return currency.rawValue
    }

    var accessoryType: UITableViewCellAccessoryType {
        return currency == picked ? .checkmark : .none
    }

}
