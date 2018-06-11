//
//  Quote\.swift
//  CoinPrice
//
//  Created by Jan Borowski on 11.06.2018.
//  Copyright © 2018 Jan Borowski. All rights reserved.
//

import Foundation

struct Quote: Decodable {

    let price: Decimal
    let volume24h: Decimal

    enum CodingKeys: String, CodingKey {

        case price = "price"
        case volume24h = "volume_24h"

    }

}
