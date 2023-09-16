//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/09/2023.
//

import Foundation
import Combine
import SmilesUtilities
import NetworkingLayer

public class ScratchAndWinViewModel: NSObject {
    
    // MARK: - PROPERTIES -
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    public enum Input {
        case getScratchAndWinData
    }
    
    public enum Output {
        case fetchScratchAndWinDidSucceed(response: ScratchAndWinResponse)
        case fetchScratchAndWinDidFail(error: Error)
    }
    
}

// MARK: - VIEWMODELS BINDINGS -
extension ScratchAndWinViewModel {
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getScratchAndWinData:
                self?.getScratchAndWinData()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func getScratchAndWinData() {
        
        let scratchRequest = ScratchAndWinRequest()

        let service = ScratchAndWinRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl)

        service.getScratchAndWinDataService(request: scratchRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchScratchAndWinDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchScratchAndWinDidSucceed(response: response))
            }
        .store(in: &cancellables)
        
    }
    
}
