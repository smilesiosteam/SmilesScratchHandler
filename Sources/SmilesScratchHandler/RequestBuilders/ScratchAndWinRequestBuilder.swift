//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/09/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities

enum ScratchAndWinRequestBuilder {
    
    case getScratchAndWinData(request: ScratchAndWinRequest)
    
    var requestTimeOut: Int {
        return 20
    }
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getScratchAndWinData:
            return .POST
        }
    }
    func createRequest(baseUrl: String) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    var requestBody: Encodable? {
        switch self {
        case .getScratchAndWinData(let request):
            return request
        }
    }
    
    func getURL(baseUrl: String) -> String {
        return baseUrl + "order/scratch-and-win"
    }
}
