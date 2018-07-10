//
//  ProfileHeaderView.swift
//  Project
//
//  Created by wy on 2018/4/1.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    @IBOutlet var PriceLabel: UILabel!
    @IBOutlet var infolabel: UILabel!
    
    @IBOutlet var constraint1: NSLayoutConstraint!
    @IBOutlet var constraint2: NSLayoutConstraint!
    @IBOutlet var constraint3: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)?.last as! UIView
        self.addSubview(self.containerView)
        
        var scale: CGFloat = 1
        switch DDDevice.type {
        case .iPhone4:
            scale = 0.65
        case .iPhone5:
            scale = 0.7
        case .iPhone6:
            scale = 1
        case .iphoneX:
            scale = 1
        case .iPhone6p:
            scale = 1.1
        default:
            break
        }
        self.topConstraint.constant = DDnavigationStateHeight + 20 * scale
        self.congfigConstraint(scale: scale)
        self.layoutIfNeeded()
    }
    func congfigConstraint(scale: CGFloat) {
        self.constraint1.constant = 23 * scale
        self.constraint2.constant = 20 * scale
        self.constraint3.constant = 15 * scale
        
    }
    var containerView: UIView!
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
