//
//  SICustomeSwitchView.swift
//  SICustomeSwitchView
//
//  Created by Mohd Sazid Iqabal on 01/05/20.
//  Copyright © 2020 Sazid. All rights reserved.
//

import UIKit


@objc protocol SICustomeSwitchViewDelegate {
    func didTap(_ siCustomeSwitchView: SICustomeSwitchView)
    func animationDidStop(for siCustomeSwitchView: SICustomeSwitchView)
    func valueDidChanged(_ siCustomeSwitchView: SICustomeSwitchView, on: Bool)
}





@IBDesignable
class SICustomeSwitchView: UIView {
    
    private var _onColor: UIColor? = UIColor.red
    private var _animationDuration: CGFloat = 0.0
    private var _on = false
    private var _faceColor: UIColor? = UIColor.green
    private var _offColor: UIColor? = UIColor.blue
    
    weak var delegate: SICustomeSwitchViewDelegate!
    private var paddingWidth: CGFloat = 0.0
    private var circleFaceRadius: CGFloat = 0.0
    private var moveDistance: CGFloat = 0.0
    private var animationManager: SIAnimationHelper?
    private var isAnimating = false
    private var faceLayerWidth: CGFloat = 0.0
    
    private var _eyesLayer: SIEyesPointLayer?
    private var _circleFaceLayer: CAShapeLayer?
    private var backgroundView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSetUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSetUpView()
    }
    
    func initSetUpView() {
        assert(frame.size.width >= frame.size.height, "switch width must be tall！")
        _onColor = UIColor(red: 10 / 255.0, green: 20 / 255.0, blue: 52 / 255.0, alpha: 1.0)
        _offColor = UIColor(red: 245 / 255.0, green: 152 / 255.0, blue: 66 / 255.0, alpha: 1.0)
        _faceColor = UIColor.white
        paddingWidth = frame.size.height * 0.1
        circleFaceRadius = (frame.size.height - 2 * paddingWidth) / 2
        _animationDuration = 1.2
        animationManager = SIAnimationHelper(animationDuration: _animationDuration)
        moveDistance = frame.size.width - paddingWidth * 2 - circleFaceRadius * 2
        _on = false
        isAnimating = false
        _backgroundView?.backgroundColor = _offColor
        circleFaceLayerInit?.fillColor = _faceColor?.cgColor
        faceLayerWidth = _circleFaceLayer!.frame.size.width
        //        eyesLayer?.setNeedsDisplay()
        eyesLayerInit?.setNeedsDisplay()
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapSwitch)))
    }
    
    
    @IBInspectable var setOnColor: UIColor? {
        get {
            return _onColor
        }
        set(onColor) {
            _onColor = onColor
            if _on {
                backgroundView?.backgroundColor = onColor
                _eyesLayer?.eyeColor = onColor
                _eyesLayer?.setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var setOffColor: UIColor? {
        get {
            return _offColor
        }
        set(offColor) {
            _offColor = offColor
            if !_on {
                backgroundView?.backgroundColor = offColor
                _eyesLayer?.eyeColor = offColor
                _eyesLayer?.setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var setFaceColor: UIColor? {
        get {
            return _faceColor
        }
        set(faceColor) {
            _faceColor = faceColor
            _circleFaceLayer?.fillColor = faceColor?.cgColor
        }
    }
    
    @IBInspectable var setAnimationDuration: CGFloat {
        get {
            return _animationDuration
        }
        set(animationDuration) {
            _animationDuration = animationDuration
            animationManager = SIAnimationHelper(animationDuration: _animationDuration)
        }
    }
    
    @IBInspectable var setStatusOn: Bool {
        get {
            return _on
        }
        set(on) {
            
            if (_on && on) || (!_on && !on) {
                return
            }
            _on = on
            if on {
                backgroundView?.layer.removeAllAnimations()
                backgroundView?.backgroundColor = _onColor
                _circleFaceLayer?.removeAllAnimations()
                _circleFaceLayer?.position = CGPoint(x: _circleFaceLayer!.position.x + moveDistance, y: _circleFaceLayer!.position.y)
                _eyesLayer?.eyeColor = _onColor
                _eyesLayer?.isLiking = true
                _eyesLayer?.mouthOffSet = _eyesLayer!.frame.size.width
                _eyesLayer?.needsDisplay()
            } else {
                backgroundView?.layer.removeAllAnimations()
                backgroundView?.backgroundColor = _offColor
                _circleFaceLayer?.removeAllAnimations()
                _circleFaceLayer?.position = CGPoint(x: _circleFaceLayer!.position.x - moveDistance, y: _circleFaceLayer!.position.y)
                _eyesLayer?.eyeColor = _offColor
                _eyesLayer?.isLiking = false
                _eyesLayer?.mouthOffSet = 20
                _eyesLayer?.needsDisplay()
            }
        }
    }
    
    
    
   
    
    
    
    func setOn(_ on: Bool, animated: Bool) {
        if (self._on && on) || (!self._on && !on) {
            return
        }
        if animated {
            handleTapSwitch()
        } else {
            setOn(on)
        }
    }
    
    func setOn(_ on: Bool) {
        
        if (self._on && on) || (!self._on && !on) {
            return
        }
        self._on = on
        if on {
            backgroundView?.layer.removeAllAnimations()
            backgroundView?.backgroundColor = _onColor
            _circleFaceLayer?.removeAllAnimations()
            _circleFaceLayer?.position = CGPoint(x: _circleFaceLayer!.position.x + moveDistance, y: _circleFaceLayer!.position.y)
            _eyesLayer?.eyeColor = _onColor
            _eyesLayer?.isLiking = true
            _eyesLayer?.mouthOffSet = _eyesLayer!.frame.size.width
            _eyesLayer?.needsDisplay()
        } else {
            backgroundView?.layer.removeAllAnimations()
            backgroundView?.backgroundColor = _offColor
            _circleFaceLayer?.removeAllAnimations()
            _circleFaceLayer?.position = CGPoint(x: _circleFaceLayer!.position.x - moveDistance, y: _circleFaceLayer!.position.y)
            _eyesLayer?.eyeColor = _offColor
            _eyesLayer?.isLiking = false
            _eyesLayer?.mouthOffSet = 20
            _eyesLayer?.needsDisplay()
        }
        
    }
    
    @objc func handleTapSwitch() {
        if isAnimating {
            return
        }
        isAnimating = true
        
        let moveAnimation = animationManager?.moveAnimationWith(fromPosition: _circleFaceLayer!.position, toPosition: _on ? CGPoint(x: _circleFaceLayer!.position.x - moveDistance, y: _circleFaceLayer!.position.y) : CGPoint(x: _circleFaceLayer!.position.x + moveDistance, y: _circleFaceLayer!.position.y))
        moveAnimation?.delegate = self
        if let moveAnimation = moveAnimation {
            _circleFaceLayer?.add(moveAnimation, forKey: SIGlobalConstant.SIFaceMovementAnimationKey)
        }
       
        let colorAnimation = animationManager?.backgroundColorAnimation(from: (_on ? _onColor : _offColor)?.cgColor, to: (_on ? _offColor : _onColor)?.cgColor)
        if let colorAnimation = colorAnimation {
            backgroundView?.layer.add(colorAnimation, forKey: SIGlobalConstant.SIBgColorAnimationKey)
        }
        let toValu = _on ? -faceLayerWidth : faceLayerWidth
        let rotationAnimation = animationManager?.eyeMoveAnimation(from: 0.0, to: toValu)
        rotationAnimation?.delegate = self
        if let rotationAnimation = rotationAnimation {
            _eyesLayer?.add(rotationAnimation, forKey: SIGlobalConstant.SIEyesMovementStartAnimationKey)
        }
        _circleFaceLayer?.masksToBounds = true
        if _on {
            eyesKeyFrameAnimationStart()
        }

        self.delegate.didTap(self)
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if anim == _eyesLayer?.animation(forKey: SIGlobalConstant.SIEyesMovementStartAnimationKey) {
                _eyesLayer?.eyeColor = _on ? _offColor : _onColor
                _eyesLayer?.isLiking = !_on
                backgroundView?.backgroundColor = _eyesLayer?.eyeColor
                _eyesLayer?.setNeedsDisplay()
                backgroundView?.setNeedsDisplay()
                let frmValu = _on ? faceLayerWidth : -faceLayerWidth
                let toVlue = _on ? -faceLayerWidth/6 : faceLayerWidth/6
                let rotationAnimation = animationManager?.eyeMoveAnimation(from: frmValu, to: toVlue)
                rotationAnimation?.delegate = self
                if let rotationAnimation = rotationAnimation {
                    _eyesLayer?.add(rotationAnimation, forKey: SIGlobalConstant.SIEyesMovementStopAnimationKey)
                }
                
                if !_on {
                    eyesKeyFrameAnimationStart()
                }
            }
            if anim == _eyesLayer?.animation(forKey: SIGlobalConstant.SIEyesMovementStopAnimationKey) {
                let frmValu = _on ? -faceLayerWidth/6 : faceLayerWidth/6
                let rotationAnimation = animationManager?.eyeMoveAnimation(from: frmValu, to: 0.0)
                rotationAnimation?.delegate = self
                if let rotationAnimation = rotationAnimation {
                    _eyesLayer?.add(rotationAnimation, forKey: SIGlobalConstant.SIEyesStopMomentAnimationKey)
                }
                
                if !_on {
                    let eyesKeyFrameAnimation = animationManager?.eyesCloseAndOpenAnimation(with: _eyesLayer!.eyeRect)
                    if let eyesKeyFrameAnimation = eyesKeyFrameAnimation {
                        _eyesLayer?.add(eyesKeyFrameAnimation, forKey: SIGlobalConstant.SIEyesCloseOpenMomentAnimationKey)
                    }
                }
            }
            if anim == _eyesLayer?.animation(forKey: SIGlobalConstant.SIEyesStopMomentAnimationKey) {
                _eyesLayer!.mouthOffSet = _on ? 20 : _eyesLayer!.frame.size.width
                _eyesLayer?.needsDisplay()
                if _on {
                    _circleFaceLayer?.position = CGPoint(x: _circleFaceLayer!.position.x - moveDistance, y: _circleFaceLayer!.position.y)
                    _on = false
                } else {
                    _circleFaceLayer?.position = CGPoint(x: _circleFaceLayer!.position.x + moveDistance, y: _circleFaceLayer!.position.y)
                    _on = true
                    
                }
                isAnimating = false
                self.delegate.animationDidStop(for: self)
                self.delegate.valueDidChanged(self, on: _on)
                
                _eyesLayer?.removeAllAnimations()
                _circleFaceLayer?.removeAllAnimations()
                backgroundView?.layer.removeAllAnimations()
            }
        }
    }
    
    private var _backgroundView: UIView? {
        if backgroundView == nil {
            backgroundView = UIView()
            backgroundView?.frame = bounds
            backgroundView?.layer.cornerRadius = frame.size.height / 2
            backgroundView?.layer.masksToBounds = true
            addSubview(backgroundView!)
        }
        return backgroundView
    }
    
    
    private var circleFaceLayerInit: CAShapeLayer? {
        if _circleFaceLayer == nil {
            _circleFaceLayer = CAShapeLayer()
            _circleFaceLayer?.frame = CGRect(x: paddingWidth, y: paddingWidth, width: circleFaceRadius * 2, height: circleFaceRadius * 2)
            let circlePath = UIBezierPath(ovalIn: _circleFaceLayer?.bounds ?? CGRect.zero)
            _circleFaceLayer?.path = circlePath.cgPath
            if let _circleFaceLayer = _circleFaceLayer {
                backgroundView?.layer.addSublayer(_circleFaceLayer)
            }
        }
        return _circleFaceLayer
    }
    
    
    private var eyesLayerInit: SIEyesPointLayer? {
        if _eyesLayer == nil {
            _eyesLayer = SIEyesPointLayer()
            _eyesLayer?.eyeRect = CGRect(x: 0, y: 0, width: faceLayerWidth / 6, height: _circleFaceLayer!.frame.size.height * 0.22)
            _eyesLayer?.eyeDistance = faceLayerWidth / 3
            _eyesLayer?.eyeColor = _offColor
            _eyesLayer?.isLiking = false
            _eyesLayer?.mouthY = _eyesLayer!.eyeRect.size.height * 7 / 4
            _eyesLayer?.mouthOffSet = 20
            _eyesLayer?.frame = CGRect(x: faceLayerWidth / 4, y: _circleFaceLayer!.frame.size.height * 0.28, width: faceLayerWidth / 2, height: _circleFaceLayer!.frame.size.height * 0.72)
            if let _eyesLayer = _eyesLayer {
                _circleFaceLayer?.addSublayer(_eyesLayer)
            }
        }
        return _eyesLayer
    }
    
    func eyesKeyFrameAnimationStart() {
        let keyAnimation = animationManager?.mouthKeyFrameAnimationWidthOffSet(_eyesLayer!.frame.size.width, on: _on)
        if let keyAnimation = keyAnimation {
            _eyesLayer?.add(keyAnimation, forKey: SIGlobalConstant.SIMouthFrameAnimationKey)
        }
    }
    
    deinit {
        delegate = nil
    }

}

extension SICustomeSwitchView:  CAAnimationDelegate {
    
}
