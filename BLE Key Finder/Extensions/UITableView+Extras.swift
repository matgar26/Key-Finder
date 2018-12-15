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
    func standardSetup(owner: UITableViewOwner?, refreshAction: Selector) {
        delegate = owner
        dataSource = owner
        //        separatorColor = BambooTheme.instance.lightGrayColor
        tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = UIColor.white
        //        self.contentOffset = CGPoint(x:0, y:-refreshControl!.frame.size.height)  //someday Apple might fix this: https://stackoverflow.com/questions/19026351/ios-7-uirefreshcontrol-tintcolor-not-working-for-beginrefreshing
        refreshControl!.addTarget(owner, action: refreshAction, for: UIControl.Event.valueChanged)
    }
}
