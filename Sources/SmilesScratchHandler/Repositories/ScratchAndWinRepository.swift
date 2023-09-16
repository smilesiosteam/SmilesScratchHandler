//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/09/2023.
//

import Foundation
import Combine
import NetworkingLayer

protocol ScratchAndWinServiceable {
    func getScratchAndWinDataService(request: ScratchAndWinRequest) -> AnyPublisher<ScratchAndWinResponse, NetworkError>
}

class ScratchAndWinRepository: ScratchAndWinServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
    }
    
    func getScratchAndWinDataService(request: ScratchAndWinRequest) -> AnyPublisher<ScratchAndWinResponse, NetworkError> {
        
        let endPoint = ScratchAndWinRequestBuilder.getScratchAndWinData(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl)
        return self.networkRequest.request(request)
        
    }
    
}
