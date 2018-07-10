//
//  CompanyInfoVC.swift
//  Project
//
//  Created by wy on 2018/4/5.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
let BACKCOLOR =  UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
class CompanyInfoVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.congfingCompanyName()
        self.configCompanyPhone()
    
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "公司信息")
        self.companyName.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        self.companyPhone.addTarget(self, action: #selector(clickAction(sender:)), for: .touchUpInside)
        let router = Router.get("Mttuserinfo/company", .api, ["token": token], nil)
        NetWork.manager.requestData(router: router, type: DDAccount.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                DDAccount.share.setPropertisOfShareBy(otherAccount: model.data)
                self.companyName.subTitle = model.data?.companyName
                self.companyPhone.subTitle = model.data?.companyPhone
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.companyPhone.subTitle = DDAccount.share.companyPhone
        self.companyName.subTitle = DDAccount.share.companyName
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let companyPhone: DDRowView = DDRowView.init(frame: CGRect.zero)
    let companyName: DDRowView = DDRowView.init(frame: CGRect.zero)
    let rowW: CGFloat = SCREENWIDTH - 30
    let rowH: CGFloat = 44
}
extension CompanyInfoVC {
    @objc func clickAction(sender: DDRowView) {
        switch sender {
        case self.companyName:
            //上传图片
            let name = NameVC()
            name.userInfo = VCActionType.changeCompanyName
            self.navigationController?.pushViewController(name, animated: true)
            mylog("上传图片")
        case self.companyPhone:
            let phone = NameVC()
            phone.userInfo = VCActionType.chageCompanyMobile
            self.navigationController?.pushViewController(phone, animated: true)
            mylog("设置用户信息")
        default:
            break
        }
    }
    
    
    
    func congfingCompanyName() {
        self.companyName.frame = CGRect.init(x: 15, y: DDNavigationBarHeight + 15, width: rowW, height: rowH)
        self.companyName.titleLabel.text = "公司名称"
        self.companyName.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.companyName.subTitle = "********"
        self.companyName.additionalImageView.isHidden = false
        self.view.addSubview(self.companyName)
    }
    
    func configCompanyPhone() {
        self.companyPhone.frame = CGRect.init(x: 15, y: self.companyName.max_Y + 1, width: rowW, height: rowH)
        self.companyPhone.titleLabel.text = "公司电话"
        self.companyPhone.additionalImageView.isHidden = false
        self.companyPhone.subTitleLabel.textColor = UIColor.colorWithHexStringSwift("333333")
        self.companyPhone.subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        self.companyPhone.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.companyPhone.subTitleLabel.text = "186808543954"
        self.view.addSubview(self.companyPhone)
        
    }
}
