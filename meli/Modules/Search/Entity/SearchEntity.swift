//
//  SearchEntity.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class SearchModel: Mappable {
    var siteID: String = ""
    var countryDefaultTimeZone :String = ""
    var query: String = ""
    var paging: Paging?
    var results: [Result] = []

    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.siteID     <- map["site_id"]
        self.countryDefaultTimeZone <- map["country_default_time_zone"]
        self.query   <- map["query"]
        self.paging   <- map["paging"]
        self.results   <- map["results"]
    }
}

class Paging: Mappable {
    var total: Int = 0
    var primaryResults: Int = 0
    var offset: Int = 0
    var limit: Int = 0
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.total     <- map["total"]
        self.primaryResults <- map["primary_results"]
        self.offset   <- map["offset"]
        self.limit   <- map["limit"]
    }
}

class Result: Mappable {
    var id: String = ""
    var title: String = ""
    var condition: String = ""
    var thumbnailID: String = ""
    var catalogProductID: String = ""
    var listingTypeID: String = ""
    var permalink: String = ""
    var buyingMode: String = ""
    var siteID: String = ""
    var categoryID: String = ""
    var domainID: String = ""
    var thumbnail: String = ""
    var currencyID: String = ""
    var orderBackend: Int = 0
    var price: Double = 0
    var originalPrice: Int?
    var availableQuantity: Int = 0
    var officialStoreID: Int?
    var officialStoreName: String?
    var useThumbnailID: Bool = false
    var acceptsMercadopago: Bool = false
    
    required init?(map: Map) {
        
    }

    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["title"]
        self.condition <- map["condition"]
        self.thumbnailID <- map["thumbnail_id"]
        self.catalogProductID <- map["catalog_product_id"]
        self.listingTypeID <- map["listing_type_id"]
        self.permalink <- map["permalink"]
        self.buyingMode <- map["buying_mode"]
        self.siteID <- map["site_id"]
        self.categoryID <- map["category_id"]
        self.domainID <- map["domain_id"]
        self.thumbnail <- map["thumbnail"]
        self.currencyID <- map["currency_id"]
        self.orderBackend <- map["order_backend"]
        self.price <- map["price"]
        self.originalPrice <- map["original_price"]
        self.availableQuantity <- map["available_quantity"]
        self.officialStoreID <- map["official_store_id"]
        self.officialStoreName <- map["official_store_name"]
        self.useThumbnailID <- map["use_thumbnail_id"]
        self.acceptsMercadopago <- map["accepts_mercadopago"]
    }
}
