//
//  MenuViewAnimator.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/21/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class MenuViewAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var duration = 1.0
    var isPresenting = true
    var snapshot : UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)
        
        let container = transitionContext.containerView
        
        let moveUp = CGAffineTransform(translationX: 0, y: -container.frame.height)
        
        if isPresenting {
            toView?.transform = moveUp
        } else {
            toView?.transform = CGAffineTransform.identity
        }
        
        container.addSubview(toView!)
    
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            
            if !self.isPresenting {
                toView?.transform = moveUp
            } else {
                toView?.transform = CGAffineTransform.identity
            }

            
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }

}
