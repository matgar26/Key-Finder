//
//  AddKeyViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/17/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit

class AddKeyViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var scannedDevices: [DeviceTag] = []
    private var edit = false
    private var manager: DeviceTagManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        manager = DeviceTagManager.sharedInstance()
        manager?.delegate = self
        manager?.startScan()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
}

extension AddKeyViewController: DeviceTagManagerDelegate {
    func didManagerScanTags(_ tags: [DeviceTag]!) {
        scannedDevices = tags
        tableView.reloadData()
    }
}

extension AddKeyViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let device = scannedDevices[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = device.device.stringValueFor(.macAddress)
        //        cell.detailTextLabel?.text = device.isConnected() ? String(format: "Distance: %.2fm", device.getValue(.distance)!.floatValue) : "Disconnected"
        cell.detailTextLabel?.text = "Distance: \(device.device.distance ?? "Not Found")"
        
        return cell
    }
    
    // MARK: - Table Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        manager?.stopScan()
        
        let device = scannedDevices[indexPath.row]
        
        let alreadyBinded = device.device.getValue(.bind)?.boolValue ?? false
        
        if alreadyBinded {
            //TODO
            return
        }
        
        // Alert to ask are you sure
        manager?.bind(device, completion: { (success, device) in
            self.navigationController?.popViewController(animated: true)
        })
        
    }
}
