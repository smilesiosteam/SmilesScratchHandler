//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 16/09/2023.
//

import Foundation

public class ScratchAndWinResponse: Codable {
    public let scratchAndWin: ScratchAndWin?
}

// MARK: - ScratchAndWin
public class ScratchAndWin: Codable {
    public let voucherCode, offerTitle, fullTitle: String?
    public let themeResources: ThemeResources?
}

// MARK: - ThemeResources
public class ThemeResources: Codable {
    
    public let title, subTitle, message, instruction: String?
    public let greetingText: String?
    public let giftImageURL, scratchImageURL: String?
    public let failureTitle, failureMessage, failureImageURL: String?

    enum CodingKeys: String, CodingKey {
        case title, subTitle, message, instruction, greetingText, failureTitle, failureMessage
        case giftImageURL = "giftImageUrl"
        case scratchImageURL = "scratchImageUrl"
        case failureImageURL = "failureImageUrl"
    }
    
}
