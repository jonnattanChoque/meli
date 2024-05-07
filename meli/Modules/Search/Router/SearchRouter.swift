//
//  SearchRouter.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

class SearchRouter: SearchRouterProtocol {
    static func createModule() -> SearchViewController {
        let view = SearchViewController()
        let presenter: SearchPresenterProtocol & SearchPresenterViewProtocol = SearchPresenter()
        let interactor: SearchInteractorProtocol = SearchInteractor()
        let router: SearchRouterProtocol = SearchRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func pushToListScreen(navigationController: UINavigationController, result: SearchModel) {
        let listModule = ListRouter.createModule(result: result)
        navigationController.pushViewController(listModule, animated: true)
    }
}
