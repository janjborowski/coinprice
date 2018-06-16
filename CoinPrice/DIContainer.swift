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
        container.register(CDModel.self) { resolver in
            return CDModel()
        }

        container.register(CoinTickerDataProvider.self, factory: { resolver -> CoinTickerDataProvider in
            let cdModel = resolver.resolve(CDModel.self)!
            return CDCoinTickerDataProvider(coreDataModel: cdModel)
        })
    }

    private func registerServices() {
        container.register(TickersServiceType.self) { resolver -> TickersServiceType in
            let dataProvider = resolver.resolve(CoinTickerDataProvider.self)!
            return TickersService(dataProvider: dataProvider)
        }
    }

    private func registerViewModels() {
        container.register(PriceListViewModel.self) { resolver in
            let service = resolver.resolve(TickersServiceType.self)!
            return PriceListViewModel(pricesService: service)
        }

        container.register(CoinDetailsViewModel.self) { resolver in
            return CoinDetailsViewModel()
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
    }

}
