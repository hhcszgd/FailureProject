//
//  DDItem3VC.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
let mainColor = UIColor.colorWithHexStringSwift("fe5f5f")
class DDItem3VC: GDNormalVC, ProfileSubHeaderDelegate {
    
    

    let viewModel = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configmentUI()
        
        NotificationCenter.default.addObserver(self , selector: #selector(reloadData), name: GDReloadMeItem, object: nil )
    }
    
    @objc func reloadData() {
        NetWork.manager.requestData(router: Router.get("Mttuserinfo/getusermoney", .api, nil, nil), type: ProfileModel.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                self.profileModel = model.data
                self.headerView.PriceLabel.text = (self.profileModel?.balance ?? "") + "元"
                let freeze = self.profileModel?.freeze ?? "0"
                let freezeStr: String = "(\(freeze)元)"
                self.subHeaderView.freezingBtn.myTitleLabel?.attributedText = freezeStr.attributWithString(textColor: UIColor.red, location: 1, length: freezeStr.count - 2)
                let rate = self.profileModel?.rate ?? "0"
                let gain = self.profileModel?.gains ?? "0"
                
                //                self.headerView.infolabel.text = String.init(format: "每日万元收益%@元", rate)
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self )
    }

    var profileModel: ProfileModel?
  
    ///搭建UI
    func configmentUI() {
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.scrollView.addSubview(self.headerView)
        
        let rect = self.headerView.infolabel.convert(self.headerView.infolabel.bounds, to: self.scrollView)
        
        self.subHeaderView.frame = CGRect.init(x: self.subHeaderView.x, y: rect.maxY + 10, width: self.subHeaderView.width, height: self.subHeaderView.height)
        self.subHeaderView.delegate = self
        self.scrollView.addSubview(self.subHeaderView)
        
        ///长条cell
        let arr = [self.basicInfo, self.companyInfo, self.transactionInfo, self.consultInfo, self.accountSafe, self.set]
        
        arr.forEach { (row) in
            row.additionalImageView.isHidden = false
            row.titleLabel.font = UIFont.systemFont(ofSize: 15)
            self.scrollView.addSubview(row)
            row.addTarget(self, action: #selector(rowActionClick(sender:)), for: .touchUpInside)
        }
        let titleArr = ["基本信息", "公司信息", "交易记录", "协商管理", "账户安全", "设置"]
        for (index, row) in arr.enumerated() {
            row.titleLabel.text = titleArr[index]
        }
        
        self.basicInfo.frame = CGRect.init(x: 15, y: self.subHeaderView.max_Y + 15, width: rowW, height: rowH)
        self.companyInfo.frame = CGRect.init(x: 15, y: self.basicInfo.max_Y + 1, width: rowW, height: rowH)
        self.transactionInfo.frame = CGRect.init(x: 15, y: self.companyInfo.max_Y + 1, width: rowW, height: rowH)
        self.consultInfo.frame = CGRect.init(x: 15, y: self.transactionInfo.max_Y + 1, width: rowW, height: rowH)
        self.accountSafe.frame = CGRect.init(x: 15, y: self.consultInfo.max_Y + 1, width: rowW, height: rowH)
        self.set.frame = CGRect.init(x: 15, y: self.accountSafe.max_Y + 1, width: rowW, height: rowH)
        
        self.scrollView.contentSize = CGSize.init(width: 0, height: self.set.max_Y + 30 )
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        
        
        
    }
    
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.naviBar.isHidden = true
        NetWork.manager.requestData(router: Router.get("Mttuserinfo/getusermoney", .api, nil, nil), type: ProfileModel.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                self.profileModel = model.data
                self.headerView.PriceLabel.text = (self.profileModel?.balance ?? "") + "元"
                let freeze = self.profileModel?.freeze ?? "0"
                let freezeStr: String = "(\(freeze)元)"
                self.subHeaderView.freezingBtn.myTitleLabel?.attributedText = freezeStr.attributWithString(textColor: UIColor.red, location: 1, length: freezeStr.count - 2)
                let rate = self.profileModel?.rate ?? "0"
                let gain = self.profileModel?.gains ?? "0"
                
//                self.headerView.infolabel.text = String.init(format: "每日万元收益%@元", rate)
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
        
    }
    func profileSubHeaderAction(key: ProfileSubHeaderAction) {
        switch key {
        case .directPay:
            mylog("直接付款")
            let vc = DDChooseToPay()
            self.navigationController?.pushViewController(vc, animated: true)
        case .freezing:
            mylog("冻结报酬")
            
        case .recharge:
            mylog("充值")
            let vc = RechargeVC()
           self.navigationController?.pushViewController(vc, animated: true)
        case .withDraw:
            mylog("提现")
            self.navigationController?.pushVC(vcIdentifier: "DDGetCashVC", userInfo: nil)
        default:
            break
        }
    }
    @objc func rowActionClick(sender : DDRowView) {
        switch sender {
        case self.basicInfo:
            mylog("基础信息")
            self.navigationController?.pushVC(vcIdentifier: "BasicInfoVC", userInfo: nil)
        case self.companyInfo:
            self.navigationController?.pushVC(vcIdentifier: "CompanyInfoVC", userInfo: nil)
        case self.transactionInfo:
            ///交易记录
            self.navigationController?.pushVC(vcIdentifier: "TransactionInfoVC", userInfo: nil)
//            self.navigationController?.pushVC(vcIdentifier: "ConsultManagerVC", userInfo: nil)
        case self.accountSafe:
            self.navigationController?.pushVC(vcIdentifier: "AccountSafeVC", userInfo: nil)
//            self.navigationController?.pushVC(vcIdentifier: "DDContactCustomerVC", userInfo: nil)
        case self.set:
            self.navigationController?.pushVC(vcIdentifier: "SetVC", userInfo: nil)
        case self.consultInfo:
            mylog("协商管理")
            self.navigationController?.pushVC(vcIdentifier: "ConsultManagerVC", userInfo: nil)
//            self.navigationController?.pushVC(vcIdentifier: "AccountSafeVC", userInfo: nil)
        default:
            break
        }
    }
    
    let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT - DDTabBarHeight))
    let headerView = ProfileHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 250.0 / 375.0 * SCREENWIDTH))
    let subHeaderView = ProfileSubheader.init(frame: CGRect.init(x: 15, y: 0, width: SCREENWIDTH - 30, height: 80))
    
    let rowH: CGFloat = 44
    let rowW: CGFloat = SCREENWIDTH - 30
    let basicInfo = DDRowView.init(frame: CGRect.zero)
    let companyInfo = DDRowView.init(frame: CGRect.zero)
    let transactionInfo = DDRowView.init(frame: CGRect.zero)
    let consultInfo = DDRowView.init(frame: CGRect.zero)
    let accountSafe = DDRowView.init(frame: CGRect.zero)
    let set = DDRowView.init(frame: CGRect.zero)
    
    
    
}
