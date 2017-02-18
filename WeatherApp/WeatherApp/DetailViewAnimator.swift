//
//  DetailViewAnimator.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/16/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class DetailViewAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)
        let detailView = presenting ? toView : transitionContext.view(forKey: .from)!
        let initialFrame = presenting ? originFrame : detailView!.frame
        let finalFrame = presenting ? detailView!.frame : originFrame
        let xScaleFactor = presenting ? initialFrame.width/finalFrame.width : finalFrame.width/initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height/finalFrame.height : finalFrame.height/initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,y: yScaleFactor)
        if presenting {
            detailView!.transform = scaleTransform
            detailView!.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            detailView!.clipsToBounds = true
        }
        if presenting {
            containerView.addSubview(toView!)
        } else {
            containerView.addSubview(detailView!)
        }
        containerView.bringSubview(toFront: detailView!)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [], animations: {
            detailView!.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            detailView!.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    

}
