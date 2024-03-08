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
        case getScratchAndWinData(orderId: String, isVoucherScratched: Bool, paymentType: String? = nil)
    }
    
    public enum Output {
        case fetchScratchAndWinDidSucceed(response: ScratchAndWinResponse)
        case fetchScratchAndWinDidFail(error: NetworkError)
    }
    
}

// MARK: - VIEWMODELS BINDINGS -
extension ScratchAndWinViewModel {
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getScratchAndWinData(let orderId, let isVoucherScratched, let paymentType):
                self?.getScratchAndWinData(orderId: orderId, isVoucherScratched: isVoucherScratched, paymentType: paymentType)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func getScratchAndWinData(orderId: String, isVoucherScratched: Bool, paymentType: String?) {
        
        let scratchRequest = ScratchAndWinRequest(orderId: orderId, scratchForVoucher: isVoucherScratched, paymentType: paymentType)

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
