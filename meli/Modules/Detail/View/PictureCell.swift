//
//  PictureCell.swift
//  meli
//
//  Created by jonnattan Choque on 4/05/24.
//

import UIKit

class PictureCell: UICollectionViewCell {
    private let imageHeight: CGFloat = 150
    private let marginTop: CGFloat = 20
    private let radius: CGFloat = 10
    private let opacity: Float = 0.2
    
    lazy var imageProduct: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addDesign()
        addConstrains()
    }
    
    
    private func addViews() {
        addSubview(imageProduct)
    }
    
    private func addDesign() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = radius
    }
    
    private func addConstrains() {
        imageProduct.autoPinEdge(toSuperviewEdge: .top, withInset: marginTop)
        imageProduct.autoAlignAxis(toSuperviewAxis: .vertical)
        imageProduct.autoSetDimension(.height, toSize: imageHeight)
    }
    
    public func setup(imageUrl: String) {
        ImageDownloader.downloadImage(imageUrl) {
          image, urlString in
             if let imageObject = image {
                DispatchQueue.main.async {
                    self.imageProduct.image = imageObject
                }
             }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

