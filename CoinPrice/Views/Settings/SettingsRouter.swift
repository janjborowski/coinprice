//
//  SettingsRouter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 24.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

final class SettingsRouter {

    unowned var sourceController: UIViewController

    init(sourceController: UIViewController) {
        self.sourceController = sourceController
    }

    func showCurrencySettings() {
        let storyboard = UIStoryboard(name: "CurrencySettings", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() as? CurrencySettingsViewController {
            sourceController.present(controller, animated: true, completion: nil)
        }
    }

}
