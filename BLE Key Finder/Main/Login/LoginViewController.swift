//
//  LoginViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/14/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var topAnchorConstraint: NSLayoutConstraint!
    
    
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
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = viewController
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
