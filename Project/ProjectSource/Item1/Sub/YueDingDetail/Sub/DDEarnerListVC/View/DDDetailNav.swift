//
//  DDDetailNav.swift
//  Project
//
//  Created by 金曼立 on 2018/5/21.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
protocol DDDetailNavDelegate : NSObjectProtocol {
    func performAction()
}

class DDDetailNav: UIView {
    
    weak var delegate  : DDDetailNavDelegate?
    
    let margin: CGFloat = 10
    let searchContainer = UIView()
    let backIcon = UIButton()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.addSubview(searchContainer)
        searchContainer.addSubview(backIcon)
        searchContainer.addSubview(titleLabel)
        
        backIcon.setImage(UIImage(named:"back_icon"), for: UIControlState.normal)
        backIcon.setImage(UIImage(named:"back_icon"), for: UIControlState.highlighted)
        backIcon.addTarget(self, action: #selector(actionClick), for: UIControlEvents.touchUpInside)
        titleLabel.text = "报酬详情"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchContainer.frame =  CGRect(x: 0, y: 6, width: UIScreen.main.bounds.size.width, height: DDNavigationBarHeight)
        backIcon.frame =  CGRect(x: margin, y: DDStatusBarHeight, width: 30, height: 30)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc func actionClick() {
        self.delegate?.performAction()
    }
}
