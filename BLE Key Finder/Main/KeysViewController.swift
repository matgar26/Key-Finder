//
//  KeysViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/17/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit

class KeysViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var bindedTags: NSMutableArray = []
    private var edit = false
    private var manager: DeviceTagManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        manager = DeviceTagManager.sharedInstance()
        
        refreshConnectedDevices()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshConnectedDevices()
    }
    
    private func refreshConnectedDevices() {
        bindedTags = manager?.bindTags ?? []
        tableView.reloadData()
    }
}

extension KeysViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bindedTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let device = bindedTags[indexPath.row] as? DeviceTag {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = device.device.stringValueFor(.macAddress)
            cell.detailTextLabel?.text = "Distance: \(device.device.distance ?? "Not Found")"
            
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Table Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller = storyboard?.instantiateViewController(withIdentifier: "KeyDetailViewController") as! KeyDetailViewController
        controller.device = bindedTags[indexPath.row] as? DeviceTag
        navigationController?.pushViewController(controller, animated: true)
    }
}


