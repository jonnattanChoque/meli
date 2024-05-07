//
//  ProductsCell.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import UIKit

class ProductsCell: UICollectionViewCell {
    let labelsHorintalMargin: CGFloat = 8
    let labelsTopMargin: CGFloat = 10
    let imageHeight: CGFloat = 100
    
    lazy var imageProduct: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: FontSize.small.rawValue)
        return label
    }()
    
    lazy var stock: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.boldSystemFont(ofSize: FontSize.medium.rawValue)
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.big.rawValue)
        return label
    }()
    
    lazy var payment: UILabel = {
        let label = UILabel()
        label.text = Strings.General.payment
        label.font = UIFont.systemFont(ofSize: FontSize.medium.rawValue)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addDesign()
        addConstrains()
    }
    
    
    private func addViews() {
        addSubview(imageProduct)
        addSubview(title)
        addSubview(stock)
        addSubview(price)
        addSubview(payment)
    }
    
    private func addDesign() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }
    
    private func addConstrains() {
        imageProduct.autoPinEdge(toSuperviewEdge: .top)
        imageProduct.autoAlignAxis(toSuperviewAxis: .vertical)
        imageProduct.autoSetDimension(.height, toSize: imageHeight)
        
        title.autoPinEdge(.top, to: .bottom, of: imageProduct, withOffset: labelsTopMargin)
        title.autoPinEdge(toSuperviewEdge: .left, withInset: labelsHorintalMargin)
        title.autoPinEdge(toSuperviewEdge: .right, withInset: labelsHorintalMargin)
        
        stock.autoPinEdge(.top, to: .bottom, of: title, withOffset: labelsTopMargin)
        stock.autoPinEdge(toSuperviewEdge: .left, withInset: labelsHorintalMargin)
        stock.autoPinEdge(toSuperviewEdge: .right, withInset: labelsHorintalMargin)
        
        price.autoPinEdge(.top, to: .bottom, of: stock, withOffset: labelsTopMargin)
        price.autoPinEdge(toSuperviewEdge: .left, withInset: labelsHorintalMargin)
        price.autoPinEdge(toSuperviewEdge: .right, withInset: labelsHorintalMargin)
        
        payment.autoPinEdge(.top, to: .bottom, of: price, withOffset: labelsTopMargin)
        payment.autoPinEdge(toSuperviewEdge: .left, withInset: labelsHorintalMargin)
    }
    
    public func setup(model: Result) {
        ImageDownloader.downloadImage(model.thumbnail) {
          image, urlString in
             if let imageObject = image {
                DispatchQueue.main.async {
                    self.imageProduct.image = imageObject
                }
             }
        }
        
        title.text = model.title
        stock.text = Strings.List.Stock.appending(String(model.availableQuantity))
        price.text = Format.currency(price: model.price)
        
        if(model.acceptsMercadopago) {
            payment.backgroundColor = .green
        } else {
            payment.backgroundColor = .lightGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
