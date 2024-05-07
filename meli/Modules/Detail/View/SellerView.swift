//
//  SellerView.swift
//  meli
//
//  Created by jonnattan Choque on 6/05/24.
//

import UIKit

class SellerView: UIView {
    private var model: SellerModel?
    private var country: String = ""
    private let marginHorizontal: CGFloat = 12
    private let marginTop: CGFloat = 10
    private let marginBottom: CGFloat = 12
    private let corner: CGFloat = 10
    private let opacity: CGFloat = 0.2
    
    init(model: SellerModel, country: String) {
        self.model = model
        self.country = country
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleSeller: UILabel = {
        let label = UILabel()
        label.text = Strings.Detail.Seller
        label.font = UIFont.boldSystemFont(ofSize: FontSize.medium.rawValue)
        return label
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.medium.rawValue)
        label.numberOfLines = .zero
        return label
    }()
    
    lazy var city: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.small.rawValue)
        label.numberOfLines = .zero
        return label
    }()
    
    lazy var power: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: FontSize.medium.rawValue)
        return label
    }()
    
    lazy var salesCount: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: FontSize.medium.rawValue)
        return label
    }()
    
    
    private func setupViews() {
        self.backgroundColor = .lightGray.withAlphaComponent(opacity)
        self.layer.cornerRadius = corner
        
        guard let address = model?.address?.city,
        let powerSell = model?.sellerReputation?.powerSellerStatus,
        let total = model?.sellerReputation?.transactions?.total else { return }
        
        addSubview(titleSeller)
        titleSeller.autoPinEdge(toSuperviewEdge: .top, withInset: marginTop)
        titleSeller.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        titleSeller.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        addSubview(name)
        name.text = model?.nickname
        name.autoPinEdge(.top, to: .bottom, of: titleSeller, withOffset: marginTop)
        name.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        name.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        addSubview(city)
        city.text = "\(country) - \(String(describing: address))"
        city.autoPinEdge(.top, to: .bottom, of: name, withOffset: marginTop)
        city.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        city.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        addSubview(power)
        power.text = "\(Strings.Detail.Power) \(String(describing: powerSell))"
        power.autoPinEdge(.top, to: .bottom, of: city, withOffset: marginTop)
        power.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        power.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        addSubview(salesCount)
        salesCount.text = "\(Strings.Detail.Sales) \(String(describing: total))"
        salesCount.autoPinEdge(.top, to: .bottom, of: power, withOffset: marginTop)
        salesCount.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        salesCount.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        salesCount.autoPinEdge(toSuperviewEdge: .bottom, withInset: marginBottom)
    }
}
