//
//  AppDelegate.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/12/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var manager: DeviceTagManager? // Make singleton later?
    
    let keychain = Keychain(service: Constants.Keys.service)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let _ = keychain[Constants.Keys.hubId] {
            showMainApplication()
        } else {
            showLogin()
        }
        application.setMinimumBackgroundFetchInterval(900)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Base Window
    func showLogin(){
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let viewController = loginStoryboard.instantiateInitialViewController() {
            makeRootViewController(vc: viewController)
        }
    }
    
    func showMainApplication(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = mainStoryboard.instantiateInitialViewController() {
            makeRootViewController(vc: viewController)
        }
    }
    
    func makeRootViewController(vc: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = vc
    }
    
    func logout() {
        do{
            try keychain.remove(Constants.Keys.hubId)
//            Log.authentication.message("Successfully logged out")
        }catch{
//            Log.authentication.error(error)
        }
        showLogin()
    }

}

extension AppDelegate: DeviceTagManagerDelegate {
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .background {
            manager = DeviceTagManager.sharedInstance()
            manager?.delegate = self
            manager?.reset()
            manager?.startScan()
            completionHandler(.newData)
        }
    }
    
    func didManagerScanTags(_ tags: [DeviceTag]!) {
        // TODO: Add post to post tags here
        // Once background network request is successful
        manager?.stopScan()
        manager?.delegate = nil
        manager = nil
        
        let operation = TrackerDataOperation(devices: tags) { result in
            switch result {
            case .success: ()
            case .failure: ()
            }
        }
        operationQueue.addOperation(operation)
    }
    
}

