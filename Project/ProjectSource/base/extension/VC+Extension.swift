//
//  VC+Extension.swift
//  Project
//
//  Created by WY on 2018/2/28.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
extension UIViewController {
    
    static var userInfo: Void?
    /** key parameter of viewController */
    @IBInspectable var userInfo: Any? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.userInfo)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.userInfo, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
