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

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var coinSymbolLabel: UILabel!
    @IBOutlet private weak var coinNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    func fill(_ formatter: CoinPriceCellFormatter) {
        iconView.image = formatter.icon
        coinSymbolLabel.text = formatter.symbol
        coinNameLabel.text = formatter.name
        priceLabel.text = formatter.price
    }

}
