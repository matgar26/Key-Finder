//
//  ViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/12/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit

class KeyDetailViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var macAddressLabel: UILabel!
    
    // MARK: - Properties
    var device: DeviceTag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Key Details"
        // Do any additional setup after loading the view, typically from a nib.
        
        distanceLabel.text = device?.device.distance
        macAddressLabel.text = device?.device.stringValueFor(.macAddress)
    }

    @IBAction func ringTapped(_ sender: Any) {
        device?.device.sendInstruction(.search)
    }
}
