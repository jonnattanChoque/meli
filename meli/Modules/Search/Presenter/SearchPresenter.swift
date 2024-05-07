//
//  SearchPresenter.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

class SearchPresenter: SearchPresenterProtocol {
    var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?
    var response: SearchModel?
    
    func search(text: String) {
        interactor?.searchInfo(text: text)
    }
    
    func showNextView(navigationController: UINavigationController) {
        guard let response = response else { return }
        self.router?.pushToListScreen(navigationController: navigationController, result: response)
    }
}

extension SearchPresenter: SearchPresenterViewProtocol {
    func searchFetchedSuccess(results: SearchModel) {
        response = results
        self.view?.resultSuccess()
    }
    
    func searchFetchFailed() {
        self.view?.showErrorResults()
    }
    
    func searchFetchEmpty() {
        self.view?.showEmptyResults()
    }
}
