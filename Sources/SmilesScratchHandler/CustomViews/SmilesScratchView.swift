//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import UIKit

class SmilesScratchView: UIView {
    
    // MARK: - VIEWS -
    private var scratchCard = SmilesScratchCardOverlay()
    private var backgroundImageView = UIImageView()
    var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    var scratchImage: UIImage? {
        didSet {
            scratchCard.scratchImage = scratchImage
        }
    }
    var scratchDelegate: ScratchDelegate? {
        didSet {
            scratchCard.scratchDelegate = scratchDelegate
        }
    }
    
    // MARK: - LIFECYCLE METHODS -
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundImageView.contentMode = .scaleAspectFill
        self.addSubview(scratchCard)
        self.addSubview(backgroundImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scratchCard.frame = self.bounds
        backgroundImageView.frame = self.bounds
    }
    
}
