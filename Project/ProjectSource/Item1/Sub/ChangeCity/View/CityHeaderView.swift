//
//  CityHeaderView.swift
//  zuidilao
//
//  Created by wy on 2017/11/10.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit

class CityHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(label)
        label.textColor = UIColor.colorWithHexStringSwift("333333")
        label.sizeToFit()
        return label
    }()
}
