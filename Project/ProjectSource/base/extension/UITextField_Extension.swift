//
//  UITextField_Extension.swift
//  Project
//
//  Created by wy on 2018/6/5.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func configMoneyTextfield(string: String) -> Bool {
        //如果是删除按钮
        if string == "-" {
            GDAlertView.alert("报酬不能是负", image: nil, time: 1, complateBlock: nil)
            return false
        }
        
        if string == "" {
            
            
        }else {
            
            if let num = Float(string) {
                
            }else {
                GDAlertView.alert("请输入正确的报酬", image: nil, time: 1, complateBlock: nil)
                return false
            }
            
            let text = (self.text ?? "") + string
            if let num = Int(text) {
                if num < priceSmallLimit{
                    GDAlertView.alert("报酬不能小于1", image: nil, time: 1, complateBlock: nil)
                }
                if num > priceLimit {
                    GDAlertView.alert("报酬不能大于99999999", image: nil, time: 1, complateBlock: nil)
                }
                if num >= priceSmallLimit && num <= priceLimit {
                    return true
                }else {
                    return false
                }
            }
        }
        return true
    }
}
