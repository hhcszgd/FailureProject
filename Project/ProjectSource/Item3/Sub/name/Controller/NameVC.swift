//
//  NameVC.swift
//  Project
//
//  Created by wy on 2017/12/30.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class NameVC: GDNormalVC, UITextFieldDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var trueBtn: UIButton!
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var top: NSLayoutConstraint!
    var inputStr: String = ""
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.nameTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let type = self.userInfo as? VCActionType else {
            return
        }
        var text: String = ""
        switch type {
        case .changeName:
            text = "您的姓名"
        case .changeCompanyName:
            text = "公司名称"
        case .chageCompanyMobile:
            text = "公司电话"
            self.nameTextField.keyboardType = .numberPad
                
        
        default:
            break
        }
        self.top.constant = DDNavigationBarHeight + 15
        self.view.layoutIfNeeded()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: text)
        self.titleLabel.text = text
        self.promptLabel.text = "4-80个字符"
        self.trueBtn.setTitle("确定", for: .normal)
        // Do any additional setup after loading the view.
        self.nameTextField.delegate = self
        self.nameTextField.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.nameTextField.returnKeyType = .done
    }
    

    @IBAction func trueAction(_ sender: UIButton) {
        guard let actionKey = self.userInfo as? VCActionType else {
            return
        }
        var router: Router!
        switch actionKey {
        case .changeName:
            if !self.inputStr.userNameLawful() {
                 GDAlertView.alert("用户名不合法", image: nil, time: 1, complateBlock: nil)
                return
            }
            let parameter = ["token": token, "nickname": self.inputStr]
            router = Router.put("Mttupdateinfo/updatename", .api, parameter, nil)
            self.request(router: router, type: String.self, success: { (model) in
                if model.status == 200 {
                    DDAccount.share.nickname = self.inputStr
                    DDAccount.share.save()
                    self.popToPreviousVC()
                }else {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                }
            }, failure: {
                
            })
            
        case .changeCompanyName:
            if !self.inputStr.companyNameLawful() {
                GDAlertView.alert("公司名称不合法", image: nil, time: 1, complateBlock: nil)
                return
            }
            let parameter = ["token": token, "companyname": self.inputStr]
            router = Router.put("Mttupdateinfo/companyname", .api, parameter, nil)
            self.request(router: router, type: String.self, success: { (model) in
                if model.status == 200 {
                    DDAccount.share.companyName = self.inputStr
                    DDAccount.share.save()
                    self.popToPreviousVC()
                }else {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                }
                
            }, failure: {
                
            })
        case .chageCompanyMobile:
            
            let parameter = ["token": token, "mobile": self.inputStr]
            let router = Router.put("Mttupdateinfo/companytel", .api, parameter, nil)
            self.request(router: router, type: DDAccount.self, success: { (model) in
                if model.status == 200 {
                    DDAccount.share.companyPhone = self.inputStr
                    DDAccount.share.save()
                    self.popToPreviousVC()
                }else {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                }
            }, failure: {
                mylog("失败")
            })
        
        default:
            break
        }
    }
    
    
    override var keyModel: GDModel?{
        didSet{
            
        }
    }
    
    func request<T: Codable>(router: Router, type: T.Type, success:@escaping ((ApiModel<T>) -> ()), failure: @escaping (() -> ())) {
        NetWork.manager.requestData(router: router, type: type).subscribe(onNext: { (model) in
            success(model)
        }, onError: { (error) in
            failure()
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func gdAddSubViews() {
        
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
