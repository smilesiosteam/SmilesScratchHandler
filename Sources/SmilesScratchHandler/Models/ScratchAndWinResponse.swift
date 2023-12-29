//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/09/2023.
//

import Foundation

public class ScratchAndWinResponse: Codable {
    public let voucherCode, offerTitle, fullTitle, offerId, offerType, paymentType: String?
    public let showPopup, voucherWon: Bool?
    public let themeResources: ThemeResources?
}

// MARK: - ThemeResources
public class ThemeResources: Codable {
    
    public let title, subTitle, message, instruction: String?
    public let greetingText: String?
    public let giftImageURL, scratchImageURL: String?
    public let failureTitle, failureMessage, failureImageURL: String?
    public let freeVoucherButtonText, paidVoucherButtonText: String?

    enum CodingKeys: String, CodingKey {
        case title, subTitle, message, instruction, greetingText, failureTitle, failureMessage, freeVoucherButtonText, paidVoucherButtonText
        case giftImageURL = "giftImageUrl"
        case scratchImageURL = "scratchImageUrl"
        case failureImageURL = "failureImageUrl"
    }
    
}
