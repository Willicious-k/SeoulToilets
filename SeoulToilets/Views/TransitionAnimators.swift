//
//  TransitionAnimators.swift
//  SeoulToilets
//
//  Created by 김성종 on 2018. 6. 8..
//  Copyright © 2018년 Willicious-k. All rights reserved.
//

import UIKit
import Foundation

final class ToSearchAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  private let maskFrame: CGRect
  
  init(frame: CGRect) {
    maskFrame = frame
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.8
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to),
      let toSnapshot = toVC.view.snapshotView(afterScreenUpdates: true)
    else { return }
    
    let containerView = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)
    
    let maskView = UIView(frame: maskFrame)
    maskView.backgroundColor = UIColor.white
    toSnapshot.mask = maskView
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(toSnapshot)
    toVC.view.isHidden = true
    
    let initialFrame = transitionContext.initialFrame(for: fromVC).offsetBy(dx: fromVC.view.frame.width, dy: 0)
    toSnapshot.frame = initialFrame
    
    UIView.animate(
      withDuration: duration,
      delay: 0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 1.0,
      options: [],
      animations: {
        toSnapshot.frame = transitionContext.initialFrame(for: fromVC)
    },
      completion: { _ in
        toVC.view.isHidden = false
        toSnapshot.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
}

final class ReturnToMainAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  private let maskFrame: CGRect
  
  init(frame: CGRect) {
    maskFrame = frame
  }

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.8
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to),
      let fromSnapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
    else { return }
    
    let containerView = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)
    
    let maskView = UIView(frame: maskFrame)
    maskView.backgroundColor = UIColor.white
    fromSnapshot.mask = maskView
    
    containerView.insertSubview(toVC.view, at: 0)
    containerView.addSubview(fromSnapshot)
    fromVC.view.isHidden = true
    
    let lastFrame = transitionContext.initialFrame(for: fromVC).offsetBy(dx: fromVC.view.frame.width, dy: 0)
    
    UIView.animate(
      withDuration: duration,
      delay: 0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 1.0,
      options: [],
      animations: {
        fromSnapshot.frame = lastFrame
    },
      completion: { _ in
        fromVC.view.isHidden = false
        fromSnapshot.removeFromSuperview()
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
    
  }

}


