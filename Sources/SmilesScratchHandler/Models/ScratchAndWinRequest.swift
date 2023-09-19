//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/09/2023.
//

import Foundation
import SmilesBaseMainRequestManager

class ScratchAndWinRequest: SmilesBaseMainRequest {
    
    var operationName = "/order/scratch-and-win"
    
    enum CodingKeys: String, CodingKey {
        case operationName
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(operationName, forKey: .operationName)
    }
    
}
