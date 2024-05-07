//
//  SearchProtocols.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol? {get set}
    var interactor: SearchInteractorProtocol? {get set}
    var router: SearchRouterProtocol? {get set}
    func search(text: String)
    func showNextView(navigationController: UINavigationController)
}

protocol SearchViewProtocol: AnyObject {
    func showEmptyResults()
    func showErrorResults()
    func resultSuccess()
}

protocol SearchRouterProtocol: AnyObject {
    static func createModule()-> SearchViewController
    func pushToListScreen(navigationController: UINavigationController, result: SearchModel)
}

protocol SearchInteractorProtocol: AnyObject {
    var presenter: SearchPresenterViewProtocol? {get set}
    func searchInfo(text: String)
}

protocol SearchPresenterViewProtocol: AnyObject {
    func searchFetchedSuccess(results: SearchModel)
    func searchFetchFailed()
    func searchFetchEmpty()
}

