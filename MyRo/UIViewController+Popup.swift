//
//  UIViewController+Popup.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/24/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

private var popupKey = "UIViewControllerPopupKey"
private var fadeBackgroundKey = "UIViewControllerFadeBackgroundKey"

extension UIViewController {
    
    private var popupViewController: UIViewController! {
        get {
            return objc_getAssociatedObject(self, &popupKey) as? UIViewController
        }
        set {
            objc_setAssociatedObject(self, &popupKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private var fadeBackgroundView: UIView! {
        get {
           return objc_getAssociatedObject(self, &fadeBackgroundKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &fadeBackgroundKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func presentPopupViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard self.popupViewController == nil else { return }
        
        self.popupViewController = viewController
        self.popupViewController.view.autoresizesSubviews = false
        self.popupViewController.view.autoresizingMask = UIViewAutoresizing.None
        
        self.addChildViewController(viewController)
        
        let endFrame = self.getPopupFrame(forViewController: viewController)
        viewController.view.layer.shadowColor = UIColor.blackColor().CGColor
        viewController.view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        viewController.view.layer.shadowRadius = 5.0
        viewController.view.layer.shadowOpacity = 0.7
        viewController.view.layer.shadowPath = UIBezierPath(rect: viewController.view.layer.bounds).CGPath
        
        viewController.view.layer.cornerRadius = 5.0
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let fadeBackgroundView = UIVisualEffectView(effect: blurEffect)
        fadeBackgroundView.alpha = 0.0
        fadeBackgroundView.frame = UIScreen.mainScreen().bounds
        self.fadeBackgroundView = fadeBackgroundView
        self.view.addSubview(fadeBackgroundView)
        
        viewController.beginAppearanceTransition(true, animated: animated)
        
        if (animated) {
            var startFrame = CGRectMake(endFrame.origin.x, UIScreen.mainScreen().bounds.size.height + viewController.view.frame.size.height / 2.0, endFrame.size.width, endFrame.size.height)
            var startAlpha: CGFloat = 1.0
            let endAlpha: CGFloat = 1.0
            
            if (self.modalTransitionStyle == .CrossDissolve) {
                startFrame = endFrame
                startAlpha = 0.0
            }
            
            viewController.view.frame = startFrame
            viewController.view.alpha = startAlpha
            self.view.addSubview(viewController.view)
            
            UIView.animateWithDuration(0.5,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions.CurveEaseInOut,
                                       animations: {
                                        viewController.view.frame = endFrame
                                        viewController.view.alpha = endAlpha
                                        fadeBackgroundView.alpha = 1.0
                }, completion: { finished in
                    guard finished else { return }
                    self.popupViewController.didMoveToParentViewController(self)
                    self.popupViewController.endAppearanceTransition()
                    completion?()
            })
        } else {
            viewController.view.frame = endFrame
            self.view.addSubview(viewController.view)
            self.popupViewController.didMoveToParentViewController(self)
            self.popupViewController.endAppearanceTransition()
            completion?()
        }
    }
    
    public func dismissPopupViewController(animated animated: Bool, completion: (() -> Void)?) {
        let fadeBackgroundView = self.fadeBackgroundView
        self.popupViewController.willMoveToParentViewController(nil)
        
        self.popupViewController.beginAppearanceTransition(false, animated: animated)
        
        if (animated) {
            let startFrame = self.popupViewController.view.frame
            var endFrame = CGRectMake(startFrame.origin.x, UIScreen.mainScreen().bounds.size.height + startFrame.size.height / 2.0, startFrame.size.width, startFrame.size.height)
            
            var endAlpha: CGFloat = 1.0
            if (self.modalTransitionStyle == .CrossDissolve) {
                endFrame = startFrame
                endAlpha = 0.0
            }
            
            UIView.animateWithDuration(0.5,
                                       delay: 0.0,
                                       options: UIViewAnimationOptions.CurveEaseInOut,
                                       animations: {
                                        self.popupViewController.view.frame = endFrame
                                        self.popupViewController.view.alpha = endAlpha
                                        fadeBackgroundView.alpha = 0.0
                }, completion: { finished in
                    guard finished else { return }
                    
                    self.popupViewController.removeFromParentViewController()
                    self.popupViewController.endAppearanceTransition()
                    self.popupViewController.view.removeFromSuperview()
                    fadeBackgroundView.removeFromSuperview()
                    self.popupViewController = nil
                    completion?()
            })
        }
    }
    
    private func getPopupFrame(forViewController viewController: UIViewController) -> CGRect {
        let frame = viewController.view.frame
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        var x: CGFloat
        var y: CGFloat
        //if (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation)) {
            x = (screenWidth - frame.size.width) / 2.0
            y = (screenHeight - frame.size.height) / 2.0
        /*} else {
            x = (screenHeight - frame.size.width) / 2.0
            y = (screenWidth - frame.size.height) / 2.0
        }*/
        
        return CGRectMake(x, y, frame.size.width, frame.size.height)
    }
}
