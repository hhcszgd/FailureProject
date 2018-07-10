//
//  CommentDetailSectionFooter.swift
//  Project
//
//  Created by WY on 2017/12/24.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class CommentDetailSectionFooter: UITableViewHeaderFooterView {
    let huifu = UIButton()
    var model = ReplyMember()
    let bottomLine = UIView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = UIColor.randomColor()
        self.contentView.addSubview(huifu)
        huifu.setTitle("回复", for: UIControlState.normal)
        huifu.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        huifu.setTitleColor(UIColor.colorWithHexStringSwift("#aaaaaa"), for: UIControlState.normal)
        self.contentView.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor.colorWithHexStringSwift("#f2f2f2")

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomLineH : CGFloat = 2
        let margin : CGFloat = 10
        huifu.frame = CGRect(x: self.bounds.width - 100, y: 0, width: 80, height: self.bounds.height - bottomLineH)
        bottomLine.frame = CGRect(x: margin, y: huifu.frame.maxY - bottomLineH , width: self.bounds.width - margin * 2, height: bottomLineH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
