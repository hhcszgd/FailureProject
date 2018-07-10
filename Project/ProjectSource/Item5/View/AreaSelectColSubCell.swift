//
//  AreaSelectColSubCell.swift
//  Project
//
//  Created by wy on 2018/1/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AreaSelectColSubCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    @IBOutlet var areaLabel: UILabel!
    
    var model: AreaModel? {
        didSet{
            if let myModel: AreaModel = model {
                self.areaLabel.text = myModel.NAME
//                if myModel.isSelected {
                    self.areaLabel.textColor = UIColor.colorWithHexStringSwift("ea9061")
                    self.contentView.backgroundColor = UIColor.white

//                }else {
//                    self.areaLabel.textColor = UIColor.colorWithHexStringSwift("333333")
//                    self.contentView.backgroundColor = lineColor
//                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
