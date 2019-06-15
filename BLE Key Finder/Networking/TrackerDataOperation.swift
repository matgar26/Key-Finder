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
    
    var completion: ((Swift.Result<AuthenticationInfo, NetworkError>) -> Void)
    var userNumber: Int
    var nodes: [[String: Any]]
    
    public init(userNumber: Int, devices: [DeviceTag], completion: @escaping ((Swift.Result<AuthenticationInfo, NetworkError>) -> Void)) {
        self.completion = completion
        self.userNumber = userNumber
        self.nodes = devices.map({ $0.deviceTagParameters() })
        
        super.init()
    }
    
    override open func execute() {
        ApiManager.shared.manager.request(url, method: HTTPMethod.post, parameters: parameters, headers: fullHeaders)
            .validate()
            .responseDecodable { (dataResponse: DataResponse<AuthenticationInfo>) in
                switch dataResponse.result {
                case .success(let data):
                    if let _ = data.hubId {
                        Log.services.message("Successfully Authenticated")
                        self.completion(.success(data))
                    } else {
                        Log.services.message("Unsuccessfully Authenticated")
                        self.completion(.failure(NetworkError(title: "Incorrect Phone Number", message: "Please enter a valid phone number", code: dataResponse.response?.statusCode)))
                    }
                case .failure(let error):
                    Log.services.error(error)
                    self.completion(.failure(NetworkError(title: "Something went wrong", message: "Please try again", code: dataResponse.response?.statusCode)))
                }
                self.finish()
        }
    }
    
    public var path: String {
        return "data"
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
