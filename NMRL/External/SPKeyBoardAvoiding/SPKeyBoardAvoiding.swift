//
//  SPKeyBoardAvoiding.swift
//  NMRL
//
//  Created by Akhil Johny on 24/07/18.
//  Copyright © 2018 Akhil Johny. All rights reserved.
//


import UIKit

class SPKeyBoardAvoiding: UIScrollView, UIScrollViewDelegate {
    
    // Get a touched view which is contained by Scroll view.
    open override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        if view .isKind(of: UITextField.self) {
            let textField:UITextField = view as! UITextField
            self.isScrollEnabled = true
            var rect = textField.bounds
            rect = textField.convert(rect, to: self)
            var points:CGPoint = rect.origin
            points.x = 0
            points.y -= self.frame.size.height/2 - 140   // You can change the value by appropriate your comfortable on
            self.setContentOffset(points, animated: true)
        }
        return true
    }
}
