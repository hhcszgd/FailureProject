//
//  DDPayDetailCollecCell.swift
//  Project
//
//  Created by 金曼立 on 2018/5/8.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPayDetailCollecCell: UICollectionViewCell {
    
    let tableView = UITableView()
    
    override init(frame:CGRect){
        super.init(frame: frame)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        contentView.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
