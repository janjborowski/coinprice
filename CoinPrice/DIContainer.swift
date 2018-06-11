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
        registerServices()
        registerViewModels()
        registerViewControllers()
    }

    private func registerServices() {
        container.register(PricesServiceType.self) { resolver -> PricesServiceType in
            return PricesService()
        }
    }

    private func registerViewModels() {
        container.register(PriceListViewModel.self) { resolver in
            let service = resolver.resolve(PricesServiceType.self)!
            return PriceListViewModel(pricesService: service)
        }
    }

    private func registerViewControllers() {
        container.storyboardInitCompleted(PriceListViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(PriceListViewModel.self)
        }
    }

}
