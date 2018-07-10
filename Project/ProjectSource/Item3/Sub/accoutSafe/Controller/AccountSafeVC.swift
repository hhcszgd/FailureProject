//
//  AccountSafeVC.swift
//  Project
//
//  Created by wy on 2018/4/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class AccountSafeVC: GDNormalVC {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.congfingbankcard()
        self.configpassword()
        self.configPayPassword()
        
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "账户安全")
        self.bankcard.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        self.password.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        self.payPassword.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let bankcard: DDRowView = DDRowView.init(frame: CGRect.zero)
    let password: DDRowView = DDRowView.init(frame: CGRect.zero)
    let payPassword: DDRowView = DDRowView.init(frame: CGRect.zero)
    let rowW: CGFloat = SCREENWIDTH - 30
    let rowH: CGFloat = 44
}
extension AccountSafeVC {
    @objc func clickAction(sender: DDRowView) {
        switch sender {
        case self.bankcard:
            //
            let bankCardVC = DDBankCardManageVC()
            self.navigationController?.pushViewController(bankCardVC, animated: true)
            mylog("银行卡管理")
        case self.password:
            self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC", userInfo: VCActionType.changeLoginPassword)
            mylog("修改登录密码")
        case self.payPassword:
            self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC", userInfo: VCActionType.changePayPassword)
            mylog("设置支付密码")
        default:
            break
        }
    }
    
    
    
    func congfingbankcard() {
        self.bankcard.frame = CGRect.init(x: 15, y: DDNavigationBarHeight + 15, width: rowW, height: rowH)
        self.bankcard.titleLabel.text = "银行卡管理"
        self.bankcard.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.bankcard.additionalImageView.isHidden = false
        self.view.addSubview(self.bankcard)
    }
    
    func configpassword() {
        self.password.frame = CGRect.init(x: 15, y: self.bankcard.max_Y + 1, width: rowW, height: rowH)
        self.password.titleLabel.text = "修改登录密码"
        self.password.additionalImageView.isHidden = false
        self.password.subTitleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
        self.password.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(self.password)
        
    }
    func configPayPassword() {
        self.payPassword.frame = CGRect.init(x: 15, y: self.password.max_Y + 1, width: rowW, height: rowH)
        self.payPassword.titleLabel.text = "设置支付密码"
        self.payPassword.additionalImageView.isHidden = false
        self.payPassword.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(self.payPassword)
        
    }
}
