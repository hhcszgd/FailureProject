//
//  ConsultHistoryHeader.swift
//  Project
//
//  Created by wy on 2018/4/30.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ConsultHistoryHeader: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.myTitleLabel)
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.myTitleLabel.sizeToFit()
        self.myTitleLabel.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    var model: ConsultModel? {
        didSet{
            self.myTitleLabel.text = model?.create_date
        }
    }
    let myTitleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("999999"), text: "")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
