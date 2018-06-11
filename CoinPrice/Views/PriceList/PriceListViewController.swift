//
//  ViewController.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

final class PriceListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let coinPriceCellNib = UINib(nibName: String(describing: CoinPriceCell.self), bundle: nil)
        tableView.register(coinPriceCellNib, forCellReuseIdentifier: CoinPriceCell.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: CoinPriceCell.reuseIdentifier) ?? UITableViewCell()
    }

}

