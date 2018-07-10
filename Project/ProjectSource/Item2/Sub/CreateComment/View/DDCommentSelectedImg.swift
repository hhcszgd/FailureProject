//
//  DDCommentSelectedImg.swift
//  Project
//
//  Created by WY on 2017/12/26.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCommentSelectedImg: UIButton {
    let delete = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsImageWhenHighlighted = false
        self.addSubview(delete)
        delete.adjustsImageWhenHighlighted = false
        delete.setImage(UIImage(named:"selected_for_icon"), for: UIControlState.normal)
//        delete.addTarget(self, action: #selector(performDelete(sender:)), for: UIControlEvents.touchUpInside)
    }
    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        self.delete.addTarget(target, action: action, for: controlEvents)
    }
//    @objc func performDelete(sender:UIButton) {

//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.delete.frame = CGRect(x: self.bounds.width - 30, y: 0, width: 30, height: 30)
    }
}
