//
//  DetailProtocols.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

protocol DetailPresenterProtocol: AnyObject {
    var view: DetailViewProtocol? {get set}
    var interactor: DetailInteractorProtocol? {get set}
    var router: DetailRouterProtocol? {get set}
    var response: DetailModel? {get set}
    var seller: SellerModel? {get set}
    func viewDidLoad(id: String)
    func back(navigation: UINavigationController)
}

protocol DetailViewProtocol: AnyObject {
    func showEmptyResults()
    func showErrorResults()
    func resultSuccess()
}

protocol DetailRouterProtocol: AnyObject {
    static func createModule(id: String)-> DetailViewController
    func backView(navigation: UINavigationController)
}

protocol DetailInteractorProtocol: AnyObject {
    var presenter: DetailPresenterViewProtocol? {get set}
    func detailInfo(id: String)
}

protocol DetailPresenterViewProtocol: AnyObject {
    func detailFetchedSuccess(results: DetailModel, seller: SellerModel)
    func detailFetchFailed()
    func detailFetchEmpty()
}

