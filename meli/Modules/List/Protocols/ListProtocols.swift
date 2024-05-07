//
//  SearchProtocols.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

protocol ListPresenterProtocol: AnyObject {
    var view: ListViewProtocol? {get set}
    var router: ListRouterProtocol? {get set}
    func showDetail(navigationController: UINavigationController, id: String)
}

protocol ListViewProtocol: AnyObject {
    func showEmptyResults()
    func showErrorResults()
}

protocol ListRouterProtocol: AnyObject {
    static func createModule(result: SearchModel)-> ListViewController
    func pushToDetailScreen(navigationController: UINavigationController, id: String)
}
