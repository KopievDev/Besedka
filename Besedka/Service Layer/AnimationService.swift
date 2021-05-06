//
//  AnimationService.swift
//  Besedka
//
//  Created by Ivan Kopiev on 28.04.2021.
//

import UIKit

protocol AnimationProtocol {
    func addShake(to view: UIView)
    func removeShake(from view: UIView)
}

class AnimationService: AnimationProtocol {
    func addShake(to view: UIView) {
        var animations = [CABasicAnimation]()
        
        let startPosition = view.layer.position
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.duration = 0.150
        positionAnimation.fromValue = startPosition
        positionAnimation.toValue = CGPoint(x: startPosition.x + 5, y: startPosition.y + 5)
        animations.append(positionAnimation)
        
        let positionAnimationDown = CABasicAnimation(keyPath: "position")
        positionAnimationDown.duration = 0.150
        positionAnimationDown.fromValue = CGPoint(x: startPosition.x + 5, y: startPosition.y + 5)
        positionAnimationDown.toValue = CGPoint(x: startPosition.x - 5, y: startPosition.y - 5)
        positionAnimationDown.beginTime = 0.15
        animations.append(positionAnimationDown)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat.pi / 20
        rotateAnimation.duration = 0.075
        rotateAnimation.autoreverses = true
        animations.append(rotateAnimation)
        
        let rotateAnimationLeft = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimationLeft.fromValue = 0
        rotateAnimationLeft.toValue = CGFloat.pi / -20
        rotateAnimationLeft.duration = 0.075
        rotateAnimationLeft.beginTime = 0.15
        rotateAnimationLeft.autoreverses = true
        animations.append(rotateAnimationLeft)
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.animations = animations
        group.repeatCount = .infinity
        view.layer.add(group, forKey: "group")
    }
    
    func removeShake(from view: UIView) {
        
        let fromAngle = view.layer.presentation()?.value(forKeyPath: "transform.rotation")
        let fromPosition = view.layer.presentation()?.value(forKeyPath: "position")
        var animations = [CABasicAnimation]()
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = fromAngle
        rotateAnimation.toValue = 0
        rotateAnimation.duration = 0.5
        animations.append(rotateAnimation)
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.duration = 0.5
        positionAnimation.fromValue = fromPosition
        positionAnimation.toValue = CGPoint(x: view.frame.midX, y: view.frame.midY)
        animations.append(positionAnimation)
        let group = CAAnimationGroup()
        
        group.duration = 0.5
        group.animations = animations
        view.layer.removeAllAnimations()
        view.layer.add(group, forKey: "goBack")
    }

}
