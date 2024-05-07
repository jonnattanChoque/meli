//
//  Constants.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation

struct Constants {
    static var primaryColor = "meliColor"
    static var logo = "mercadolibre"
    static var isNew = "new"
    static var endpointSearch = "https://api.mercadolibre.com/sites/MLA/search?q="
    static var endpointDetails = "https://api.mercadolibre.com/items/"
    static var endpointSeller = "https://api.mercadolibre.com/users/"
}


enum FontSize: CGFloat {
    case small = 12
    case medium = 15
    case big = 22
}
