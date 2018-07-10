//
//  DDConventionTableFooter.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit


class DDConventionTableFooter: UIControl  {
    let label = UILabel()
//    var model : (title:String , type:String)?{
    
    var model : ApiModel<DDAppointDetailModel>?{
        didSet{
            label.text = model?.data?.status.or_jf
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.textColor = UIColor.DDThemeColor
        label.textAlignment = .center
        label.backgroundColor = .white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: DDConventionVC.conventionVCMargin, y: 0, width: self.bounds.width - DDConventionVC.conventionVCMargin * 2, height: self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

