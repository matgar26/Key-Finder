//
//  AddKeyViewController.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/17/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit
import PSOperations
import CoreLocation

class AddKeyViewController: UIViewController, UITableViewOwner, RingingViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var scannedTags: [DeviceTag] = []
    private var edit = false
    private var manager: DeviceTagManager?
    private let locationManager = CLLocationManager()
    private var didUpdateLocationFirstTime = false
    
    lazy var ringVC: RingingViewController = { [weak self] in
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "RingingViewController") as! RingingViewController
        
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.delegate = self
        return vc
    }()
    
    var didCancelBind = true
    
    let delay = DelayOperation(interval: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.standardSetup(owner: self, refreshAction: nil)
        manager = DeviceTagManager.sharedInstance()
        manager?.delegate = self
        manager?.reset()
        manager?.startScan()
        
        setupKeyUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
    }
    
    func ringDevice(index: Int) {
        self.present(ringVC, animated: true, completion: nil)
        manager?.stopScan()
        let device = scannedTags[index]
        didCancelBind = false
        
        manager?.bind(device, completion: { [weak self] (success, device) in
            if self?.didCancelBind == true { // If the user pressed the cancel button in the ringVC before the manager could bind the device
                self?.endRingAndReset()
            } else {
                self?.ringVC.didConnectToDevice()
                device?.device.sendInstruction(.search)
                
                let completion = BlockOperation {
                    self?.endRingAndReset()
                }
                
                if let weakSelf = self {
                    completion.addDependency(weakSelf.delay) // Wait until delayOperation is finished
                    operationQueue.addOperations([weakSelf.delay, completion], waitUntilFinished: false)
                }
            }
        })
    }
    
    func endRingAndReset() {
        didCancelBind = true
        self.manager?.reset()
        ringVC.dismiss(animated: true, completion: nil)
        ringVC.resetUI()
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

// MARK: - Updates devices every ten minutes

extension AddKeyViewController {
    
    private func setupKeyUpdates() {
        updateDevices()
        var _ = Timer.scheduledTimer(timeInterval: 600.0, target: self, selector: #selector(updateDevices), userInfo: nil, repeats: true)
    }
    
    @objc func updateDevices() {
        let operation = TrackerDataOperation(devices: scannedTags) { result in
            switch result {
            case .success: ()
            case .failure: () 
            }
        }
        operationQueue.addOperation(operation)
    }
    
}

extension AddKeyViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        UserManager.shared.currentLatitude = locValue.latitude
        UserManager.shared.currentLongitude = locValue.longitude
        if !didUpdateLocationFirstTime {
            updateDevices()
        }
        didUpdateLocationFirstTime = true
    }
    
}


