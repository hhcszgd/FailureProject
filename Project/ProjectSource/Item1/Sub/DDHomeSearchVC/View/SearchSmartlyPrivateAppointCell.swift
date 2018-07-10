//
//  SearchSmartlyPrivateAppointCell.swift
//  Project
//
//  Created by WY on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class SearchSmartlyPrivateAppointCell: SearchSmartlyBaseCell {
    let appointName = UILabel()
    let payerName = UILabel()
    override var model : DDAppointShrotModel?{
        didSet{
            appointName.text = model?.title
            payerName.text = "付款人:" + ( model?.aName ?? "")
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(appointName)
        self.contentView.addSubview(payerName)
        appointName.font = UIFont.systemFont(ofSize: 16)
        payerName.font = UIFont.systemFont(ofSize: 16)
        appointName.textColor = UIColor.DDSubTitleColor
        payerName.textColor = UIColor.DDSubTitleColor
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let labelH : CGFloat = self.bounds.height / 2
        appointName.frame = CGRect(x: margin * 2 , y: 0 , width: self.bounds.width - margin * 2, height: labelH)
        payerName.frame = CGRect(x: margin * 2 , y: labelH , width: self.bounds.width - margin * 2, height: labelH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
