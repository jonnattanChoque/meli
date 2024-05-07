//
//  SearchInteractor.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class SearchInteractor: SearchInteractorProtocol {
    var presenter: SearchPresenterViewProtocol?
    private let status: Int = 200
    
    func searchInfo(text: String) {
        let url = Constants.endpointSearch.appending(text)
        Alamofire.request(url).responseObject { (response: DataResponse<SearchModel>) in
            if(response.response?.statusCode == self.status) {
                let results = response.result.value
                if(results?.results.count == .zero) {
                    self.presenter?.searchFetchEmpty()
                } else {
                    guard let results = results else {
                        self.presenter?.searchFetchEmpty()
                        return
                    }
                    self.presenter?.searchFetchedSuccess(results: results)
                }
            } else {
                self.presenter?.searchFetchFailed()
            }
        }
    }
}
