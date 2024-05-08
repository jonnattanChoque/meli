//
//  DetailInteractor.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class DetailInteractor: DetailInteractorProtocol {
    var presenter: DetailPresenterViewProtocol?
    private let status: Int = 200
    private var model: DetailModel?

    func detailInfo(id: String) {
        let url = Constants.endpointDetails.appending(id)
        Alamofire.request(url).responseObject { (response: DataResponse<DetailModel>) in
            if(response.response?.statusCode == self.status) {
                let results = response.result.value
                if(results?.id == nil || results?.id == "") {
                    self.presenter?.detailFetchEmpty()
                } else {
                    guard let results = results else {
                        self.presenter?.detailFetchEmpty()
                        return
                    }
                    self.model = results
                    self.detailInfoSeller(id: results.sellerID)
                }
            } else {
                self.presenter?.detailFetchFailed()
            }
        }
    }
    
    func detailInfoSeller(id: Int) {
        let url = Constants.endpointSeller.appending(String(describing: id))
        Alamofire.request(url).responseObject { (response: DataResponse<SellerModel>) in
            if(response.response?.statusCode == self.status) {
                let results = response.result.value
                if(results?.id == nil || results?.id == .zero) {
                    self.presenter?.detailFetchEmpty()
                } else {
                    guard let results = results else {
                        self.presenter?.detailFetchEmpty()
                        return
                    }
                    guard let model = self.model else { return }
                    self.presenter?.detailFetchedSuccess(results: model, seller: results)
                }
            } else {
                self.presenter?.detailFetchFailed()
            }
        }
    }
}

