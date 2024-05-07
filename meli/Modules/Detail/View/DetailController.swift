//
//  DetailViewController.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit
import PureLayout

class DetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol?
    var modelId: String = ""
    private var carouselView: CarouselView?
    private var tableView: AttributesView?
    private var priceView: PriceView?
    private var sellerView: SellerView?
    private var didSetupConstraints: Bool = true
    private let marginHorizontal: CGFloat = 12
    private let marginTop: CGFloat = 10
    private let marginBottom: CGFloat = 12
    private let corner: CGFloat = 10
    private let tableHeight: CGFloat = 300
    private let carouselHeight: CGFloat = 180
    private let carouselHeightLandscape: CGFloat = 220
    private var contentHeight: CGFloat = 0
    
    var horizontalLayoutConstraints: NSArray?
    var verticalLayoutConstraints: NSArray?
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var isNew: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy var titleProduct: UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    lazy var payment: UILabel = {
        let label = UILabel()
        label.text = Strings.General.payment
        return label
    }()
    
    lazy var internationalPay: UILabel = {
        let label = UILabel()
        label.text = Strings.Detail.InternationalPay
        return label
    }()
    
    lazy var totalPicture: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy var viewAttributes: UIView = {
        let view = UIView()
        view.layer.cornerRadius = corner
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad(id: modelId)
        
        self.view.backgroundColor = .white
        configNav()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        if UIDevice.current.orientation.isLandscape {
            contentHeight = UIScreen.main.bounds.size.width
        } else {
            contentHeight = UIScreen.main.bounds.size.height
        }
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            horizontalLayoutConstraints = NSLayoutConstraint.autoCreateAndInstallConstraints {
                mainView.autoSetDimensions(to: CGSize(width: UIScreen.main.bounds.size.width, height: contentHeight))
//                carouselView?.autoSetDimension(.height, toSize: carouselHeight)
            } as NSArray?
            
            verticalLayoutConstraints = NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
                mainView.autoSetDimension(.width, toSize: contentHeight)
                mainView.autoSetDimension(.height, toSize: contentHeight)
            } as NSArray?
            
            configureScroll()
            configureIsNew()
            configureTitle()
            configurePayment()
            configureTotal()
            configurePictures()
            configurePrice()
            configureSeller()
            configureAttributes()

            didSetupConstraints = true
        }
        super.updateViewConstraints()
        rotated()
    }
    
    private func configNav() {
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: Constants.primaryColor)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: Strings.List.Back, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    private func addSubviews() {
        guard let model = presenter?.response,
        let modelPictures = presenter?.response?.pictures,
        let modelAttributes = presenter?.response?.attributes,
        let modelSeller = presenter?.seller,
            let country = presenter?.response?.sellerAddress?.country?.name else{ return }
        carouselView = CarouselView(model: modelPictures)
        tableView = AttributesView(model: modelAttributes)
        priceView = PriceView(model: model)
        sellerView = SellerView(model: modelSeller, country: country)
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        
        mainView.addSubview(isNew)
        mainView.addSubview(titleProduct)
        mainView.addSubview(payment)
        mainView.addSubview(internationalPay)
        mainView.addSubview(totalPicture)
        mainView.addSubview(carouselView ?? UIView())
        mainView.addSubview(priceView ?? UIView())
        mainView.addSubview(sellerView ?? UIView())
        mainView.addSubview(viewAttributes)
    }
    
    private func configureScroll() {
        scrollView.autoPinEdge(toSuperviewEdge: .top)
        scrollView.autoPinEdge(toSuperviewEdge: .right)
        scrollView.autoPinEdge(toSuperviewEdge: .left)
        scrollView.autoPinEdge(toSuperviewEdge: .bottom)
        
        mainView.autoPinEdge(toSuperviewEdge: .top)
        mainView.autoPinEdge(toSuperviewEdge: .right)
        mainView.autoPinEdge(toSuperviewEdge: .left)
        mainView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    private func configureIsNew() {
        isNew.text = presenter?.response?.condition == Constants.isNew ? Strings.Detail.IsNew : Strings.Detail.NoIsNew
        isNew.textColor = .lightGray
        isNew.autoPinEdge(toSuperviewEdge: .top)
        isNew.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        isNew.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
    }
    
    private func configureTitle() {
        titleProduct.text = presenter?.response?.title
        titleProduct.textColor = .black
        titleProduct.autoPinEdge(.top, to: .bottom, of: isNew, withOffset: marginTop)
        titleProduct.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        titleProduct.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
    }
    
    private func configurePayment() {
        payment.text = Strings.General.payment
        payment.textColor = .black
        if(presenter?.response?.acceptsMercadopago == true) {
            payment.backgroundColor = .green
        } else {
            payment.backgroundColor = .lightGray
        }
        
        payment.autoPinEdge(.top, to: .bottom, of: titleProduct, withOffset: marginTop)
        payment.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        
        internationalPay.textColor = .black
        if(presenter?.response?.internationalDeliveryMode == "none") {
            internationalPay.backgroundColor = .lightGray
        } else {
            internationalPay.backgroundColor = .green
        }
        
        internationalPay.autoPinEdge(.top, to: .bottom, of: titleProduct, withOffset: marginTop)
        internationalPay.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
    }
    
    private func configureTotal() {
        guard let total = presenter?.response?.pictures?.count else { return }
        totalPicture.text = "1/\(String(describing: total))"
        totalPicture.textColor = .lightGray
        totalPicture.autoPinEdge(.top, to: .bottom, of: internationalPay, withOffset: marginTop)
        totalPicture.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        totalPicture.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
    }

    private func configurePictures() {
        carouselView?.autoPinEdge(.top, to: .bottom, of: totalPicture, withOffset: marginTop)
        carouselView?.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        carouselView?.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        carouselView?.autoSetDimension(.height, toSize: carouselHeight)
    }
    
    private func configurePrice() {
        guard let carouselView = carouselView else { return }
        priceView?.autoPinEdge(.top, to: .bottom, of: carouselView)
        priceView?.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        priceView?.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
    }
    
    private func configureSeller() {
        guard let priceView = priceView else { return }
        sellerView?.autoPinEdge(.top, to: .bottom, of: priceView, withOffset: marginTop)
        sellerView?.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        sellerView?.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
    }
    
    private func configureAttributes() {
        guard let sellerView = sellerView else { return }
        viewAttributes.autoPinEdge(.top, to: .bottom, of: sellerView, withOffset: marginTop)
        viewAttributes.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        viewAttributes.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        viewAttributes.addSubview(tableView ?? UIView())
        tableView?.autoPinEdge(toSuperviewEdge: .top, withInset: marginTop)
        tableView?.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        tableView?.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        tableView?.autoPinEdge(toSuperviewEdge: .bottom, withInset: marginBottom)
        tableView?.autoSetDimension(.height, toSize: tableHeight)
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            horizontalLayoutConstraints?.autoRemoveConstraints()
            verticalLayoutConstraints?.autoInstallConstraints()
        } else {
            verticalLayoutConstraints?.autoRemoveConstraints()
            horizontalLayoutConstraints?.autoInstallConstraints()
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}


extension DetailViewController: DetailViewProtocol {
    func showErrorResults() {
        let alert = Alerts.shared.simple(
            title: Strings.Search.AlertErrorTitle,
            message: Strings.Search.AlertErrorMessage) { _ in
                self.presenter?.back(navigation: self.navigationController!)
        }
        self.present(alert, animated: true)
    }
    
    func showEmptyResults() {
        let alert = Alerts.shared.simple(
            title: Strings.Search.AlertEmptyResultsTitle,
            message: Strings.Search.AlertEmptyResultsMessage) { _ in
                self.presenter?.back(navigation: self.navigationController!)
        }
        self.present(alert, animated: true)
    }
    
    func resultSuccess() {
        addSubviews()
        didSetupConstraints = false
        view.setNeedsUpdateConstraints()
    }
}
