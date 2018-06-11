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

    var viewModel: PriceListViewModel!

    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        subscribe()
    }

    private func setupTableView() {
        let coinPriceCellNib = UINib(nibName: String(describing: CoinPriceCell.self), bundle: nil)
        tableView.register(coinPriceCellNib, forCellReuseIdentifier: CoinPriceCell.reuseIdentifier)

        tableView.refreshControl = UIRefreshControl()
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
                    let refreshControl = tableView.refreshControl else {
                    return
                }
                tableView.refreshControl?.beginRefreshing()
                let offset = CGPoint(x: 0, y: -refreshControl.frame.height)
                tableView.setContentOffset(offset, animated: true)
            })
            .disposed(by: bag)

        isLoading.filter { !$0 }
            .subscribe(onNext: { [weak self] (_) in
                guard let tableView = self?.tableView else {
                    return
                }
                self?.tableView.refreshControl?.endRefreshing()
                tableView.setContentOffset(.zero, animated: true)
            })
            .disposed(by: bag)

        viewModel.coinTickers.bind(to: tableView.rx.items(cellIdentifier: CoinPriceCell.reuseIdentifier)) { (index: Int, model : CoinTicker, cell:CoinPriceCell) in
            cell.fill(ticker: model)
        }
        .disposed(by: bag)
    }

}

