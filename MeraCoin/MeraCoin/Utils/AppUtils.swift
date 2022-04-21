//
//  AppUtils.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import Foundation


class AppUtils {
    
    static func configFormatter() -> NumberFormatter {
        
        var formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //formatter.groupingSeparator = ","
        //formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = 4
        formatter.roundingMode = .down
        formatter.minusSign = ""
        
        return formatter
    }
}
