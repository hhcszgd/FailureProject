//
//  DDSearchBox.swift
//  Project
//
//  Created by 金曼立 on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
class DDSearchBox: UITextField {
    
    init(frame: CGRect, placeholder: String, fontPh: CGFloat) {
        super.init(frame: frame)
        let searchBoxEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15)
        self.frame = CGRect(x: searchBoxEdgeInset.left, y: searchBoxEdgeInset.top, width: frame.size.width - searchBoxEdgeInset.left - searchBoxEdgeInset.right, height: 30)
        self.backgroundColor = UIColor.white
        self.borderStyle = UITextBorderStyle.roundedRect
        let leftView = UIButton(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        leftView.setImage(UIImage(named: "search_icon"), for: UIControlState.normal)
        self.leftView = leftView
        self.leftViewMode = .always
        let str = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize:fontPh)])
        self.attributedPlaceholder = str
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDSearchBox {
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x += 5
        return iconRect
    }
}
