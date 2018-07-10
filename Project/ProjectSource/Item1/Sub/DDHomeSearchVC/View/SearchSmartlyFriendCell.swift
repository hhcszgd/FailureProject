//
//  SearchSmartlyFriendCell.swift
//  Project
//
//  Created by WY on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class SearchSmartlyFriendCell: SearchSmartlyBaseCell {
    let name : UILabel = UILabel()
    let icon  = UIImageView()
    override var model : DDAppointShrotModel?{
        didSet{
            name.text = model?.nickname
            icon.setImageUrl(url: model?.head_images)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(name)
        self.contentView.addSubview(icon)
        
        name.font = UIFont.systemFont(ofSize: 16)
        name.textColor = UIColor.DDSubTitleColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        icon.frame = CGRect(x: margin * 2 , y: margin , width: self.bounds.height - margin * 2, height: self.bounds.height - margin * 2)
        name.frame = CGRect(x: icon.frame.maxX + margin , y: icon.frame.midY - 10, width: self.bounds.width - icon.frame.maxX - margin * 2, height: 20)
    }
    
}
