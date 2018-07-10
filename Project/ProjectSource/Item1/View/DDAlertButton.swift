//
//  DDAlertButton.swift
//  Project
//
//  Created by WY on 2018/7/5.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAlertButton: UIButton {
    private let bottomLine = UIView()
    var isHiddenBottomLine = false {
        didSet{
            self.bottomLine.isHidden = isHiddenBottomLine
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor.colorWithHexStringSwift("3562c8")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomLine.frame = CGRect(x: 10, y: self.bounds.height - 0.8 , width: self.bounds.width - 20, height: 0.8)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
