//
//  SearchSmartlyBaseCell.swift
//  Project
//
//  Created by WY on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class SearchSmartlyBaseCell: UITableViewCell {
    var model : DDAppointShrotModel?
    let line  = UIView()
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(line)
        line.backgroundColor = UIColor.DDLightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let lineH : CGFloat = 2
        line.frame = CGRect(x: 0 , y: self.bounds.height - lineH , width: self.bounds.width, height: lineH)
    }
}
