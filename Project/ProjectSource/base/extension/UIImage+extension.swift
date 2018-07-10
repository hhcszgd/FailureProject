//
//  UIImage+extension.swift
//  zuidilao
//
//  Created by wy on 2017/10/23.
//  Copyright © 2017年 wy. All rights reserved.
//

import Foundation

extension UIImage {
    class func ImageWithColor(color: UIColor, frame: CGRect) -> UIImage? {
        var aframe = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(aframe)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
}
