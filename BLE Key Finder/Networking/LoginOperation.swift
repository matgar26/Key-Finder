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
    
    var completion: ((AuthenticationInfo?,  String?, Int?) -> Void)?
    var userNumber: Int
    
    public init(userNumber: Int, completion: @escaping (AuthenticationInfo?, String?, Int?) -> Void) {
        self.completion = completion
        self.userNumber = userNumber
        super.init()
    }
    
    override open func execute() {
        AF.request(url, parameters: nil, headers: fullHeaders)
            .validate()
            .responseDecodable { (dataResponse: DataResponse<AuthenticationInfo>) in
                switch dataResponse.result {
                case .success(let data):
                    Log.services.message("Successfully Authenticated")
                    self.completion?(data, nil, dataResponse.response?.statusCode)
                case .failure(let error):
                    Log.services.error(error)
                    self.completion?(nil, error.localizedDescription, dataResponse.response?.statusCode)
                }
                self.finish()
        }
    }
    
    public var path: String {
        return "companies"
    }
    
    public var parameters: [String : Any] {
        return ["user_number": userNumber]
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
}
