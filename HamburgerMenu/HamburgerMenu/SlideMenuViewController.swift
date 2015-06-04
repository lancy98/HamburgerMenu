//
//  SlideMenuViewController.swift
//  DynamicTrayDemo
//
//  Created by Lancy on 27/05/15.
//  Copyright (c) 2015 Lancy. All rights reserved.
//

import UIKit

protocol DynamicTrayMenuDataSource : class {
    func trayViewController() -> UIViewController
    func mainViewController() -> UIViewController
}

class SlideMenuViewController: UIViewController {
    
    weak var dataSource: DynamicTrayMenuDataSource? {
        didSet {
            if let inDataSource = dataSource {
                
                let mainVC = inDataSource.mainViewController()
                mainViewController = mainVC
                addViewController(mainVC, toView: view)
                view.sendSubviewToBack(mainVC.view)

                if let tView = trayView {
                    let trayVC = inDataSource.trayViewController()
                    trayViewController = trayVC
                    addViewController(trayVC, toView: trayView!)
                }
            }
        }
    }
    
    private var trayViewController: UIViewController?
    private var mainViewController: UIViewController?
    
    private var trayView: UIVisualEffectView?
    private var trayLeftEdgeConstraint: NSLayoutConstraint?
    
    private var animator: UIDynamicAnimator?
    
    private var gravity: UIGravityBehavior?
    private var attachment: UIAttachmentBehavior?
    
    private let widthFactor = CGFloat(0.4) // 40% width of the view
    private let minThresholdFactor = CGFloat(0.2)
    
    private var trayWidth: CGFloat {
        return CGFloat(view.frame.width * widthFactor);
    }
    
    private var isGravityRight = false
    
    // check if the hamburger menu is being showed
    var isShowingTray: Bool {
        return isGravityRight
    }
    
    func showTray() {
        tray(true)
    }
    
    func hideTray() {
        tray(false)
    }
    
    func updateMainViewController(viewController: UIViewController) {
        
        if let mainVC = mainViewController {
            mainVC.willMoveToParentViewController(nil)
            mainVC.view.removeFromSuperview()
            mainVC.removeFromParentViewController()
        }
        
        addViewController(viewController, toView: view)
    }
    
    private func tray(show: Bool) {
        let pushBehavior = UIPushBehavior(items: [trayView!], mode: .Instantaneous)
        pushBehavior.angle = show ? CGFloat(M_PI) : 0
        pushBehavior.magnitude = UI_USER_INTERFACE_IDIOM() == .Pad ? 1500 : 200
        
        isGravityRight = show
        upadateGravity(isGravityRight)
        
        animator!.addBehavior(pushBehavior);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpTrayView()
        setUpGestureRecognizers()
        
        animator = UIDynamicAnimator(referenceView: view)
        setUpBehaviors()
        
        if trayViewController == nil && dataSource != nil {
            let trayVC = dataSource!.trayViewController()
            trayViewController = trayVC
            addViewController(trayVC, toView: trayView!)
        }
    }
    
    private func addViewController(viewController: UIViewController, toView: UIView) {
        
        addChildViewController(viewController)
        viewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        toView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        
        toView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": viewController.view]))
        toView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view": viewController.view]))
    }
    
    
    private func setUpBehaviors() {
        
        // Collision behaviour
        let collisionBehavior = UICollisionBehavior(items: [trayView!])
        let rightInset = view.frame.width - trayWidth
        let edgeInset = UIEdgeInsetsMake(0, -trayWidth, 0, rightInset)
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundaryWithInsets(edgeInset)
        animator!.addBehavior(collisionBehavior)
        
        // Gravity behaviour
        gravity = UIGravityBehavior(items: [trayView!])
        animator!.addBehavior(gravity)
        upadateGravity(isGravityRight)
    }
    
    private func upadateGravity(isRight: Bool) {
        let angle = isRight ? 0 : M_PI
        gravity!.setAngle(CGFloat(angle), magnitude: 1.0)
    }
    
    private func setUpTrayView() {
        // Adding blur view
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        trayView = UIVisualEffectView(effect: blurEffect)
        trayView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(trayView!)
        
        // Add constraints to blur view
        view.addConstraint(NSLayoutConstraint(item: trayView!, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.4, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: trayView!, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: trayView!, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        trayLeftEdgeConstraint = NSLayoutConstraint(item: trayView!, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant:-trayWidth)
        view.addConstraint(trayLeftEdgeConstraint!)
        
        view.layoutIfNeeded()
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    private func setUpGestureRecognizers() {
        
        // Edge pan.
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("pan:"))
        edgePan.edges = .Left
        view.addGestureRecognizer(edgePan)
        
        // Pan.
        let pan = UIPanGestureRecognizer (target: self, action: Selector("pan:"))
        trayView!.addGestureRecognizer(pan)
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
            
        let currentPoint = gesture.locationInView(view)
        let xOnlyPoint = CGPointMake(currentPoint.x, view.center.y)
        
        switch(gesture.state) {
        case .Began:
            attachment = UIAttachmentBehavior(item: trayView!, attachedToAnchor: xOnlyPoint)
            animator!.addBehavior(attachment)
        case .Changed:
            attachment!.anchorPoint = xOnlyPoint
        case .Cancelled, .Ended:
            animator!.removeBehavior(attachment)
            attachment = nil
            
            let velocity = gesture.velocityInView(view)
            let velocityThreshold = CGFloat(500)
            
            if abs(velocity.x) > velocityThreshold {
                isGravityRight = velocity.x > 0
                upadateGravity(isGravityRight)
            } else {
                isGravityRight = (trayView!.frame.origin.x + trayView!.frame.width) > (view.frame.width * minThresholdFactor)
                upadateGravity(isGravityRight)
            }
        default:
            if attachment != nil {
                animator!.removeBehavior(attachment)
                attachment = nil
            }
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        animator!.removeAllBehaviors()
        
        if (trayView!.frame.origin.x + trayView!.frame.width) > (view.center.x * minThresholdFactor) {
            trayLeftEdgeConstraint?.constant = 0
            isGravityRight = true
        } else {
            trayLeftEdgeConstraint?.constant = -(size.width * widthFactor)
            isGravityRight = false
        }
        
        coordinator.animateAlongsideTransition({ context in
            self.view.layoutIfNeeded()
            }, completion: { context in
                self.setUpBehaviors()
        })
    }
    
}