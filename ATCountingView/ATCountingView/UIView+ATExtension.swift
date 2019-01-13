//
//  UIView+ATExtension.swift
//  ATCountingView
//
//  Created by ApesTalk on 2019/1/13.
//  Copyright © 2019年 https://github.com/ApesTalk All rights reserved.
//

import UIKit

extension UIView {
    func setAt_x(at_x:CGFloat) {
        var frame = self.frame
        frame.origin.x = at_x
        self.frame = frame;
    }
    
    func at_x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func setAt_y(at_y:CGFloat) {
        var frame = self.frame
        frame.origin.y = at_y
        self.frame = frame
    }
    
    func at_y() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setAt_w(at_w:CGFloat) {
        var frame = self.frame
        frame.size.width = at_w
        self.frame = frame
    }
    
    func at_w() -> CGFloat {
        return self.frame.size.width
    }
    
    func setAt_h(at_h:CGFloat) {
        var frame = self.frame
        frame.size.height = at_h
        self.frame = frame
    }
    
    func at_h() -> CGFloat {
        return self.frame.size.height
    }
    
    func setAt_size(at_size:CGSize) {
        var frame = self.frame
        frame.size = at_size
        self.frame = frame
    }
    
    func at_size() -> CGSize {
        return self.frame.size
    }
    
    func setAt_origin(at_origin:CGPoint) {
        var frame = self.frame
        frame.origin = at_origin
        self.frame = frame
    }
    
    func at_origin() -> CGPoint {
        return self.frame.origin
    }
}
