//
//  SIEyesPointLayer.swift
//  SICustomSwitch
//
//  Created by Mohd Sazid Iqabal on 01/05/20.
//  Copyright © 2020 Sazid. All rights reserved.
//

import QuartzCore
import UIKit

class SIEyesPointLayer: CALayer {
    
    var eyeRect = CGRect.zero
    var eyeDistance: CGFloat = 0.0
    var eyeColor: UIColor?
    var isLiking = false
    var mouthOffSet: CGFloat = 0.0
    var mouthY: CGFloat = 0.0
    
    override init() {
        super.init()
        eyeRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        mouthOffSet = 0.0
    }
    
    
    init(layer: SIEyesPointLayer) {
        super.init(layer: layer)
        eyeRect = layer.eyeRect
        eyeDistance = layer.eyeDistance
        eyeColor = layer.eyeColor
        isLiking = layer.isLiking
        mouthOffSet = layer.mouthOffSet
        mouthY = layer.mouthY
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(in ctx: CGContext) {
        let bezierLeft = UIBezierPath(ovalIn: eyeRect)
        let bezierRight = UIBezierPath(ovalIn: CGRect(x: eyeDistance, y: eyeRect.origin.y, width: eyeRect.size.width, height: eyeRect.size.height))
        
        
        var bezierMouth = UIBezierPath()
        let mouthWidth: CGFloat = eyeRect.size.width + eyeDistance
        if isLiking {
            // funny mouth
            bezierMouth.move(to: CGPoint(x: 0, y: mouthY))
            bezierMouth.addCurve(to: CGPoint(x: mouthWidth, y: mouthY), controlPoint1: CGPoint(x: mouthWidth - mouthOffSet * 3 / 4, y: mouthY + mouthOffSet / 2), controlPoint2: CGPoint(x: mouthWidth - mouthOffSet / 4, y: mouthY + mouthOffSet / 2))
        } else {
            // boring mouth
            bezierMouth = UIBezierPath(rect: CGRect(x: 0, y: mouthY, width: mouthWidth, height: eyeRect.size.height / 4))
        }
        bezierMouth.close()
        ctx.addPath(bezierLeft.cgPath)
        ctx.addPath(bezierRight.cgPath)
        ctx.addPath(bezierMouth.cgPath)
        ctx.setFillColor(eyeColor!.cgColor)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.fillPath()
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key.isEqual(SIGlobalConstant.SIMouthAnimationKey) {
            return true
        }
        if key.isEqual(SIGlobalConstant.SIEyesRectAnimationKey) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
}
