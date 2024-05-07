//
//  DetailRouter.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

class DetailRouter: DetailRouterProtocol {
    static func createModule(id: String) -> DetailViewController {
        let view = DetailViewController()
        let presenter: DetailPresenterProtocol & DetailPresenterViewProtocol = DetailPresenter()
        let interactor: DetailInteractorProtocol = DetailInteractor()
        let router: DetailRouterProtocol = DetailRouter()
        
        view.presenter = presenter
        view.modelId = id
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func backView(navigation: UINavigationController) {
        navigation.popViewController(animated: true)
    }
}
