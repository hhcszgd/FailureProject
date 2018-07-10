//
//  DDHomeADCorver.swift
//  Project
//
//  Created by WY on 2018/5/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDHomeADCorver: DDCoverView {
    let imgButton = UIButton()
    let cancelButton = UIButton()
    var model  : (img:String , actionType : Int ) = (img:"" , actionType : -1 ){
        didSet{
            imgButton.setImageUrl(url:  model.img )
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    @discardableResult
    override init(superView: UIView ) {
        super.init(superView: superView)
        self.isHideWhenWhitespaceClick = false
        self.addSubview(imgButton)
        self.addSubview(cancelButton)
        imgButton.adjustsImageWhenHighlighted = false
        cancelButton.adjustsImageWhenHighlighted = false 
//        imgButton.backgroundColor = .orange
        imgButton.addTarget(self , action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)
        cancelButton.addTarget(self , action: #selector(buttonAction(sender:)), for: UIControlEvents.touchUpInside)
        cancelButton.setImage(UIImage(named:"closeAD"), for: UIControlState.normal)
    }
    @objc func buttonAction(sender : UIButton)  {
        if sender == self.imgButton{
            actionHandle?(1)
        }else if sender == self.cancelButton{
        }
        self.remove()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imgButton.bounds = CGRect(x: 0, y: 0, width: SCREENWIDTH - 44, height: SCREENWIDTH - 44)
        imgButton.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        cancelButton.bounds = CGRect(x: 0, y: 0, width: 44, height:  44)
        cancelButton.center = CGPoint(x: self.bounds.width/2, y: imgButton.frame.maxY + 24)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
