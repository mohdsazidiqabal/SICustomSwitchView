//
//  SIAnimationHelper.swift
//  SICustomSwitch
//
//  Created by Mohd Sazid Iqabal on 01/05/20.
//  Copyright © 2020 Sazid. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class SIAnimationHelper: NSObject {
    init(animationDuration: CGFloat) {
        super.init()
        self.animationDuration = animationDuration
    }
    
    private var animationDuration: CGFloat = 0.0
    
    func moveAnimationWith(fromPosition: CGPoint, toPosition: CGPoint) -> CABasicAnimation? {
        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = NSValue(cgPoint: fromPosition)
        moveAnimation.toValue = NSValue(cgPoint: toPosition)
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        moveAnimation.duration = CFTimeInterval(animationDuration * 2 / 3)
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        return moveAnimation
    }
    
//    func backgroundColorAnimation(from fromValue: NSValue?, to toValue: NSValue?) -> CABasicAnimation? {
    func backgroundColorAnimation(from fromValue: CGColor?, to toValue: CGColor?) -> CABasicAnimation? {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = fromValue
        colorAnimation.toValue = toValue
        colorAnimation.duration = CFTimeInterval(animationDuration * 2 / 3)
        colorAnimation.isRemovedOnCompletion = false
        colorAnimation.fillMode = .forwards
        return colorAnimation
        
    }
    
    func eyeMoveAnimation(from fromValue: CGFloat?, to toValue: CGFloat?) -> CABasicAnimation? {
        let moveAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        moveAnimation.fromValue = fromValue
        moveAnimation.toValue = toValue
        moveAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        moveAnimation.duration = CFTimeInterval(animationDuration / 3)
        moveAnimation.isRemovedOnCompletion = false
        moveAnimation.fillMode = .forwards
        return moveAnimation
    }
    
    func mouthKeyFrameAnimationWidthOffSet(_ offSet: CGFloat, on: Bool) -> CAKeyframeAnimation? {
        let frameNumber: CGFloat = animationDuration * 60 / 3
        var frameValue = on ? offSet : 0
        var arrayFrame: [AnyHashable] = []
        for _ in 0..<Int(frameNumber) {
            if on {
                frameValue = frameValue - offSet / frameNumber
            } else {
                frameValue = frameValue + offSet / frameNumber
            }
            arrayFrame.append(NSNumber(value: Float(frameValue)))
        }
        let keyAnimation = CAKeyframeAnimation(keyPath: SIGlobalConstant.SIMouthAnimationKey)
        keyAnimation.values = arrayFrame
        keyAnimation.duration = CFTimeInterval(animationDuration / 4)
        if !on && animationDuration >= 1.0 {
            keyAnimation.beginTime = CFTimeInterval(CACurrentMediaTime() + Double(animationDuration / 12))
        }
        keyAnimation.isRemovedOnCompletion = false
        keyAnimation.fillMode = .forwards
        return keyAnimation
    }

    func eyesCloseAndOpenAnimation(with rect: CGRect) -> CAKeyframeAnimation? {
        let frameNumber: CGFloat = animationDuration * 180 / 9 // 180 frame erver second
        let eyesX = rect.origin.x
        var eyesY = rect.origin.y
        let eyesWidth = rect.size.width
        var eyesHeight = rect.size.height
        var arrayFrame: [AnyHashable] = []
        for i in 0..<Int(frameNumber) {
            if i < Int(frameNumber / 3) {
                // close
                eyesHeight = eyesHeight - rect.size.height / (frameNumber / 3)
            } else if i >= Int(frameNumber / 3) && i < Int(frameNumber * 2 / 3) {
                // zero
                eyesHeight = 0
            } else {
                // open
                eyesHeight = eyesHeight + rect.size.height / (frameNumber / 3)
            }
            eyesY = (rect.size.height - eyesHeight) / 2
            arrayFrame.append(NSValue(cgRect: CGRect(x: eyesX, y: eyesY, width: eyesWidth, height: eyesHeight)))
        }
        let keyAnimation = CAKeyframeAnimation(keyPath: SIGlobalConstant.SIMouthAnimationKey)
        keyAnimation.values = arrayFrame
        keyAnimation.duration = CFTimeInterval(animationDuration / 3)
        keyAnimation.isRemovedOnCompletion = false
        keyAnimation.fillMode = .forwards
        return keyAnimation
    }
    
}
