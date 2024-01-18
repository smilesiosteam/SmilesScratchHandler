//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import UIKit

protocol ScratchDelegate: AnyObject {
    func scratch(percentage value:Int)
}

class SmilesScratchCardOverlay: UIView {
    
    private var startPoint:CGPoint!
    private var endPoint:CGPoint!
    private var context:CGContext!
    private var co_ordinates = [(startPoint:CGPoint,endPoint:CGPoint)]()
    private var swiped = false
    weak var scratchDelegate: ScratchDelegate?
    var scratchImage: UIImage? {
        didSet {
            setupScratchImage()
        }
    }
    private var overlayImage:UIImage!
    
    func reset() {
        co_ordinates.removeAll()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        setupScratchImage()
    }
    
    func calculateUserScratchArea() {
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        
        // 1. Prepare a memory space where you write in RGBA data of the view
        var pixelData: [UInt8] = Array<UInt8>(repeating: 0, count: width * height * 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        // 2. Prepare a context with the RGB space you secured above
        guard let context = CGContext(data: &pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 4 * width, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return }
        
        // 3. Render the entire view into the context, thereby filling in the `pixelData` variable
        self.layer.render(in: context)
        let totalArea = width * height
        var transparentCount: Double = 0
        for x in 0 ..< width {
            for y in 0 ..< height {
                // 4. Get alpha component and see if it is zero.
                let alpha = pixelData[(y * width + x) * 4 + 3]
                if alpha == 0 {
                    transparentCount += 1
                }
            }
        }
        let percentage = Double(transparentCount / Double(totalArea)) * 100
        scratchDelegate?.scratch(percentage: Int(percentage))
        
    }
    
    private func setupScratchImage() {
        
        guard let image = scratchImage else { return }
        overlayImage = image
        overlayImage.draw(in: self.frame)
        context = UIGraphicsGetCurrentContext()
        for each in co_ordinates {
            self.drawLineFrom(fromPoint:each.startPoint , toPoint: each.endPoint)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.startPoint = touches.first?.location(in: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            co_ordinates.append((self.startPoint,self.startPoint))
            setNeedsDisplay()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endPoint = touches.first?.location(in: self)
        guard self.frame.contains(self.endPoint) else { return }
        swiped = true
        co_ordinates.append((self.startPoint,self.endPoint))
        self.startPoint = endPoint
        setNeedsDisplay()
        calculateUserScratchArea()
        
    }
    
    fileprivate func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        context.setLineWidth(45)
        context.move(to: fromPoint)
        context.setBlendMode(.clear)
        context.setLineCap(.round)
        context.addLine(to: toPoint)
        context.strokePath()
        
    }
}
