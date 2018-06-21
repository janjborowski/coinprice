//
//  CoinDetailsViewController.swift
//  CoinPrice
//
//  Created by Jan Borowski on 16.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit
import RxSwift
import Charts

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

    @IBOutlet private weak var chartView: LineChartView!

    var viewModel: CoinDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        subscribe()
        configureChart()
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
            .map { $0.chartData }
            .bind(to: chartView.rx.chartData)
            .disposed(by: bag)
    }

    func configure(ticker: CoinTicker) {
        viewModel.configure(ticker: ticker)
    }

    private func configureChart() {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.drawMarkers = false

        chartView.backgroundColor = .white
        chartView.legend.enabled = false

        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = true

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 60*60*24
        xAxis.valueFormatter = DateValueFormatter()

        let rightAxis = chartView.rightAxis
        rightAxis.labelPosition = .outsideChart
        rightAxis.labelFont = .systemFont(ofSize: 14, weight: .light)
        rightAxis.drawGridLinesEnabled = true
        rightAxis.drawAxisLineEnabled = false
        rightAxis.labelTextColor = .black
        rightAxis.decimals = 4
        rightAxis.valueFormatter = PriceValueFormatter()
    }

}
