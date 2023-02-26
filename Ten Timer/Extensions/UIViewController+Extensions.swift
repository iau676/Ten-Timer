//
//  UIViewController+Extensions.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 16.02.2023.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String ,errorMessage: String) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    func showAlert(title: String, errorMessage: String, completion: @escaping(Bool)-> Void) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: false, completion: nil)
            completion(true)
        }
        alert.addAction(actionOK)
        present(alert, animated: true)
    }

}
