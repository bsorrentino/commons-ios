//
//  ViewController.swift
//  Viewer
//
//  Created by softphone on 27/09/2016.
//  Copyright © 2016 soulsoftware. All rights reserved.
//

import UIKit


class MyTabBar : UITabBar {

    // MARK: FOCUS MANAGEMENT
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        
        let result = super.shouldUpdateFocus(in: context)

        print( "MyTabBar.shouldUpdateFocus ",
               "\n\tnextView \(context.nextFocusedView)",
               "\n\theading \(context.focusHeading)",
               "\n\tresult:\(result)"
        )
        
        return result;
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print( "MyTabBar.didUpdateFocus ",
               "\n\tnextView \(context.nextFocusedView)",
            "\n\theading \(context.focusHeading)"
        )
        
    }
    
    lazy var showConstraints:NSLayoutConstraint = {
        let h =  self.heightAnchor.constraint(equalToConstant: 140.0)
        h.priority = 1000
        return h
    }()
    
    lazy var hideConstraints:NSLayoutConstraint = {
        let h =  self.heightAnchor.constraint(equalToConstant: 1.0)
        h.priority = 1000
        return h
    }()
    
    func hide(animated:Bool) {
        
        self.showConstraints.isActive = false
        self.hideConstraints.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.5) { self.superview?.layoutIfNeeded() }
        }
        
        
    }
    
    func show(animated:Bool) {
        
        self.hideConstraints.isActive = false
        self.showConstraints.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.5) { self.superview?.layoutIfNeeded() }
        }
        
        
    }
    
    
}

class MyImageView : UIView {
  
    // MARK: FOCUS MANAGEMENT
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        
        let result = super.shouldUpdateFocus(in: context)
        
        print( "MyImageView.shouldUpdateFocus ",
               "\n\tnextView \(context.nextFocusedView)",
            "\n\theading \(context.focusHeading)",
            "\n\tresult:\(result)"
        )
        
        return result;
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print( "MyImageView.didUpdateFocus ",
               "\n\tnextView \(context.nextFocusedView)",
            "\n\theading \(context.focusHeading)"
        )
        
    }
    
}

class ViewController: UIViewController {

    @IBOutlet weak var tabBar: MyTabBar!

    @IBOutlet weak var imageView: MyImageView!
    
    private var _preferredFocusedView:UIView? {
        didSet {
            self.setNeedsFocusUpdate()
        }
    }
    
    override var preferredFocusedView: UIView? {
    
        if let focusedView = self._preferredFocusedView {
            return focusedView
        }
        
        return super.preferredFocusedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        _preferredFocusedView = imageView
        self.tabBar.hide(animated:false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:  GESTURE

    
    @IBAction func showTabBar(_ sender: UISwipeGestureRecognizer) {
    
        print( "SWIPE ",
               "\n\ttranslation:\(sender.location(in: self.view)) "
        )
        
    }
    
    @IBAction func showTabBarOnTap(_ sender: UITapGestureRecognizer) {
        print( "TAP ",
               "\n\ttranslation:\(sender.location(in: self.view)) "
        )
        
        let isVisible = self.tabBar.showConstraints.isActive
        
        if isVisible {
            self.tabBar.hide(animated: true)
        }
        else {
            self.tabBar.show(animated: true)
            _preferredFocusedView = tabBar
        }
    }
    
    // MARK: FOCUS MANAGEMENT
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        
        let result = super.shouldUpdateFocus(in: context)
        
        print( "shouldUpdateFocus ",
               "\n\tnextView \(context.nextFocusedView)",
            "\n\theading \(context.focusHeading)",
            "\n\tresult:\(result)"
        )
        
        if context.nextFocusedView == imageView {
            self.tabBar.hide(animated: true)
            self.updateViewConstraints()
        }
        
        return result;
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print( "didUpdateFocus ",
               "\n\tnextView \(context.nextFocusedView)",
               "\n\theading \(context.focusHeading)"
            )
        
    }

    
}

