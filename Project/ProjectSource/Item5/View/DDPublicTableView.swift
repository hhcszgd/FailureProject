//
//  DDPublicTableView.swift
//  Project
//
//  Created by 金曼立 on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
class DDPublicTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
//        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.separatorColor = UIColor.colorWithRGB(red: 204, green: 204, blue: 204)
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
