//
//  PayAlertView.swift
//  Project
//
//  Created by wy on 2018/6/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class PayAlertView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.colorWithRGB(red: 101, green: 147, blue: 248).cgColor
        self.layer.borderWidth = 1
        let titleLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("333333"), text: "是否放弃本次支付？返回后您可以从“约定”列表中点击约定继续付款")
        self.addSubview(titleLabel)
        titleLabel.sizeToFit()
        
        self.sureBtn.setTitle("确定", for: .normal)
        self.sureBtn.setTitleColor(UIColor.white, for: .normal)
        self.sureBtn.backgroundColor = UIColor.colorWithRGB(red: 101, green: 147, blue: 248)
        self.sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
        self.cancleBtn.setTitle("取消", for: .normal)
        self.cancleBtn.setTitleColor(UIColor.white, for: .normal)
        self.cancleBtn.backgroundColor = UIColor.colorWithRGB(red: 145, green: 179, blue: 257)
        self.cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.sureBtn)
        self.addSubview(self.cancleBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        titleLabel.numberOfLines = 0
        
        self.cancleBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.right.equalTo(self.sureBtn.snp.left).offset(-20)
            make.width.equalTo(self.sureBtn.snp.width)
        }
        self.sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancleBtn.snp.top)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(44)
        }
        
        self.backgroundColor = UIColor.white
        
        
    }
    let sureBtn = UIButton.init()
    let cancleBtn = UIButton.init()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
