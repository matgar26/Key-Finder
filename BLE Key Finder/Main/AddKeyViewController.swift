//
//  AddKeyViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/17/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit
import PSOperations

class AddKeyViewController: UIViewController, UITableViewOwner, RingingViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var scannedTags: [DeviceTag] = []
    private var edit = false
    private var manager: DeviceTagManager?
    lazy var ringVC: RingingViewController = { [weak self] in
        return self?.storyboard?.instantiateViewController(withIdentifier: "RingingViewController") as! RingingViewController
    }()
    
    let delay = DelayOperation(interval: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.standardSetup(owner: self, refreshAction: nil)
        
        ringVC.providesPresentationContextTransitionStyle = true
        ringVC.definesPresentationContext = true
        ringVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        ringVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        ringVC.delegate = self

        manager = DeviceTagManager.sharedInstance()
        manager?.delegate = self
        manager?.reset()
        manager?.startScan()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
    func ringDevice(index: Int) {
        
        self.present(ringVC, animated: true, completion: nil)
        
        manager?.stopScan()
        
        let device = scannedTags[index]
        manager?.bind(device, completion: { (success, device) in
            self.ringVC.didConnectToDevice()
            device?.device.sendInstruction(.search)
            
            let completion = BlockOperation {
                self.endRingAndReset()
            }
            
            completion.addDependency(self.delay) // Wait until delayOperation is finished
            operationQueue.addOperations([self.delay, completion], waitUntilFinished: false)
        })
    }
    
    func endRingAndReset() {
        self.manager?.reset()
        ringVC.dismiss(animated: true, completion: nil)
    }
    
    func didEndRing() {
        if(delay.isExecuting) {
            delay.finish()
        } else { // If the manager has not yet finished binding
            endRingAndReset()
        }
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
        ringDevice(index: indexPath.row)
    }
}
