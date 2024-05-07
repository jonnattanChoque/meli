//
//  DetailPresenter.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

class DetailPresenter: DetailPresenterProtocol {
    var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    var response: DetailModel?
    var seller: SellerModel?
    
    func viewDidLoad(id: String) {
        interactor?.detailInfo(id: id)
    }
    
    func back(navigation: UINavigationController) {
        router?.backView(navigation: navigation)
    }
}

extension DetailPresenter: DetailPresenterViewProtocol {
    func detailFetchedSuccess(results: DetailModel, seller: SellerModel) {
        self.response = results
        self.seller = seller
        self.view?.resultSuccess()
    }
    
    func detailFetchFailed() {
        self.view?.showErrorResults()
    }
    
    func detailFetchEmpty() {
        self.view?.showEmptyResults()
    }
}
