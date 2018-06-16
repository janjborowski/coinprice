//
//  ViewController.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit
import RxSwift

final class PriceListViewController: UIViewController {

    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()

    var viewModel: PriceListViewModel!
    var router: PriceListRouter!

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        setupTableView()
        subscribe()
    }

    private func setupTableView() {
        let coinPriceCellNib = UINib(nibName: String(describing: CoinPriceCell.self), bundle: nil)
        tableView.register(coinPriceCellNib, forCellReuseIdentifier: CoinPriceCell.reuseIdentifier)

        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func subscribe() {
        let isLoading = viewModel.isLoading
            .skip(1)
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)

        isLoading.filter { $0 }
            .subscribe(onNext: { [weak self] (_) in
                guard let tableView = self?.tableView,
                    let refreshControl = tableView.refreshControl,
                    !refreshControl.isRefreshing else {
                    return
                }
                tableView.refreshControl?.beginRefreshing()
            })
            .disposed(by: bag)

        isLoading.filter { !$0 }
            .subscribe(onNext: { [weak self] (_) in
                guard let tableView = self?.tableView,
                    tableView.refreshControl?.isRefreshing == true else {
                    return
                }
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: bag)

        viewModel.coinTickers
            .bind(to: tableView.rx.items(cellIdentifier: CoinPriceCell.reuseIdentifier)) { (index: Int, model : CoinTicker, cell:CoinPriceCell) in
                cell.fill(ticker: model)
            }
            .disposed(by: bag)

        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.refresh()
            })
            .disposed(by: bag)

        tableView.rx.modelSelected(CoinTicker.self)
            .subscribe(onNext: { [weak self] ticker in
                self?.router.showDetails(ticker: ticker)
            })
            .disposed(by: bag)
    }

}

