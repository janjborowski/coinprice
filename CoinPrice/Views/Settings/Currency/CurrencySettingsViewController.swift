//
//  CurrencySettingsViewController.swift
//  CoinPrice
//
//  Created by Jan Borowski on 24.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CurrencySettingsViewController: UIViewController {

    private let bag = DisposeBag()
    private let cellIdentifier = "cell"

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!

    var viewModel: CurrencySettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()

        tableView.tableFooterView = UIView(frame: .zero)
    }

    private func subscribe() {
        viewModel.cellFormatters
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { (_, model: CurrencySettingsCellFormatter, cell: UITableViewCell) in
                cell.textLabel?.text = model.name
                cell.accessoryType = model.accessoryType
            }
            .disposed(by: bag)

        tableView.rx.modelSelected(CurrencySettingsCellFormatter.self)
            .subscribe(onNext: { [unowned self] (formatter) in
                self.viewModel.update(fiatCurrency: formatter.currency)
            })
            .disposed(by: bag)

        cancelButton!.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

}
