//
//  AttributesView.swift
//  meli
//
//  Created by jonnattan Choque on 6/05/24.
//

import UIKit

class AttributesView: UIView {
    private let cellId: String = "CellID"
    private let divider = 2.0
    private let marginHorizontal: CGFloat = 12
    private let marginVertical: CGFloat = 10
    private let marginBottom: CGFloat = 50
    private var model: [Attributes] = []
    
    init(model: [Attributes]) {
        self.model = model
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var attributes: UILabel = {
        let label = UILabel()
        label.text = Strings.Detail.Attributes
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    func setupViews() {
        addSubview(attributes)
        addSubview(tableView)
        
        attributes.autoPinEdge(toSuperviewEdge: .top, withInset: marginVertical)
        attributes.autoPinEdge(toSuperviewEdge: .left, withInset: marginHorizontal)
        attributes.autoPinEdge(toSuperviewEdge: .right, withInset: marginHorizontal)
        
        tableView.autoPinEdge(.top, to: .bottom, of: attributes, withOffset: marginVertical)
        tableView.autoPinEdge(toSuperviewEdge: .left)
        tableView.autoPinEdge(toSuperviewEdge: .right)
        tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: marginBottom)
    }
}

extension AttributesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if cell == nil || cell?.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: FontSize.small.rawValue)
        cell?.textLabel?.text = model[indexPath.row].name
        
        cell?.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: FontSize.medium.rawValue)
        cell?.detailTextLabel?.text = model[indexPath.row].valueName
        return cell ?? UITableViewCell()
    }
}
