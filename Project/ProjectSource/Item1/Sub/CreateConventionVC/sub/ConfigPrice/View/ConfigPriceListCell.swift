//
//  ConfigPriceListCell.swift
//  Project
//
//  Created by wy on 2018/4/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ConfigPriceListCell: DDPartnerListCell {
    let priceLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.sizeToFit()
        self.priceLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            
        }
    }
    override var model: DDUserModel? {
        didSet{
            if let price = model?.unitPrice {
                self.priceLabel.text = price + "元"
            }else {
                self.priceLabel.text = ""
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
