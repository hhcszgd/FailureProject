//
//  UIScrollView+extension.swift
//  Project
//
//  Created by 金曼立 on 2018/5/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}
