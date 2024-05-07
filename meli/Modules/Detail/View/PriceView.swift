//
//  PriceView.swift
//  meli
//
//  Created by jonnattan Choque on 6/05/24.
//

import UIKit

class PriceView: UIView {
    private let cellId: String = "CellID"
    private let divider = 2.0
    private let marginHorizontal: CGFloat = 12
    private let marginTop: CGFloat = 10
    private let marginBottom: CGFloat = 12
    private let corner: CGFloat = 10
    private let opacity: CGFloat = 0.2
    private var model: DetailModel?
    
    init(model: DetailModel) {
        self.model = model
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.big.rawValue)
        return label
    }()
    
    lazy var oldPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.medium.rawValue)
        label.numberOfLines = .zero
        return label
    }()
    
    lazy var stock: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: FontSize.medium.rawValue)
        return label
    }()
    
    lazy var warranty: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: FontSize.medium.rawValue)
        return label
    }()
    
    func setupViews() {
        self.backgroundColor = .lightGray.withAlphaComponent(opacity)
        self.layer.cornerRadius = corner
        
        let isOriginaPrice = model?.originalPrice != .zero
        self.addSubview(price)
        price.text = Format.currency(price: model?.price ?? .zero)
        price.autoPinEdge(toSuperviewEdge: .top, withInset: marginTop)
        price.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        price.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        if(isOriginaPrice) {
            self.addSubview(oldPrice)
            oldPrice.text = Format.currency(price: Double(model?.originalPrice ?? .zero))
            oldPrice.autoPinEdge(.top, to: .bottom, of: price, withOffset: marginTop)
            oldPrice.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
            oldPrice.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        }
        
        self.addSubview(stock)
        guard let quantity = model?.initialQuantity else { return }
        stock.text = "\(Strings.Detail.Stock)\(String(describing: quantity))"
        stock.autoPinEdge(.top, to: .bottom, of: isOriginaPrice ? oldPrice : price, withOffset: marginTop)
        stock.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        stock.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        self.addSubview(warranty)
        warranty.text = model?.warranty
        warranty.autoPinEdge(.top, to: .bottom, of: stock, withOffset: marginTop)
        warranty.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        warranty.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        warranty.autoPinEdge(toSuperviewEdge: .bottom, withInset: marginBottom)
    }
}
