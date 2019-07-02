//
//  LoginViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/14/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var topAnchorConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleView()
    }
    
    private func styleView() {
        signInButton.layer.cornerRadius = 8
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.borderWidth = 2
        
        setGradientView()
    }
    
    private func setGradientView() {
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [Color.primaryGradient.cgColor, Color.primary.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if fieldsAreValid() {
            signIn()
        } else {
            AlertDisplay.showAlert(parent: self, title: "Complete All Fields", message: "Please complete all fields before continuing.")
        }
    }
    
    private func fieldsAreValid() -> Bool {
        if !phoneField.text.isNilOrEmpty{
            return true
        } else {
            return false
        }
    }
    
    func signIn() {
        signInButton.isHidden = true
        loadingIndicator.startAnimating()
        if let phone = phoneField.text {
            let operation = LoginOperation(userNumber: phone) { result in
                switch result {
                case .success(let data):
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.keychain[Constants.Keys.hubId] = data.hubId
                    appDelegate.showMainApplication()
                case .failure(let error):
                    self.signInButton.isHidden = false
                    self.loadingIndicator.stopAnimating()
                    AlertDisplay.showAlert(parent: self, title: error.title, message: error.message)
                }
            }
            operationQueue.addOperation(operation)
        }
    }
    
    // MARK: - Keyboard
    @objc func keyboardWillAppear() {
        animateViewUp(constant: -250)
    }
    
    @objc func keyboardWillDisappear() {
        animateViewUp(constant: 51)
    }
    
    private func animateViewUp(constant: CGFloat) {
        self.view.layoutIfNeeded()
        self.topAnchorConstraint.constant = constant
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
}
