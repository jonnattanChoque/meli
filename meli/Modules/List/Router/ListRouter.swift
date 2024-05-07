//
//  ListRouter.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

class ListRouter: ListRouterProtocol {
    
    static func createModule(result: SearchModel) -> ListViewController {
        let view = ListViewController()
        let presenter: ListPresenterProtocol = ListPresenter()
        let router: ListRouterProtocol = ListRouter()
        
        view.presenter = presenter
        view.model = result
        presenter.view = view
        presenter.router = router
        
        return view
    }
    
    func pushToDetailScreen(navigationController: UINavigationController, id: String) {
        let module = DetailRouter.createModule(id: id)
        navigationController.pushViewController(module, animated: true)
    }
}
