//
//  PravicyAlert.swift
//  Project
//
//  Created by WY on 2018/6/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
class PrivacyAlert: DDCoverView  {
    let container = UIView()
    let title = UILabel()
    let accept = UIButton()
    let cancel = UIButton()
    let pravicy = UIButton()
    override init(superView : UIView) {
        super.init(superView:superView)
        self.addSubview(container)
        self.isHideWhenWhitespaceClick = false 
        container.addSubview(title)
        container.addSubview(accept)
        container.addSubview(cancel)
        container.addSubview(pravicy)
        title.textAlignment = .center
        title.text = "是否接受一把通隐私政策"
        container.backgroundColor = UIColor.white
//        pravicy.setImage(UIImage(named:"btn_icon"), for: UIControlState.normal)
//        pravicy.setImage(UIImage(named:"selected_btn_icon"), for: UIControlState.selected)
        let attributeTitle = ["点击查看  ","<< 隐私政策 >>"].setColor(colors: [UIColor.darkGray , UIColor.blue])
         pravicy.setAttributedTitle(attributeTitle, for: UIControlState.normal)
//        pravicy.setTitleColor(UIColor.blue, for: UIControlState.selected)
        cancel.backgroundColor = .red
        accept.backgroundColor = UIColor.DDThemeColor
        cancel.setTitle("拒绝", for: UIControlState.normal)
        accept.setTitle("接受", for: UIControlState.normal)
        
        pravicy.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        
        cancel.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        
        accept.addTarget(self , action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    @objc func buttonClick(sender:UIButton) {
        if sender == pravicy{
            self.actionHandle?("seePravicy")
//            self.remove()
//            sender.isSelected = !sender.isSelected
//            if sender.isSelected{
//                accept.isEnabled = false
//                accept.backgroundColor = UIColor.lightGray
//            }else{
//                accept.isEnabled = true
//                accept.backgroundColor = UIColor.DDThemeColor
//            }
        }else if sender == cancel{
            self.remove()
        }else if sender == accept{
            self.actionHandle?("accept")
            self.remove()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container.bounds = CGRect(x: 0, y: 0, width: self.bounds.width - 66, height: 150)
        container.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let rowH : CGFloat = 44
        let margin = (container.bounds.height - rowH * 3 ) / 4
        title.frame = CGRect(x: 0, y: margin, width: container.bounds.width, height: rowH)
        pravicy.bounds = CGRect(x: 0, y: 0, width: container.bounds.width, height: 44)
        pravicy.center =  CGPoint(x: container.bounds.width/2, y: title.frame.maxY + margin + rowH/2)
        let bottomButtonW: CGFloat = 88
        let leftMargin = (container.bounds.width - bottomButtonW * 2 ) / 3
        cancel.frame = CGRect(x: leftMargin, y: pravicy.center.y + rowH/2 + margin, width: bottomButtonW, height: rowH - 8)
        
        accept.frame = CGRect(x: cancel.frame.maxX + leftMargin, y: cancel.frame.minY, width: bottomButtonW, height: rowH - 8)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
