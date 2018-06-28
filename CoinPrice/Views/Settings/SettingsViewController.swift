//
//  SettingsViewController.swift
//  CoinPrice
//
//  Created by Jan Borowski on 24.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

final class SettingsViewController: UITableViewController {

    var router: SettingsRouter!

    private enum Row: Int {

        case currency

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.title = "Settings"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = Row(rawValue: indexPath.row) else {
            return
        }

        switch row {
        case .currency:
            router.showCurrencySettings()
        }
    }

}
