//
//  ListPresenter.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

class ListPresenter: ListPresenterProtocol {
    var view: ListViewProtocol?
    var router: ListRouterProtocol?
    
    func showDetail(navigationController: UINavigationController, id: String) {
        router?.pushToDetailScreen(navigationController: navigationController, id: id)
    }
}
