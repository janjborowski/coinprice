//
//  PriceListRouter.swift
//  CoinPrice
//
//  Created by Jan Borowski on 16.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit

final class PriceListRouter {

    unowned var sourceController: UIViewController

    init(sourceController: UIViewController) {
        self.sourceController = sourceController
    }

    func showDetails(ticker: CoinTicker) {
        let storyboard = UIStoryboard(name: "CoinDetails", bundle: nil)
        if let controller = storyboard.instantiateInitialViewController() as? CoinDetailsViewController {
            controller.configure(ticker: ticker)
            sourceController.navigationController?.pushViewController(controller, animated: true)
        }
    }

}
