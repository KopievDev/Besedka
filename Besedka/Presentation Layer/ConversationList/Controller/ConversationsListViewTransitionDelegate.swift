//
//  ConversationsListViewTransitionDelegate.swift
//  Besedka
//
//  Created by Ivan Kopiev on 29.04.2021.
//

import UIKit

extension ConversationsListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleTransitionAnimator(fromView: self.view, isPresenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleTransitionAnimator(fromView: self.view, isPresenting: false)
    }
}
