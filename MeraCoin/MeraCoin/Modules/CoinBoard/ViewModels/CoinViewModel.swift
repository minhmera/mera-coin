//
//  CoinViewModel.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import Foundation

struct CoinViewModel: Equatable {
    static func == (lhs: CoinViewModel, rhs: CoinViewModel) -> Bool {
        return lhs.fullNameText == rhs.fullNameText && lhs.shortNameText == rhs.shortNameText
    }
    

    private let coin: CoinModel
    private let formatter: NumberFormatter

    var shortNameText: String {
        coin.base
    }
    
    var fullNameText: String {
        coin.name
    }

    var priceText: String {
        "$\(coin.sell_price)"
    }
    
    var logoUrlString: String {
        "\(coin.icon)"
    }
    
    var currencyText: String {
        "USD"
    }
    
    
    
    var revenueText: String {
        let priceNumberFormat: String = self.formatter.string(from: NSNumber(value: self.getRevenue())) ?? ""
        if self.getRevenue() > 0 {
            return "+ $\(priceNumberFormat)"
        } else {
            return "- $\(priceNumberFormat)"
        }
        
    }
    
    func getRevenue() -> Double {
        let sPrice: Double = Double(self.coin.sell_price) ?? 0
        let bPrice: Double = Double(self.coin.buy_price) ?? 0
        let revenue: Double = sPrice - bPrice
        return revenue
    }
  
   

    init(coin: CoinModel) {
        self.coin = coin
        self.formatter = AppUtils.configFormatter()
       
    }
   
}
