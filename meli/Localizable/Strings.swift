//
//  Strings.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

struct Strings {
    struct General {
        static var payment: String = "General.payment".localized()
        struct Alert {
            static var button: String = "General.Alert.button".localized()
        }
    }
    struct Search {
        static var button: String = "Search.button.title".localized()
        static var placeholder: String = "Search.placeholder".localized()
        static var AlertEmptyTitle: String = "Search.AlertEmpty.title".localized()
        static var AlertEmptyMessage: String = "Search.AlertEmpty.message".localized()
        static var AlertLoadingTitle: String = "Search.AlertLoading.title".localized()
        static var AlertLoadingMessage: String = "Search.AlertLoading.message".localized()
        static var AlertErrorTitle: String = "Search.AlertError.title".localized()
        static var AlertErrorMessage: String = "Search.AlertError.message".localized()
        static var AlertEmptyResultsTitle: String = "Search.AlertEmptyResults.title".localized()
        static var AlertEmptyResultsMessage: String = "Search.AlertEmptyResults.message".localized()
    }
    
    struct List {
        static var Title: String = "List.title".localized()
        static var Stock: String = "List.stock".localized()
        static var Back: String = "List.back".localized()
        static var Search: String = "List.search".localized()
        static var Results: String = "List.results".localized()
    }
    
    struct Detail {
        static var IsNew: String = "Detail.isNew".localized()
        static var NoIsNew: String = "Detail.noIsNew".localized()
        static var InternationalPay: String = "Detail.internationalPay".localized()
        static var Stock: String = "Detail.stock".localized()
        static var Attributes: String = "Detail.attributes".localized()
        static var Seller: String = "Detail.seller".localized()
        static var Power: String = "Detail.power".localized()
        static var Sales: String = "Detail.sales".localized()
    }
}
