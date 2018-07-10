//
//  DDGetCashLimitVC.swift
//  Project
//
//  Created by WY on 2018/4/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDGetCashLimitVC: DDCoverView {
    var mobile : String?{
        didSet{
            var mobileUnwrap = mobile ?? ""
            
            if let temp = mobile{
                if temp.count == 11{
                    mobileUnwrap = temp
                    mobileUnwrap.replaceSubrange( mobile!.index(mobile!.startIndex, offsetBy: 3) ..< mobile!.index(mobile!.endIndex, offsetBy: -4) , with: "****")
                }
                
            }
            self.label.text = "您提现金额超过限额，请输入\(mobileUnwrap)收到的验证码"
        }
    }
    let container = UIView()
    let label = UILabel()
    let inputField = UITextField()
    let cancel = UIButton()
    let button = UIButton()
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(container)
        self.isHideWhenWhitespaceClick = false 
        container.addSubview(label)
        label.textColor = .lightGray
        label.numberOfLines = 2
        container.addSubview(inputField)
        container.addSubview(button)
        container.addSubview(cancel)
        button.addTarget(self , action: #selector(continueGetCash(sender:)), for: UIControlEvents.touchUpInside)
        button.setTitle("继续提现", for: UIControlState.normal)
        cancel.setTitle("取消", for: UIControlState.normal)
        button.backgroundColor = UIColor.DDThemeColor
        cancel.backgroundColor = UIColor.DDThemeColor
        cancel.addTarget(self , action: #selector(continueGetCash(sender:)), for: UIControlEvents.touchUpInside)
        container.backgroundColor = .white
        inputField.backgroundColor = UIColor.DDLightGray
        inputField.placeholder = "请输入验证码"
        
    }
    @objc func continueGetCash(sender:UIButton){
        if sender == self.button{
            //验证验证码
            DDRequestManager.share.checkAuthCode(type: ApiModel<String>.self, mobile: self.mobile ?? "", code: self.inputField.text ?? "", complate: { (model ) in
                if model?.status ?? 0 == 200 {
                    self.actionHandle?(self.inputField.text ?? "")
                    self.remove()
                }else{
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                }
            })
        }else if sender == self.cancel{
            self.remove()
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorderMargin : CGFloat = 20
        let containerW = self.bounds.width - toBorderMargin * 2
        let containerH = containerW * 0.7
        container.bounds = CGRect(x: 0, y: 0, width: containerW, height: containerH)
        container.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2 - container.bounds.height/3)
        cancel.frame = CGRect(x: containerW - 44, y: 0, width: 44, height: 44)
        label.frame  = CGRect(x: toBorderMargin, y: cancel.frame.maxY, width: containerW - toBorderMargin * 2 , height: 64)
        inputField.frame = CGRect(x: toBorderMargin, y: label.frame.maxY, width: containerW - toBorderMargin * 2 , height: 40)
        button.frame = CGRect(x: toBorderMargin * 4, y: containerH - 54, width: containerW - toBorderMargin * 8 , height: 40)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        mylog("death")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
