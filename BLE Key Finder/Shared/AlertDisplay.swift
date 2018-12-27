//
//  AlertDisplay.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/25/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation
import UIKit

public struct AlertDisplay {
    
    public static let saveFailureTitle = NSLocalizedString("Changes not saved :(", comment: "Alert title for changes not saved")
    public static let saveFailureMessage = NSLocalizedString("Sorry, something went wrong and your changes weren’t saved. We’re embarrassed to ask this, but could you try again in a minute?", comment: "Alert message for changes not saved")
    public static let downloadFailureTitle = NSLocalizedString("Loading failure...", comment: "Alert title for loading failure")
    public static let downloadFailureMessage = NSLocalizedString("Sorry, something went wrong and your data was not downloaded. We’re embarrassed to ask this, but could you try again in a minute?",comment: "Alert message for download failure")
    public static let okButtonTitle = NSLocalizedString("Ok", comment: "Ok")
    public static let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel")
    
    public static func showNavigationFailure(parent: UIViewController, link: String) {
        let title = NSLocalizedString("Navigation Failure", comment: "Title for: failed to open link in email message.")
        let message = NSLocalizedString("Failed to open webpage at: ", comment: "Message for: failed to open link in email message.")
        showAlert(parent: parent, title: title, message: "\(message) \(link)")
    }
    
    // Show the generic "changes not saved" alert if title and message aren't specified.
    // Otherwise show the given alert message.
    public static func showSaveFailure(parent: UIViewController, title: String? = nil, message: String? = nil, completion: ((Bool)->())? = nil) {
        let showTitle = stringWithDefault(text: title, defaultText: saveFailureTitle)
        let showMessage = stringWithDefault(text: message, defaultText: saveFailureMessage)
        showAlert(parent: parent, title: showTitle, message: showMessage, completion:completion)
    }
    
    public static func showDownloadFailure(parent: UIViewController, title: String? = nil, message: String? = nil, completion: ((Bool)->())? = nil) {
        let showTitle = stringWithDefault(text: title, defaultText: downloadFailureTitle)
        let showMessage = stringWithDefault(text: message, defaultText: downloadFailureMessage)
        showAlert(parent: parent, title: showTitle, message: showMessage, completion:completion)
    }
    
    public static func showAlert(parent: UIViewController, title: String, message: String, hasCancelAction: Bool = false, completion: ((Bool)->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButtonTitle,
                                      style: .default,
                                      handler: { alertAction in
                                        completion?(true)
        }))
        
        if hasCancelAction {
            alert.addAction(UIAlertAction(title: cancelButtonTitle,
                                          style: .cancel, handler: {alertAction in
                                            completion?(false)
            }))
        }
        
        parent.present(alert, animated: true, completion: { })
        
    }
    
    private static func stringWithDefault(text: String?, defaultText: String) -> String {
        if let result = text {
            return result
        }
        return defaultText
    }
}

