//
//  PastPricesResponse.swift
//  CoinPrice
//
//  Created by Jan Borowski on 21.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

struct PastPricesResponse: Codable {

    let data: [PastPrice]

    enum CodingKeys: String, CodingKey {

        case data = "Data"

    }

}
