//
//  APIManager.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/24/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation
import Alamofire
import PSOperations

public let operationQueue = PSOperationQueue()

public class ApiManager {
    
    public static let shared = ApiManager()
    
    let baseUrl = Constants.Urls.dev
    
    public var baseHeaders: HTTPHeaders {
        let acceptHeader = HTTPHeader(name: "Accept", value: "application/json")
        return [acceptHeader]
    }
}

public protocol ApiOperation {
    var path: String { get }
    var parameters: [String : Any] { get }
    var headers: HTTPHeaders? { get }
}

extension ApiOperation {
    var url: URLConvertible {
        return "\(ApiManager.shared.baseUrl)\(path)"
    }
    
    var fullHeaders: HTTPHeaders {
        var current = ApiManager.shared.baseHeaders
        
        if let safeHeaders = headers {
            safeHeaders.forEach { subHead in
                current.add(subHead)
            }
        }
        
        return current
    }
}

