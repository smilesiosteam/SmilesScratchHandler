//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/09/2023.
//

import Foundation
import SmilesBaseMainRequestManager

class ScratchAndWinRequest: SmilesBaseMainRequest {
    
    var orderId: String
    var scratchForVoucher: Bool
    var paymentType: String?
    
    init(orderId: String, scratchForVoucher: Bool, paymentType: String? = nil) {
        self.orderId = orderId
        self.scratchForVoucher = scratchForVoucher
        self.paymentType = paymentType
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    enum CodingKeys: String, CodingKey {
        case operationName, orderId, scratchForVoucher, paymentType
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(orderId, forKey: .orderId)
        try container.encodeIfPresent(scratchForVoucher, forKey: .scratchForVoucher)
        try container.encodeIfPresent(paymentType, forKey: .paymentType)
    }
    
}
