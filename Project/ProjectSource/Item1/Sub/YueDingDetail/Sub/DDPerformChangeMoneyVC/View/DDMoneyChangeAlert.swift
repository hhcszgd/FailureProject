//
//  DDMoneyChangeAlert.swift
//  Project
//
//  Created by 金曼立 on 2018/5/28.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit

protocol DDMoneyChangeAlertDelegate : NSObjectProtocol {
    func performAction(actionType: DDMoneyChangeAlert.MoneyChangeAlertActionType)
}

class DDMoneyChangeAlert: UIView {
    
    weak var delegate  : DDMoneyChangeAlertDelegate?
    
    enum MoneyChangeAlertActionType{
        // 取消
        case cancle
        // 确定
        case certain
    }
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    let txtField = UITextField()
    let unit = UILabel()
    let lineHor = UIView()
    let lineVer = UIView()
    let cancleBtn = UIButton()
    let certainBtn = UIButton()

    override init(frame: CGRect){
        super.init(frame: frame)
        self.frame = frame
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.colorWithRGB(red: 245, green: 245, blue: 245)
        
        let singleTap = UITapGestureRecognizer.init(target:self, action: #selector(handleSingleTap))
        self.addGestureRecognizer(singleTap)
        
        configSubviews()
    }
    
    @objc func handleSingleTap() {
        txtField.resignFirstResponder()
    }
    
    func configSubviews() {
        self.addSubview(titleLab)
        self.addSubview(messageLab)
        self.addSubview(txtField)
        self.addSubview(unit)
        self.addSubview(lineHor)
        self.addSubview(lineVer)
        self.addSubview(cancleBtn)
        self.addSubview(certainBtn)
        
        titleLab.textAlignment = NSTextAlignment.center
        titleLab.text = "修改报酬"
        messageLab.font = UIFont.systemFont(ofSize: 14)
        messageLab.numberOfLines = 0
        txtField.textAlignment = NSTextAlignment.center
        txtField.borderStyle = UITextBorderStyle.line
        txtField.font = UIFont.systemFont(ofSize: 14)
        txtField.keyboardType = UIKeyboardType.decimalPad
        unit.text = "元"
        unit.font = UIFont.systemFont(ofSize: 14)
        lineHor.backgroundColor = UIColor.colorWithRGB(red: 219, green: 219, blue: 223)
        lineVer.backgroundColor = UIColor.colorWithRGB(red: 219, green: 219, blue: 223)
        cancleBtn.setTitle("取消", for: UIControlState.normal)
        certainBtn.setTitle("修改", for: UIControlState.normal)
        cancleBtn.setTitleColor(color11, for: UIControlState.normal)
        certainBtn.setTitleColor(color11, for: UIControlState.normal)
        cancleBtn.addTarget(self, action: #selector(cancleBtnClick), for: UIControlEvents.touchUpInside)
        certainBtn.addTarget(self, action: #selector(certainBtnClick), for: UIControlEvents.touchUpInside)
        
        
        titleLab.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        txtField.snp.makeConstraints { (make) in
            make.top.equalTo(messageLab.snp.bottom).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        unit.snp.makeConstraints { (make) in
            make.left.equalTo(txtField.snp.right).offset(10)
            make.centerY.equalTo(txtField)
        }
        lineHor.snp.makeConstraints { (make) in
            make.top.equalTo(txtField.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        lineVer.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineHor.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        cancleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineHor.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalTo(lineVer.snp.left)
            make.bottom.equalToSuperview()
        }
        certainBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineHor.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalTo(lineVer.snp.right)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func cancleBtnClick() {
        self.delegate?.performAction(actionType: DDMoneyChangeAlert.MoneyChangeAlertActionType.cancle)
    }
    
    @objc func certainBtnClick() {
        self.delegate?.performAction(actionType: DDMoneyChangeAlert.MoneyChangeAlertActionType.certain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
