//
//  CoinData.swift
//  ByteCoin
//
//  Created by Cesar Humberto Grifaldo Garcia on 14/12/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable{
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
