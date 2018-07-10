//
//  FCityHeaderView.swift
//  zuidilao
//
//  Created by wy on 2017/11/9.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit

class FCityHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.currentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
        }
        self.currentCity.snp.makeConstraints { (make) in
            make.left.equalTo(self.currentLabel.snp.right).offset(8)
            make.top.bottom.equalToSuperview()
        }
        self.lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        self.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var currentCity: UILabel = {
        let label = UILabel.init()
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.colorWithHexStringSwift("000000")
        label.sizeToFit()
        label.text = "北京"
        return label
    }()
    
    
    lazy var currentLabel: UILabel = {
        let label = UILabel.init()
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.colorWithHexStringSwift("010101")
        label.sizeToFit()
        label.text = "当前位置:"
        return label
    }()
    lazy var lineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = color3
        self.addSubview(view)
        
        return view
    }()
    

}
