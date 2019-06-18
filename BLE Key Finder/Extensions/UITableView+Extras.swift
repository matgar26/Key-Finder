//
//  UITableView+Extras.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/12/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation
import UIKit

public protocol UITableViewOwner: UITableViewDataSource, UITableViewDelegate {}

public extension UITableView {
    func standardSetup(owner: UITableViewOwner?, refreshAction: Selector?) {
        delegate = owner
        dataSource = owner
        tableFooterView = UIView()
        
        if let action = refreshAction {
            refreshControl = UIRefreshControl()
            refreshControl!.addTarget(owner, action: action, for: UIControl.Event.valueChanged)
        }
    }
}
