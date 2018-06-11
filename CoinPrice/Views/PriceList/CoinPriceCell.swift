//
//  CoinPriceCell.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

final class CoinPriceCell: UITableViewCell {

    static let reuseIdentifier = "coinPriceCellIdentifier"

    @IBOutlet private weak var coinSymbolLabel: UILabel!
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    func fill(ticker: CoinTicker) {
        coinSymbolLabel.text = ticker.symbol
        coinNameLabel.text = ticker.name

        if let price = ticker.currencyQuotes.values.first?.price {
            let formatter = NumberFormatter()
            if price >= 1 {
                formatter.maximumFractionDigits = 2
            }
            else {
                formatter.minimumIntegerDigits = 1
                formatter.maximumFractionDigits = 5
            }
            priceLabel.text = formatter.string(for: price)
        }
    }

}
