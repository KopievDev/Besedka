//
//  CircleTransitionAnimator.swift
//  Besedka
//
//  Created by Ivan Kopiev on 29.04.2021.
//

import UIKit

class CircleTransitionAnimator: NSObject {
    
    let startView: UIView
    let isPresenting: Bool
    var duration: TimeInterval = 0.5
    
    init(fromView: UIView, isPresenting: Bool) {
        self.isPresenting = isPresenting
        self.startView = UIView(frame: CGRect(x: fromView.frame.maxX + 15, y: 0, width: 30, height: 30))
    }
    
    func present(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let presentedController = transitionContext.viewController(forKey: .to),
              let presentedView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        let finalFrame = transitionContext.finalFrame(for: presentedController)
        let startFrame = startView.convert(startView.bounds, to: containerView)
        let startFrameCenter = CGPoint(x: startFrame.midX, y: startFrame.midY)
        let circleView = createCircle(for: presentedView)
        
        containerView.addSubview(circleView)
        containerView.addSubview(presentedView)
        
//        containerView.subviews.forEach { view in
//            view.center = startButtonCenter
//            view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
//        }
        
        circleView.center = startFrameCenter
        circleView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        presentedView.center = startFrameCenter
        presentedView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        
        UIView.animate(withDuration: 0.5) {
            presentedView.transform = CGAffineTransform(scaleX: 1, y: 1)
            presentedView.frame = finalFrame
            circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
            circleView.center = presentedView.center
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }

    }
    
    func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    func createCircle(for view: UIView) -> UIView {
        let diametr = sqrt(view.bounds.width * view.bounds.width + view.bounds.height * view.bounds.height)
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: diametr, height: diametr))
        circleView.layer.cornerRadius = diametr / 2
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = view.backgroundColor
        return circleView
    }

}

extension CircleTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            present(using: transitionContext)
        } else {
            dismiss(using: transitionContext)
        }
    }
}
