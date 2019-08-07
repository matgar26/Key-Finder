//
//  TrackerDataOperation.swift
//  BLE Key Finder
//
//  Created by Jake Wagstaff on 6/14/19.
//  Copyright © 2019 Matt Gardner. All rights reserved.
//

import Foundation
import Alamofire
import PSOperations

open class TrackerDataOperation: PSOperation, ApiOperation {
    
    var completion: ((Swift.Result<Any?, NetworkError>) -> Void)
    var nodes: [[String: Any]]
    
    public init(devices: [DeviceTag], completion: @escaping ((Swift.Result<Any?, NetworkError>) -> Void)) {
        self.completion = completion
        self.nodes = devices.map({ $0.deviceTagParameters() })
        super.init()
    }
    
    override open func execute() {
        ApiManager.shared.manager.request(path, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: fullHeaders)
            .validate()
            .responseJSON { (dataResponse: DataResponse<Any>) in
                switch dataResponse.result {
                case .success( _):
                    self.completion(.success(nil))
                case .failure( _):
//                    Log.services.error(error)
                    self.completion(.failure(NetworkError(title: "Something went wrong", message: "Please try again", code: dataResponse.response?.statusCode)))
                }
                self.finish()
        }
    }
    
    public var path: String {
        return "http://52.226.109.139/echolo/data"
    }
    
    public var parameters: [String : Any] {
        return ["hubId": ApiManager.shared.hubId,
                "lat": UserManager.shared.currentLatitude,
                "long": UserManager.shared.currentLongitude,
                "nodes": nodes
                ]
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
}
