//
//  UIViewController+Extras.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/12/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func addLoadingView() {
        let loadingView = UIView()
        loadingView.tag = 12345
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.75
        loadingView.frame = self.view.bounds
        loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let indicator = UIActivityIndicatorView.init(style: .whiteLarge)
        indicator.center.x = loadingView.center.x
        indicator.center.y = loadingView.center.y
        loadingView.addSubview(indicator)
        
        self.view.addSubview(loadingView)
    }
    
    func removeLoadingView() {
        if let loadingView = self.view.viewWithTag(12345) {
            loadingView.removeFromSuperview()
        }
    }
}
