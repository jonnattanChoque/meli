//
//  Alerts.swift
//  meli
//
//  Created by jonnattan Choque on 2/05/24.
//

import Foundation
import UIKit

class Alerts {

    static var shared: Alerts = {
        let instance = Alerts()
        return instance
    }()
    
    private init() {}

    func simple(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.General.Alert.button, style: .default, handler: handler))
        
        return alert
    }
    
    func search(title: String, message: String) -> UIAlertController {
        let loadingFrame: CGRect = CGRect(x: 10, y: 5, width: 50, height: 50)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: loadingFrame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        return alert
    }
}
