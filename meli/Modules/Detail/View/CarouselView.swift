//
//  CarouselView.swift
//  meli
//
//  Created by jonnattan Choque on 6/05/24.
//

import UIKit

class CarouselView: UIView {
    private let cellId: String = "CellID"
    private let divider = 2.0
    private let marginHorizontal: CGFloat = 12
    private let marginVertical: CGFloat = 10
    private let heightPicture: CGFloat = 200
    private let corner: CGFloat = 10
    private let opacity: CGFloat = 0.2
    private var model: [Picture] = []
    
    init(model: [Picture]) {
        self.model = model
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.register(PictureCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    func setupViews() {
        addSubview(collectionview)
        
        collectionview.autoPinEdge(toSuperviewEdge: .top, withInset: marginVertical)
        collectionview.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        collectionview.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        collectionview.autoSetDimension(.height, toSize: heightPicture)
        collectionview.autoPinEdge(toSuperviewEdge: .bottom, withInset: marginVertical)
    }
}

extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PictureCell
        let model = model[indexPath.row]
        cell.setup(imageUrl: model.secureURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? .zero) + (flowayout?.sectionInset.left ?? .zero) + (flowayout?.sectionInset.right ?? .zero)
            let size:CGFloat = (collectionview.frame.size.width - space) / divider
        return CGSize(width: size, height: size)
    }
}
