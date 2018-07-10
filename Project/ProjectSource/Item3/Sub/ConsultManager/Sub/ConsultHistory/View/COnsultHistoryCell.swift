//
//  COnsultHistoryCell.swift
//  Project
//
//  Created by wy on 2018/4/30.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class COnsultHistoryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    var model: ConsultModel? {
        didSet{
            self.nameLabel.text = model?.name
            self.contentLabel.text = model?.text
            self.reasonLabel.text = model?.reason
        }
    }
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var reasonLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
