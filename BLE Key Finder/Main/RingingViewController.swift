//
//  RingingViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 1/14/19.
//  Copyright © 2019 Matt Gardner. All rights reserved.
//

import Foundation
import UIKit

protocol RingingViewControllerDelegate {
    func didEndRing()
}

class RingingViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    
    var delegate: RingingViewControllerDelegate? = nil
    // MARK: - Outlets
    
    // MARK: - Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalView.layer.cornerRadius = 10
        
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 2
    }
    
    func didConnectToDevice() {
        titleLabel.text = "Ringing"
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.didEndRing()
    }
    
    func resetUI(){
        titleLabel.text = "Connecting..."
    }
}
