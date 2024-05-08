//
//  SearchViewController.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit
import PureLayout

class SearchViewController: UIViewController {
    var presenter: SearchPresenterProtocol?
    var didSetupConstraints: Bool = false
    var textSelected: String = ""
    let logoTopMarginLandspace: CGFloat = 50
    let logoTopMargin: CGFloat = 120
    let logoHeight: CGFloat = 80
    let searchTopMargin: CGFloat = 50
    let searchHorintalMargin: CGFloat = 20
    let searchHeight: CGFloat = 50
    let buttonTopMargin: CGFloat = 50
    let buttonHorintalMargin: CGFloat = 100
    var horizontalLayoutConstraints: NSArray?
    var verticalLayoutConstraints: NSArray?
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constants.logo)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchTextField = {
        let textfield = UITextField()
        textfield.placeholder = Strings.Search.placeholder
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.keyboardType = UIKeyboardType.default
        textfield.returnKeyType = UIReturnKeyType.done
        textfield.clearButtonMode = UITextField.ViewMode.whileEditing
        textfield.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textfield.delegate = self
        textfield.accessibilityIdentifier = "searchTextField"
        return textfield
    }()
    
    lazy var buttonSearch = {
        let button = UIButton()
        button.setTitle(Strings.Search.button, for: UIControl.State())
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(named: Constants.primaryColor)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        button.accessibilityIdentifier = "buttonSearch"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        addSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            horizontalLayoutConstraints = NSLayoutConstraint.autoCreateAndInstallConstraints {
                logo.autoPinEdge(toSuperviewEdge: .top, withInset: logoTopMargin)
            } as NSArray?
            
            verticalLayoutConstraints = NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
                logo.autoPinEdge(toSuperviewEdge: .top, withInset: logoTopMarginLandspace)
            } as NSArray?

            logo.autoAlignAxis(toSuperviewAxis: .vertical)
            logo.autoSetDimension(.height, toSize: logoHeight)
            
            searchTextField.autoPinEdge(.top, to: .bottom, of: logo, withOffset: searchTopMargin)
            searchTextField.autoPinEdge(toSuperviewMargin: .left)
            searchTextField.autoPinEdge(toSuperviewMargin: .right)
            searchTextField.autoSetDimension(.height, toSize: searchHeight)
            
            buttonSearch.autoPinEdge(.top, to: .bottom, of: searchTextField, withOffset: buttonTopMargin)
            buttonSearch.autoPinEdge(toSuperviewMargin: .left, withInset: buttonHorintalMargin)
            buttonSearch.autoPinEdge(toSuperviewMargin: .right, withInset: buttonHorintalMargin)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
        rotated()
    }
    
    private func addSubviews() {
        view.addSubview(logo)
        view.addSubview(searchTextField)
        view.addSubview(buttonSearch)
        
        view.setNeedsUpdateConstraints()
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
    
    @objc func buttonPressed(_ sender: UIButton) {
        if(textSelected.count == .zero) {
            let alert = Alerts.shared.simple(title: Strings.Search.AlertEmptyTitle, message: Strings.Search.AlertEmptyMessage)
            self.present(alert, animated: true)
        } else {
            self.presenter?.search(text: textSelected)
            
            searchTextField.resignFirstResponder()
            let alert = Alerts.shared.search(title: Strings.Search.AlertLoadingTitle, message: Strings.Search.AlertLoadingMessage)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.length > .zero {
            textSelected = "\(textField.text!.dropLast())"
        } else {
            textSelected = "\(textField.text! + string)"
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: SearchViewProtocol{
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
    
    func resultSuccess() {
        searchTextField.text = ""
        textSelected = ""
        self.dismiss(animated: true)
        self.presenter?.showNextView(navigationController: navigationController!)
    }
}
