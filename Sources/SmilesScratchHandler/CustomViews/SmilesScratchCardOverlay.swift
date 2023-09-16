//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import UIKit

protocol ScratchDelegate {
    func scratch(percentage value:Int)
}

class SmilesScratchCardOverlay: UIView {
    
    private var startPoint:CGPoint!
    private var endPoint:CGPoint!
    private var context:CGContext!
    private var co_ordinates = [(startPoint:CGPoint,endPoint:CGPoint)]()
    private var swiped = false
    var scratchDelegate: ScratchDelegate?
    var scratchImage: UIImage? {
        didSet {
            setupScratchImage()
        }
    }
    private var overlayImage:UIImage!
    
    func reset() {
        
        co_ordinates.removeAll()
        min_x = 1000
        max_x = 0
        min_y = 1000
        max_y = 0
        self.setNeedsDisplay()
        
    }
    
    
    private var min_x:Int = 1000
    private var max_x:Int = 0
    
    private var min_y:Int = 1000
    private var max_y:Int = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        calculateUserScratchArea()
        setupScratchImage()
    }
    
    fileprivate func calculateUserScratchArea() {
        
        
        // Area of rectange = Length * Width
        
        let scratchCardArea =  self.bounds.width*self.bounds.height
        
        let maxLengthOfScratchSurface = (max_y - min_y)
        let maxWidthOfScratchSurface = (max_x - min_x)
        
        let scratchedArea = maxWidthOfScratchSurface * maxLengthOfScratchSurface
        
        guard scratchedArea > 0 else {
            return
        }
        
        let scratchPercentage = ( CGFloat(scratchedArea) / CGFloat(scratchCardArea)  ) * 100
        
        //FIXME: MAKE ME STABLE
        if scratchPercentage < 95 {
            
            scratchDelegate?.scratch(percentage: Int(scratchPercentage))
            
        } else if scratchPercentage < 200  {
            
            scratchDelegate?.scratch(percentage: 100)
        }
        
    }
    
    private func setupScratchImage() {
        
        guard let image = scratchImage
        else {
            fatalError("PLEASE ADD ADD SCRATCH IMAGE")
        }
        
        overlayImage = image
        overlayImage.draw(in: self.frame)
        
        context = UIGraphicsGetCurrentContext()
        
        
        for each in co_ordinates {
            
            self.drawLineFrom(fromPoint:each.startPoint , toPoint: each.endPoint)
            
        }
        
    }
    
    fileprivate func storeStartCoordiante() {
        let temp_x = Int(self.startPoint.x)
        let temp_y = Int(self.startPoint.y)
        
        if temp_x<min_x {
            min_x = temp_x
        }
        
        if temp_y<min_y {
            min_y = temp_y
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.startPoint = touches.first?.location(in: self)
        
        storeStartCoordiante()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            co_ordinates.append((self.startPoint,self.startPoint))
            setNeedsDisplay()
        }
        
    }
    
    fileprivate func storeEndCoordinate() {
        let temp_x = Int(self.endPoint.x)
        let temp_y = Int(self.endPoint.y)
        
        if temp_x>max_x {
            max_x = temp_x
        }
        if temp_y>max_y {
            max_y = temp_y
        }
        
        if temp_x<min_x  {
            min_x = temp_x
        }
        if temp_y<min_y {
            min_y = temp_y
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endPoint = touches.first?.location(in: self)
        
        guard  self.frame.contains(self.endPoint)
        else {
            return
        }
        
        storeEndCoordinate()
        
        swiped = true
        co_ordinates.append((self.startPoint,self.endPoint))
        
        self.startPoint = endPoint
        
        setNeedsDisplay()
        
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
