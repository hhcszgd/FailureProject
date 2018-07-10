//
//  DDConventionDetailSectionHeader.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit


class DDConventionDetailSectionHeader: UITableViewHeaderFooterView {
    let container = UIView()
    let label = UILabel()
//    let button = UIButton()
//    var model : (title : String ,value : String ,type : String )? {
    var model : DDAppointDetailSectionModel? {
        didSet{
            if let model = model   {
                label.text = model.title
//                button.setTitle(model.value, for: UIControlState.normal)
            }
            self.layoutIfNeeded()
        }
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.container.backgroundColor = .white
        self.contentView.addSubview(container)
        self.container.addSubview(label)
//        self.container.addSubview(button)
        
        label.textColor = UIColor.DDTitleColor
//        button.setTitleColor(UIColor.DDThemeColor, for: UIControlState.normal)
        //        .textColor = UIColor.DDThemeColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 20
        container.frame = CGRect(x: DDConventionVC.conventionVCMargin, y: 0, width: self.bounds.width - DDConventionVC.conventionVCMargin * 2, height: self.bounds.height)
        label.frame = CGRect(x: margin , y: 0, width: container.frame.width/2, height: container.frame.height)
//        button.ddSizeToFit()
//        let buttonW = button.bounds.width
//        button.frame = CGRect(x: container.frame.width - margin - buttonW , y: 0, width: buttonW, height: self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
