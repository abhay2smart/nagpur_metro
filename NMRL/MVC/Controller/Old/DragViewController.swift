//
//  DragViewController.swift
//  NMRL
//
//  Created by Akhil Johny on 10/08/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//

import UIKit

class DragViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var slideUpView      : UIView!
    
    var SlideViewCenterY    = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.wasDragged(gestureRecognizer:)))
        slideUpView.addGestureRecognizer(gesture)
        slideUpView.isUserInteractionEnabled = true
        gesture.delegate = self
        SlideViewCenterY = slideUpView.center.y
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            print("Slide view center : \(slideUpView.center.y)")
            print(gestureRecognizer.view!.center.y)
            //            if(gestureRecognizer.view!.center.y < 555) {
            if(gestureRecognizer.view!.center.y < SlideViewCenterY) {
                //  print("UP")
                gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
                //  gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y: self.view.center.y + 200)
                //  SlideViewCenterY = gestureRecognizer.view!.center.y
                
            }else {
                //   print("Down")
                //gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y:  554)
                gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y:  gestureRecognizer.view!.center.y + translation.y)
                //gestureRecognizer.view!.center = CGPoint(x : gestureRecognizer.view!.center.x, y:  self.view.center.y + 400)
                //  SlideViewCenterY = gestureRecognizer.view!.center.y
            }
            gestureRecognizer.setTranslation(CGPoint(x : 0,y: 0), in: self.view)
        }
        if gestureRecognizer.state == .ended {
            if(gestureRecognizer.view!.center.y < SlideViewCenterY) {
                print("END UP")
                SlideViewCenterY = gestureRecognizer.view!.center.y
                slideUpView.frame.origin.y = self.view.frame.height - slideUpView.frame.height
            }else {
                print("END DOWN")
                SlideViewCenterY = gestureRecognizer.view!.center.y
                slideUpView.frame.origin.y = self.view.frame.height - 100
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
