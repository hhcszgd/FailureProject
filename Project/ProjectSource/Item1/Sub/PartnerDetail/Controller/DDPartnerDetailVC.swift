//
//  DDPartnerDetailVC.swift
//  Project
//
//  Created by WY on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerDetailVC: DDNormalVC {
    enum DDPartnerDetailFuncType {
        ///添加好友 [加为伙伴]
        case addFriend
        ///被添加好友 [加为伙伴 , 拒绝]
        case beAddFriend
        /// 已添加过的伙伴详情 [发起约定 , 直接付款]
        case friendDetail
    }
    
    convenience init(type : DDPartnerDetailFuncType){
        self.init()
        self.funcType = type
    }
    
    let icon  = UIImageView()
    let name = UILabel()
    let account = UILabel()
    let phone = UILabel()
    
    let action1 = UIButton()
    let action2 = UIButton()
    let backview2 = UIView()
//    let add = UIButton()
//    let createAppoint = UIButton()
//    let pay = UIButton()
//    let reject = UIButton()
    
    var funcType : DDPartnerDetailFuncType = DDPartnerDetailFuncType.friendDetail
    var userID : String = ""
    var model : ApiModel<DDPartnerInfoModel>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"
        self.view.backgroundColor = UIColor.DDLightGray
        // Do any additional setup after loading the view.
        if let dict = self.userInfo as? [String : Any]{
            if let type = dict["type"] as? DDPartnerDetailFuncType{
                self.funcType = type
            }
            if let userid = dict["id"] as? String{
                self.userID = userid
                
            }else{self.userID = "8166"}
        }else{self.userID = "8166"}
        _addSubviews()
        self.requestApi()
    }
    func requestApi() {//DDPartnerInfoModel
        DDRequestManager.share.getPartnerInfo(type: ApiModel<DDPartnerInfoModel>.self , userID: self.userID) { (model ) in
            if let model = model{
                if model.status  == 200{
                    self.model = model
                    self._layoutSubviews()
                    self.configContent()
                    
                }else{
                    GDAlertView.alert(model.message, image: nil , time: 2 , complateBlock: nil)
                }
            }else{
                DDErrorView(superView: self.view, error: DDError.serverError("请求失败")).automaticRemoveAfterActionHandle = {
                    self.requestApi()
                }
            }
        }
    }
    func _layoutSubviews(){
        if (self.model?.data?.is_friends ?? "0") == "1"{//好友
            action1.setTitle("发起约定", for: UIControlState.normal)
            action1.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
            action1.addTarget(self , action: #selector(performCreateAppoint), for: UIControlEvents.touchUpInside)
            action2.setTitle("直接付款", for: UIControlState.normal)
            action2.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
            action2.addTarget(self , action: #selector(performPay), for: UIControlEvents.touchUpInside)
//            action2.isHidden = false
            action2.isHidden = true//修改
        }else if (self.model?.data?.is_friends ?? "0") == "2"{
            action1.setTitle("加为伙伴", for: UIControlState.normal)
            action1.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
            action1.addTarget(self , action: #selector(performAddFriend), for: UIControlEvents.touchUpInside)
            action2.isHidden = true
        }else{
            switch self.funcType {
            case .addFriend:
                action1.setTitle("加为伙伴", for: UIControlState.normal)
                action1.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
                action1.addTarget(self , action: #selector(performAddFriend), for: UIControlEvents.touchUpInside)
                action2.isHidden = true
            case .beAddFriend:
                action1.setTitle("同意", for: UIControlState.normal)
                action1.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
                action1.addTarget(self , action: #selector(acceptBeAdd), for: UIControlEvents.touchUpInside)
                action2.setTitle("拒绝", for: UIControlState.normal)
                action2.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
                action2.addTarget(self , action: #selector(performReject), for: UIControlEvents.touchUpInside)
                action2.isHidden = false
            case .friendDetail:
                            action1.setTitle("发起约定", for: UIControlState.normal)
                            action1.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
                            action1.addTarget(self , action: #selector(performCreateAppoint), for: UIControlEvents.touchUpInside)
                            action2.setTitle("直接付款", for: UIControlState.normal)
                            action2.removeTarget(nil , action: nil , for: UIControlEvents.touchUpInside)
                            action2.addTarget(self , action: #selector(performPay), for: UIControlEvents.touchUpInside)
//                            action2.isHidden = false
                            action2.isHidden = true//修改
                break
            }
        }
        action1.frame = CGRect(x: 15, y: backview2.frame.maxY + 50, width: self.view.bounds.width - 30 , height: 50)
        action1.backgroundColor = UIColor.DDThemeColor
        action2.frame = CGRect(x: 15, y: action1.frame.maxY + 16, width: self.view.bounds.width - 30 , height: 50)
        action2.backgroundColor = UIColor.DDThemeColor
    }
    
    @objc func performAddFriend() {
        mylog("performAddFriend")
        DDRequestManager.share.addFriend(type: ApiModel<String>.self , userID: userID) { (model ) in
            var tips = ""
            if model?.status ?? 0 == 200{
                tips =   "发送成功,请耐心等待"
            }else{tips =   "请求失败,请重试"}
            GDAlertView.alert(model?.message ?? tips, image: nil , time: 2, complateBlock: nil )
        }
    }
    @objc func performPay() {
        mylog("performPay")
        self.navigationController?.pushVC(vcIdentifier: "DDPayStraightVC", userInfo: self.model?.data?.id)
    }
    
    @objc func performReject() {
        mylog("performReject")
        DDRequestManager.share.whetherAgreeBeAddFriend(type: ApiModel<String >.self , whetherAgree: false , userID: self.userID) { (model ) in
            if model?.status == 200 {
                GDAlertView.alert("您已拒绝此申请", image: nil, time: 2, complateBlock: nil )
                self.funcType = .addFriend
                self.requestApi()
            }else{
            GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil )
                self.funcType = .addFriend
                self.requestApi()
            }
        }
    }
    
    @objc func acceptBeAdd() {
        mylog("同意添加")
        DDRequestManager.share.whetherAgreeBeAddFriend(type: ApiModel<String >.self , whetherAgree: true , userID: self.userID) { (model ) in
            if model?.status  ?? 0 == 200 {
                GDAlertView.alert("添加成功", image: nil, time: 2, complateBlock: {
                    self.funcType = .friendDetail
                    self.requestApi()
                })
            }else{
                GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil )
                
            }
        }
    }
    
    @objc func performCreateAppoint()  {
        mylog("performCreateAppoint")
        if (DDAccount.share.nickname == nil) || (DDAccount.share.nickname == "未设置") {
            //            GDAlertView.alert("请设置用户名", image: nil, time: 2 , complateBlock: nil)
            let alertVC = UIAlertController.init(title: "尚未填写真实姓名", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                
            }
            
            let goSet = UIAlertAction.init(title: "去填写", style: UIAlertActionStyle.default) { (action) in
                self.navigationController?.pushVC(vcIdentifier: "NameVC", userInfo: VCActionType.changeName)
            }
            alertVC.addAction(cancel)
            alertVC.addAction(goSet)
            self.present(alertVC, animated: true , completion: nil)
        }else{
            let partnerIDs =  [model?.data?.id ?? ""]
            //                        self.navigationController?.pushVC(vcIdentifier: "DDCreateConventionVC", userInfo: model)
            DDShowManager.push(midArr: partnerIDs, appointmentArr: [String](), currentVC: self, finished: {[weak self](arr) in
                if let model = arr.first {
                    let vc = DDCreateConventionVC()
                    vc.userInfo = model
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            })
        }
        
        
        
        
        
        
        

//        self.navigationController?.pushVC(vcIdentifier: "DDCreateConventionVC", userInfo: model?.data?.id)
    }
    func _addSubviews() {
        let margin : CGFloat = 15
        let backview1 = UIView()
        backview1.backgroundColor = UIColor.white
        self.view.addSubview(backview1)
        backview1.frame = CGRect(x: 0, y: DDNavigationBarHeight + margin, width: self.view.bounds.width, height: 88)
        
        backview1.addSubview(self.icon)
        backview1.addSubview(self.name)
        backview1.addSubview(self.account)
        self.icon.frame = CGRect(x: margin, y: margin, width: backview1.bounds.height - margin * 2, height: backview1.bounds .height - margin * 2)
        
        self.name.frame = CGRect(x: self.icon.frame.maxX + margin, y: self.icon.frame.minY, width: backview1.frame.width - margin * 2 - icon.frame.maxX, height: self.icon.frame.height/2)
        
        self.account.frame = CGRect(x: self.name.frame.minX, y: icon.frame.midY, width: self.name.frame.width, height: self.name.frame.height)
        
        
//        let backview2 = UIView()
        backview2.addSubview(self.phone)
        backview2.backgroundColor = UIColor.white
        self.view.addSubview(backview2)
        backview2.frame = CGRect(x: 0, y: backview1.frame.maxY + margin, width: self.view.bounds.width, height: 64)
        
        self.phone.frame = CGRect(x: margin, y: 0, width: backview2.bounds.width - margin * 2 , height: backview2.bounds.height)
       
        
        self.view.addSubview(action1)
        self.view.addSubview(action2)
    }
    func configContent() {
        self.name.text = self.model?.data?.nickname
//        self.account.text = "账号 :  \( self.model?.data?.id ?? "")"
        self.account.text = "账号 :  \( self.model?.data?.name ?? "")"
        self.phone.text = "手机号 :  \( self.model?.data?.mobile ?? "")"
        self.icon.setImageUrl(url: model?.data?.head_images)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
