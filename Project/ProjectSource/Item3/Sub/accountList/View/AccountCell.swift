//
//  AccountCell.swift
//  Project
//
//  Created by wy on 2018/1/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var money: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var subTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    var model: AccountListModel? {
        didSet{
            self.title.text = model?.conventionName
            self.time.text = model?.time
            self.subTime.text = model?.subTime
            self.money.text = model?.money
            self.money.textColor = UIColor.colorWithHexStringSwift("e60000")
            self.money.textColor = UIColor.colorWithHexStringSwift("5585f1")
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
