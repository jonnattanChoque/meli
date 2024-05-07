//
//  Format.swift
//  meli
//
//  Created by jonnattan Choque on 4/05/24.
//

import Foundation

class Format {
    static func currency(price: Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        let priceString = currencyFormatter.string(from: NSNumber(value: price))!
        
        return priceString
    }
    
    static func separator(number: Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: number as NSNumber) ?? ""
        
        return formattedNumber
    }
}
