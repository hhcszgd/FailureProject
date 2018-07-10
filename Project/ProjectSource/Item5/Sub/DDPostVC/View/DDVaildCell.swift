//
//  DDVaildCell.swift
//  Project
//
//  Created by 金曼立 on 2018/4/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
class DDVaildCell: DDTableViewCell {
    
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        label.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: frame.size.height)
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
