//
//  LoginOperation.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/24/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation
import Alamofire
import PSOperations

open class LoginOperation: PSOperation, ApiOperation {
    
    var completion: ((Swift.Result<AuthenticationInfo, NetworkError>) -> Void)
    var userNumber: String
    
    public init(userNumber: String, completion: @escaping ((Swift.Result<AuthenticationInfo, NetworkError>) -> Void)) {
        self.completion = completion
        self.userNumber = String(userNumber)
        super.init()
    }
    
    override open func execute() {
        ApiManager.shared.manager.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: fullHeaders)
            .responseDecodable { (dataResponse: DataResponse<AuthenticationInfo>) in
                switch dataResponse.result {
                case .success(let data):
                    if let _ = data.hubId {
//                        Log.services.message("Successfully Authenticated")
                        self.completion(.success(data))
                    } else {
//                        Log.services.message("Unsuccessfully Authenticated")
                        self.completion(.failure(NetworkError(title: "Incorrect Phone Number", message: "Please enter a valid phone number", code: dataResponse.response?.statusCode)))
                    }
                case .failure(let error):
//                    Log.services.error(error)
                    self.completion(.failure(NetworkError(title: "Something went wrong", message: "Please try again", code: dataResponse.response?.statusCode)))
                }
                self.finish()
        }
    }
    
    public var path: String {
        return "login"
    }
    
    public var parameters: [String : Any] {
        return ["phone_number": userNumber]
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
}
