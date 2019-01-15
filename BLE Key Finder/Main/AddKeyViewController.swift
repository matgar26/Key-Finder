//
//  AddKeyViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/17/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit

class AddKeyViewController: UIViewController, UITableViewOwner {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var scannedTags: [DeviceTag] = []
    private var edit = false
    private var manager: DeviceTagManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.standardSetup(owner: self, refreshAction: nil)
//        tableView.delegate = self
//        tableView.dataSource = self
        
        manager = DeviceTagManager.sharedInstance()
        manager?.delegate = self
        manager?.startScan()
    }
    
    @objc func refreshTable() {
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
}

extension AddKeyViewController: DeviceTagManagerDelegate {
    func didManagerScanTags(_ tags: [DeviceTag]!) {
        scannedTags = tags
        tableView.reloadData()
    }
}

extension AddKeyViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = scannedTags[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: AddKeyCell.reuseIdentifier, for: indexPath) as? AddKeyCell {
            cell.titleLabel?.text = tag.device.stringValueFor(.macAddress)
            cell.subTitleLabel?.text = "Distance: \(tag.device.distanceInFeet ?? "Not Found")"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - Table Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddKeyCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        manager?.stopScan()
        manager?.reset()
        let device = scannedTags[indexPath.row]
        
        manager?.bind(device, completion: { (success, device) in
            device?.device.sendInstruction(.search)
//            device?.device.sendInstruction(.cancelSearch)
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { // Change `2.0` to the desired number of seconds.
                self.manager?.unbind(device)
            }
        })
        
    }
}
