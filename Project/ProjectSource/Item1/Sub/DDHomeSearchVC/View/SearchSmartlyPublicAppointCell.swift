//
//  SearchSmartlyPublicAppointCell.swift
//  Project
//
//  Created by WY on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class SearchSmartlyPublicAppointCell: SearchSmartlyPrivateAppointCell {
    let require = UILabel()
    let area = UILabel()
    let money = UILabel()
    override var model : DDAppointShrotModel?{
        didSet{
            appointName.text = model?.title
            require.text = "约定要求: " + (model?.requirement ?? "")
            area.text = "工作区域: " + (model?.range ?? "")
            payerName.text = "付  款  人: " + (model?.aName ?? "")
            money.text = "合        计: " + (model?.price ?? "")
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(require)
        self.contentView.addSubview(area)
        self.contentView.addSubview(money)
        
        
        require.font = UIFont.systemFont(ofSize: 16)
        require.textColor = UIColor.DDSubTitleColor
        area.font = UIFont.systemFont(ofSize: 16)
        area.textColor = UIColor.DDSubTitleColor
        money.font = UIFont.systemFont(ofSize: 16)
        money.textColor = UIColor.DDSubTitleColor
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let labelH : CGFloat = (self.bounds.height - margin * 6 ) / 5
        appointName.frame = CGRect(x: margin * 2 , y: margin , width: self.bounds.width - margin * 2, height: labelH)
        require.frame = CGRect(x: margin * 2 , y: appointName.frame.maxY + margin , width: self.bounds.width - margin * 2, height: labelH)
        area.frame = CGRect(x: margin * 2 , y: require.frame.maxY + margin , width: self.bounds.width - margin * 2, height: labelH)
        payerName.frame = CGRect(x: margin * 2 , y:area.frame.maxY + margin, width: self.bounds.width - margin * 2, height: labelH)
        money.frame = CGRect(x: margin * 2 , y: payerName.frame.maxY  + margin , width: self.bounds.width - margin * 2, height: labelH)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
