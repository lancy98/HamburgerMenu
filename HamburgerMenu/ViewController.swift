//
//  ViewController.swift
//  HamburgerMenu
//
//  Created by Lancy on 26/05/15.
//  Copyright (c) 2015 Coder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DynamicTrayMenuDataSource {

    var slideMenuController: SlideMenuViewController?
    
    @IBOutlet var placeholderView: UIView!
    
    // Toggle the menu tray.
    @IBAction func toggleTray(sender: UIButton) {
        
        if slideMenuController!.isShowingTray {
            slideMenuController!.hideTray()
        } else {
            slideMenuController!.showTray()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideMenuController = SlideMenuViewController()
        addViewController(slideMenuController!, toView: placeholderView)
        slideMenuController!.dataSource = self
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    // adds view controller and fill the parent.
    private func addViewController(viewController: UIViewController, toView: UIView) {
        
        addChildViewController(viewController)
        viewController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        toView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        
        toView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options:
            NSLayoutFormatOptions(0), metrics: nil, views: ["view": viewController.view]))
        toView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options:
            NSLayoutFormatOptions(0), metrics: nil, views: ["view": viewController.view]))
    }
    
    //Mark: DynamicTrayMenuDataSource
    func mainViewController() -> UIViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("MainController") as! MainViewController
    }
    
    func trayViewController() -> UIViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("TableController") as! TableViewController
    }

}

