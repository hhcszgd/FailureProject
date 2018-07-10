//
//  DDConventionDetailCell.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit


class DDConventionDetailCell: DDTableViewCell {
    let container = UIView()
    let title = UILabel()
    let value = UILabel()
//    var model : DDAppointDetailCellModel?{
//        didSet{
//            if model == nil  {return}
//            title.text = model!.title
//            value.text = model!.value
//            self.setNeedsLayout()
//        }
//    }
    var model : DDAppointDetailCellModel?{
        didSet{
            
            if model == nil  {return}
            let margin : CGFloat = 20
            title.text = model!.title
            let titlewidth =  (model!.title ?? "").sizeSingleLine(font: title.font).width + 40
            value.text = model!.value
            container.snp.remakeConstraints { (make ) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
//            title.ddSizeToFit()
            let titleToLeftBorder : CGFloat = 25
            let leftWidth = SCREENWIDTH - margin * 2 - titleToLeftBorder - titlewidth
            value.snp.remakeConstraints { (make ) in
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.width.equalTo(leftWidth)
            }
            title.snp.remakeConstraints { (make ) in
                make.top.equalTo(value)
                make.bottom.equalTo(value)
                make.left.equalToSuperview().offset(titleToLeftBorder)
                make.width.equalTo(titlewidth)
            }
        }
    }
    //    var model = [String:String](){
    //        didSet{
    //            title.text = model["title"]
    //            value.text = model["value"]
    //            self.setNeedsLayout() 
    //        }
    //    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.container.backgroundColor = .white
        self.contentView.addSubview(container)
        self.container.addSubview(title)
        self.container.addSubview(value)
        title.textColor = UIColor.DDTitleColor
        value.textColor = UIColor.DDSubTitleColor
        value.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        let margin : CGFloat = 25
//        container.frame = CGRect(x: DDConventionVC.conventionVCMargin, y: 0, width: self.bounds.width - DDConventionVC.conventionVCMargin * 2, height: self.bounds.height)
//        title.ddSizeToFit()
//        value.ddSizeToFit()
//        title.frame = CGRect(x: margin, y: 0, width: title.bounds.width, height: self.bounds.height)
//        let leftWidth = self.bounds.width - margin * 4 - title.bounds.width
//        value.frame = CGRect(x:title.frame.maxX + margin, y: 0, width: leftWidth, height: self.bounds.height * 2)
//
        if model?.sign ?? "" == "0"{

            title.textColor = UIColor.colorWithHexStringSwift("#d0d0d0")
            value.textColor = UIColor.colorWithHexStringSwift("#d0d0d0")
        }
    }
}

