//
//  CoinDetailsViewController.swift
//  CoinPrice
//
//  Created by Jan Borowski on 16.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit
import RxSwift

final class CoinDetailsViewController: UIViewController {

    private let bag = DisposeBag()

    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var marketCapLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    @IBOutlet private weak var circulatingSupplyLabel: UILabel!
    @IBOutlet private weak var maxSupplyContainer: UIStackView!
    @IBOutlet private weak var maxSupplyLabel: UILabel!

    var viewModel: CoinDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        subscribe()
    }

    private func subscribe() {
         viewModel.viewFormatter
            .map { $0.icon }
            .bind(to: iconView.rx.image)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.symbol }
            .bind(to: symbolLabel.rx.text)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.price }
            .bind(to: priceLabel.rx.text)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.marketCap }
            .bind(to: marketCapLabel.rx.text)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.volume }
            .bind(to: volumeLabel.rx.text)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.circulatingSupply }
            .bind(to: circulatingSupplyLabel.rx.text)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.maxSupply }
            .bind(to: maxSupplyLabel.rx.text)
            .disposed(by: bag)

        viewModel.viewFormatter
            .map { $0.maxSupply == nil }
            .bind(to: maxSupplyContainer.rx.isHidden)
            .disposed(by: bag)
    }

    func configure(ticker: CoinTicker) {
        viewModel.configure(ticker: ticker)
    }

}
