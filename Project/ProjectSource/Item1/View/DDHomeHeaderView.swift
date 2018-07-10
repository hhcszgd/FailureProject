//
//  DDHomeHeaderView.swift
//  Project
//
//  Created by WY on 2018/4/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDHomeHeaderView: UIView {
    let actionContainer = UIView()
    let action1 = UIButton()
    let action2 = UIButton()
    let action3 = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configActions()
        self.backgroundColor = UIColor.DDThemeColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutActions()
    }
    
    /// switchShowStatus
    ///
    /// - Parameter scale: scale 0~1
    func switchStatus(scale:CGFloat) {
        self.actionContainer.alpha = scale
    }

    func layoutActions() {
        actionContainer.frame = CGRect(x: 0, y: 0, width: self.bounds.width , height: self.bounds.height)
        let virticalMargin : CGFloat = 0
        let leftMargin : CGFloat = 0
        let buttonMargin : CGFloat = 0
        let btnWH = (actionContainer.bounds.height - virticalMargin * 2 )
        let btnY = virticalMargin
        
        for (index,button)  in actionContainer.subviews.enumerated() {
            if let b = button as? UIButton{b.imageView?.contentMode = .scaleToFill}
            button.frame = CGRect(x: leftMargin + (CGFloat(index) * (btnWH + buttonMargin)), y: btnY, width: btnWH, height: btnWH)
        }
    }
    
    func configActions() {
        self.addSubview(actionContainer)
        actionContainer.alpha = 0
        actionContainer.backgroundColor = UIColor.clear
        actionContainer.addSubview(action1)
        actionContainer.addSubview(action2)
        actionContainer.addSubview(action3)
        action1.setImage(UIImage(named:"scan_icon_small"), for: UIControlState.normal)
        action2.setImage(UIImage(named:"convention_icon_small"), for: UIControlState.normal)
        action3.setImage(UIImage(named:"payment_icon_small"), for: UIControlState.normal)
    }
}
