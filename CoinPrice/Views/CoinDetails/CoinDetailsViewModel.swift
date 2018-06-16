//
//  CoinDetailsViewModel.swift
//  CoinPrice
//
//  Created by Jan Borowski on 16.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import RxSwift
import RxCocoa

final class CoinDetailsViewModel {

    private let ticker = BehaviorSubject<CoinTicker?>(value: nil)

    private let currencyFormatter = NumberFormatter()
    private let cryptoFormatter = NumberFormatter()

    var icon: Observable<UIImage?> {
        return ticker.map { $0?.symbol.lowercased() }.map { UIImage(named: $0 ?? "") }
    }

    var name: Observable<String?> {
        return ticker.map { $0?.name }
    }

    var symbol: Observable<String?> {
        return ticker.map { $0?.symbol }
    }

    var marketCap: Observable<String?> {
        return ticker.map { ticker in
            if let marketCap = ticker?.quotes.first?.marketCap {
                return self.currencyFormatter.string(from: marketCap as NSDecimalNumber)
            }
            else {
                return nil
            }
        }
    }

    var volume24h: Observable<String?> {
        return ticker.map { ticker in
            if let volume24h = ticker?.quotes.first?.volume24h {
                return self.currencyFormatter.string(from: volume24h as NSDecimalNumber)
            }
            else {
                return nil
            }
        }
    }

    var circulatingSupply: Observable<String?> {
        return ticker.map { ticker in
            return self.appendCryptoSymbol(value: ticker?.circulatingSupply, ticker: ticker)
        }
    }

    var maxSupply: Observable<String?> {
        return ticker.map { ticker in
            return self.appendCryptoSymbol(value: ticker?.maxSupply, ticker: ticker)
        }
    }

    init() {
        currencyFormatter.currencyGroupingSeparator = " "
        currencyFormatter.currencyDecimalSeparator = ","
        currencyFormatter.numberStyle = .currencyAccounting

        cryptoFormatter.usesGroupingSeparator = true
        cryptoFormatter.groupingSize = 3
        cryptoFormatter.groupingSeparator = " "
    }

    func configure(ticker: CoinTicker) {
        self.ticker.onNext(ticker)
        if ticker.quotes.first?.fiatCurrency == .usd {
            currencyFormatter.currencySymbol = "$"
        }
    }

    private func appendCryptoSymbol(value: Decimal?, ticker: CoinTicker?) -> String? {
        if let value = value,
            let ticker = ticker,
            let output = cryptoFormatter.string(from: value as NSDecimalNumber) {
            return output + " " + ticker.symbol
        }
        else {
            return nil
        }
    }

}
