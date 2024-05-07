//
//  DetailEntity.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class DetailModel: Mappable {
    var id: String = ""
    var siteID: String = ""
    var title: String = ""
    var price: Double = 0
    var sellerID: Int = 0
    var basePrice: Double = 0
    var originalPrice: Int = 0
    var currencyID: String = ""
    var initialQuantity: Int = 0
    var buyingMode: String = ""
    var condition: String = ""
    var permalink: String = ""
    var attributes: [Attributes]?
    var pictures: [Picture]?
    var acceptsMercadopago: Bool = false
    var internationalDeliveryMode: String = ""
    var sellerAddress: SellerAddress?
    var warranty: String = ""
    var lastUpdated: String = ""

    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.id                         <- map["id"]
        self.siteID                     <- map["site_id"]
        self.title                      <- map["title"]
        self.price                      <- map["price"]
        self.sellerID                   <- map["seller_id"]
        self.originalPrice              <- map["original_price"]
        self.initialQuantity            <- map["initial_quantity"]
        self.buyingMode                 <- map["buying_mode"]
        self.condition                  <- map["condition"]
        self.permalink                  <- map["permalink"]
        self.attributes                 <- map["attributes"]
        self.pictures                   <- map["pictures"]
        self.acceptsMercadopago         <- map["accepts_mercadopago"]
        self.internationalDeliveryMode  <- map["international_delivery_mode"]
        self.sellerAddress              <- map["seller_address"]
        self.warranty                   <- map["warranty"]
        self.lastUpdated                <- map["pictures"]
    }
}

class Attributes: Mappable {
    var id: String = ""
    var name: String = ""
    var valueName: String = ""
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.id         <- map["id"]
        self.name       <- map["name"]
        self.valueName  <- map["value_name"]
    }
}

class Picture: Mappable {
    var id: String = ""
    var secureURL: String = ""
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.id         <- map["id"]
        self.secureURL  <- map["secure_url"]
    }
}

class SellerAddress: Mappable {
    var city: City?
    var state: City?
    var country: City?
    var id: Int = 0
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.city       <- map["city"]
        self.state      <- map["state"]
        self.country    <- map["country"]
        self.id         <- map["id"]
    }
}

class City: Mappable {
    var id: String = ""
    var name: String = ""
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.id     <- map["id"]
        self.name   <- map["name"]
    }
}


class SellerModel: Mappable {
    var id: Int = 0
    var nickname: String = ""
    var countryID: String = ""
    var address: Address?
    var userType: String = ""
    var siteID: String = ""
    var permalink: String = ""
    var sellerReputation: SellerReputation?
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.id                 <- map["id"]
        self.nickname           <- map["nickname"]
        self.countryID          <- map["country_id"]
        self.address            <- map["address"]
        self.siteID             <- map["site_id"]
        self.userType           <- map["user_type"]
        self.permalink          <- map["country_id"]
        self.sellerReputation   <- map["seller_reputation"]
    }
}

// MARK: - Address
class Address: Mappable {
    var city: String = ""
    var state: String = ""
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.city   <- map["city"]
        self.state  <- map["state"]
    }
}

// MARK: - SellerReputation
class SellerReputation: Mappable {
    var levelID: String = ""
    var powerSellerStatus: String = ""
    var transactions: Transactions?
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.levelID            <- map["level_id"]
        self.powerSellerStatus  <- map["power_seller_status"]
        self.transactions       <- map["transactions"]
    }
}

// MARK: - Transactions
class Transactions: Mappable {
    var period: String = ""
    var total: Int = 0
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.period <- map["period"]
        self.total  <- map["total"]
    }
}
