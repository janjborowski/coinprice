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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
