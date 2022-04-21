//
//  CoinModel.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import Foundation
struct CoinResonseModel: Codable {
    var data: [CoinModel]
}


struct CoinModel: Codable {
    var base: String
    var counter: String
    var buy_price: String
    var sell_price: String
    var icon: String
    var name: String
}

