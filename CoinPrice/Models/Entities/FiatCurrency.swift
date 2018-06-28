//
//  FiatCurrency.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

enum FiatCurrency: String, Decodable {

    case usd = "USD"
    case eur = "EUR"
    case jpy = "JPY"
    case cny = "CNY"
    case aud = "AUD"
    case cad = "CAD"
    case gbp = "GBP"
    case chf = "CHF"
    case sek = "SEK"
    case nok = "NOK"
    case rub = "RUB"
    case pln = "PLN"
    case unknown

    static var all: [FiatCurrency] {
        return [usd, eur, jpy, cny, aud, cad, gbp, chf, sek, nok, rub, pln]
    }

    static var base: FiatCurrency {
        return usd
    }

}
