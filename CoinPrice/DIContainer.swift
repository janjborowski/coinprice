//
//  DIContainer.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Swinject
import SwinjectStoryboard

final class DIContainer {

    let container = SwinjectStoryboard.defaultContainer

    init() {
        registerPersistence()
        registerServices()
        registerViewModels()
        registerViewControllers()
    }

    private func registerPersistence() {
        container.register(CDModel.self) { _ in
                return CDModel()
            }
            .inObjectScope(.container)

        container.register(CoinTickerDataProvider.self, factory: { resolver -> CoinTickerDataProvider in
                let cdModel = resolver.resolve(CDModel.self)!
                return CDCoinTickerDataProvider(coreDataModel: cdModel)
            })
            .inObjectScope(.container)

        container.register(SettingsDataProvider.self) { _ in
                return SettingsDataProvider()
            }
            .inObjectScope(.container)
    }

    private func registerServices() {
        container.register(TickersServiceType.self) { resolver -> TickersServiceType in
                let dataProvider = resolver.resolve(CoinTickerDataProvider.self)!
                return TickersService(dataProvider: dataProvider)
            }
            .inObjectScope(.container)

        container.register(PastPricesServiceType.self) { resolver -> PastPricesServiceType in
                let dataProvider = resolver.resolve(CoinTickerDataProvider.self)!
                return PastPricesService(dataProvider: dataProvider)
            }
            .inObjectScope(.container)
    }

    private func registerViewModels() {
        container.register(PriceListViewModel.self) { resolver in
            let service = resolver.resolve(TickersServiceType.self)!
            let dataProvider = resolver.resolve(SettingsDataProvider.self)!
            return PriceListViewModel(tickerService: service, settingsDataProvider: dataProvider)
        }

        container.register(CoinDetailsViewModel.self) { resolver in
            let service = resolver.resolve(PastPricesServiceType.self)!
            let dataProvider = resolver.resolve(SettingsDataProvider.self)!
            return CoinDetailsViewModel(pastPricesService: service, settingsDataProvider: dataProvider)
        }

        container.register(CurrencySettingsViewModel.self) { resolver in
            let settingsDataProvider = resolver.resolve(SettingsDataProvider.self)!
            return CurrencySettingsViewModel(settingsDataProvider: settingsDataProvider)
        }
    }

    private func registerViewControllers() {
        container.storyboardInitCompleted(PriceListViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(PriceListViewModel.self)
            controller.router = PriceListRouter(sourceController: controller)
        }

        container.storyboardInitCompleted(CoinDetailsViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(CoinDetailsViewModel.self)
        }

        container.storyboardInitCompleted(SettingsViewController.self) { _, controller in
            controller.router = SettingsRouter(sourceController: controller)
        }

        container.storyboardInitCompleted(CurrencySettingsViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(CurrencySettingsViewModel.self)
        }
    }

}
