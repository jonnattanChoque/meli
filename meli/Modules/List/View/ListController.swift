//
//  SearchViewController.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit
import PureLayout

class ListViewController: UIViewController {
    var presenter: ListPresenterProtocol?
    var model: SearchModel?
    var horizontalLayoutConstraints: NSArray?
    var verticalLayoutConstraints: NSArray?
    var didSetupConstraints: Bool = false
    let headerTopMargin: CGFloat = 100
    let headerTopMarginLandspace: CGFloat = 50
    let labelMargin: CGFloat = 10
    let cellId: String = "CellID"
    let duration = 0.1
    let alpha: CGFloat = 1
    let alphaAnimation: CGFloat = 0.5
    let divider = 2.0
    let cellLandscape = 0.7
    let cellPortrain = 1.5
    
    lazy var headerView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy var query: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy var total: UILabel = {
       let label = UILabel()
        return label
    }()
    
    lazy var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let tv = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.register(ProductsCell.self, forCellWithReuseIdentifier: cellId)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configNav()
        addSubviews()
        configInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            horizontalLayoutConstraints = NSLayoutConstraint.autoCreateAndInstallConstraints {
                headerView.autoPinEdge(toSuperviewEdge: .top, withInset: headerTopMargin)
            } as NSArray?
            
            verticalLayoutConstraints = NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
                headerView.autoPinEdge(toSuperviewEdge: .top, withInset: headerTopMarginLandspace)
            } as NSArray?
            
            
            headerView.autoPinEdge(toSuperviewMargin: .left)
            headerView.autoPinEdge(toSuperviewMargin: .right)
            
            query.autoPinEdge(toSuperviewEdge: .top, withInset: labelMargin)
            query.autoPinEdge(toSuperviewMargin: .left)
            query.autoPinEdge(toSuperviewEdge: .bottom, withInset: labelMargin)
            
            total.autoPinEdge(toSuperviewEdge: .top, withInset: labelMargin)
            total.autoPinEdge(toSuperviewMargin: .right)
            total.autoPinEdge(toSuperviewEdge: .bottom, withInset: labelMargin)
            
            collectionview.autoPinEdge(.top, to: .bottom, of: headerView, withOffset: labelMargin)
            collectionview.autoPinEdge(toSuperviewEdge: .bottom)
            collectionview.autoPinEdge(toSuperviewMargin: .left)
            collectionview.autoPinEdge(toSuperviewMargin: .right)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
        rotated()
    }
    
    private func configNav() {
        self.title = Strings.List.Title
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: Constants.primaryColor)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: Strings.List.Back, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        newBackButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(query)
        headerView.addSubview(total)
        
        view.addSubview(collectionview)
    }
    
    private func configInfo() {
        query.text = Strings.List.Search.appending(model?.query ?? "")
        total.text = Format.separator(number: model?.paging?.total ?? .zero).appending(Strings.List.Results)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
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
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.results.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProductsCell
        let model = model?.results[indexPath.row]
        cell.setup(model: model!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseInOut, animations: {
            cell?.alpha = self.alphaAnimation
        }, completion: { _ in
            cell?.alpha = self.alpha
            guard let model = self.model?.results[indexPath.row] else { return }
            self.presenter?.showDetail(navigationController: self.navigationController!, id: model.id)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? .zero) + (flowayout?.sectionInset.left ?? .zero) + (flowayout?.sectionInset.right ?? .zero)
            let size:CGFloat = (collectionview.frame.size.width - space) / divider
        return CGSize(width: size, height: size * (UIDevice.current.orientation.isLandscape ? cellLandscape : cellPortrain))
    }
}

extension ListViewController: ListViewProtocol{
    func showErrorResults() {
        self.dismiss(animated: true)
        let alert = Alerts.shared.simple(title: Strings.Search.AlertErrorTitle, message: Strings.Search.AlertErrorMessage)
        self.present(alert, animated: true)
    }
    
    func showEmptyResults() {
        self.dismiss(animated: true)
        let alert = Alerts.shared.simple(title: Strings.Search.AlertEmptyResultsTitle, message: Strings.Search.AlertEmptyResultsMessage)
        self.present(alert, animated: true)
    }
}
