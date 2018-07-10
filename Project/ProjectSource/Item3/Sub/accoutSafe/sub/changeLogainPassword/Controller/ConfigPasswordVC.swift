//
//  ConfigPasswordVC.swift
//  Project
//
//  Created by wy on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
///相同的布局不同的操作
enum VCActionType {
    ///修改支付密码
    case changePayPassword
    ///修改登录密码
    case changeLoginPassword
    ///换绑手机号码
    case changebindphonefirst
    ///换绑手机号码第二步
    case changebindphonesecond
    ///修改姓名，修改手机号。
    case changeName
    ///修改公司姓名
    case changeCompanyName
    ///修改公司电话
    case chageCompanyMobile
    ///修改手机号
    case changeUserMobile
    
    
}
class ConfigPasswordVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        if let actionKey = self.userInfo as? VCActionType {
            switch actionKey {
            case .changePayPassword:
                mylog("修改支付密码")
                self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "设置支付密码")
                self.configTextfield(placeholder: " 请设置6位数字支付密码", font: UIFont.systemFont(ofSize: 14), textfield: self.newPassword)
                self.configTextfield(placeholder: " 请设置6位数字支付密码", font: UIFont.systemFont(ofSize: 14), textfield: self.againPassword)
   
            case .changeLoginPassword:
                mylog("修改登录密码")
                self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "设置登录密码")
                self.configTextfield(placeholder: " 请输入6-16位新密码", font: UIFont.systemFont(ofSize: 14), textfield: self.newPassword)
                self.configTextfield(placeholder: " 请重新输入6-16位新密码", font: UIFont.systemFont(ofSize: 14), textfield: self.againPassword)
            default:
                break
            }
        }
        self.scroll.addSubview(self.phoneTitle)
        self.scroll.addSubview(self.phoneValue)
        if (DDAccount.share.username?.mobileLawful())! {
            self.phoneValue.text = (DDAccount.share.username ??
                "").prefixphone()
        }
        self.inputPhone = DDAccount.share.username ?? ""
        
        self.phoneTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(DDNavigationBarHeight + 30)
        }
        self.phoneValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneTitle.snp.right)
            make.centerY.equalTo(self.phoneTitle)
        }
        
        self.scroll.addSubview(self.verficationField)
        self.verficationField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.phoneTitle.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        ///设置验证码textfield
        self.verficationField.rightViewMode = .always
        self.verficationField.rightView = self.verificationBtn
        self.verficationField.placeholder = " 验证码"
        self.verficationField.backgroundColor = UIColor.white
        self.verficationField.font = UIFont.systemFont(ofSize: 14)
        
        self.scroll.addSubview(self.newPassword)
        self.scroll.addSubview(self.againPassword)
        
        self.newPassword.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.verficationField.snp.bottom).offset(1)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        self.againPassword.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.newPassword.snp.bottom).offset(1)
            make.height.equalTo(40)
        }
        
        self.scroll.addSubview(self.setBtn)
        
        self.setBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
            make.top.equalTo(self.againPassword.snp.bottom).offset(40)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-275)
        }
        
        self.scroll.addGestureRecognizer(self.tap)
        self.scroll.isUserInteractionEnabled = true
        
        self.verficationField.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputverfication = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.newPassword.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputpasswrod = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.againPassword.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputagainPassword = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let showBtn = UIButton.init(type: UIButtonType.custom)
        showBtn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        showBtn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        showBtn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        showBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        
        let showBtn2 = UIButton.init(type: UIButtonType.custom)
        showBtn2.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        showBtn2.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        showBtn2.addTarget(self, action: #selector(showBtnAction2(btn:)), for: .touchUpInside)
        showBtn2.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        
        self.newPassword.isSecureTextEntry = true
        self.againPassword.isSecureTextEntry = true
        self.newPassword.rightView = showBtn
        self.newPassword.rightViewMode = .always
        
        self.againPassword.rightView = showBtn2
        self.againPassword.rightViewMode = .always
        
        
        
    
        // Do any additional setup after loading the view.
    }
    
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.newPassword.isSecureTextEntry = !btn.isSelected
        
    }
    @objc func showBtnAction2(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.againPassword.isSecureTextEntry = !btn.isSelected
    }
    let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
    
    
    
    
    func configTextfield(placeholder: String, font: UIFont, textfield: UITextField) {
        textfield.font = font
        textfield.backgroundColor = UIColor.white
        textfield.placeholder = placeholder
        
    }
    
 
    lazy var scroll: UIScrollView = {
        let scrollview = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT))
        self.view.addSubview(scrollview)
        scrollview.isScrollEnabled = true
        scrollview.showsVerticalScrollIndicator = false
        
        return scrollview
    }()
    
    
    let phoneTitle: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("333333"), text: "手机号：")
    let phoneValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    lazy var verificationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 38))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.colorWithRGB(red: 103, green: 150, blue: 248)
        btn.addTarget(self, action: #selector(verficationActin(btn:)), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var setBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 38))
        btn.setTitle("设 置", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.colorWithRGB(red: 103, green: 150, blue: 248)
        btn.addTarget(self, action: #selector(setAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    
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
    var inputpasswrod: String = ""
    var inputagainPassword: String = ""
    var inputverfication: String = ""
    var leftTime: Int = 60
    var timer: Timer?
    var inputPhone: String = ""
    let verficationField: UITextField = UITextField.init()
    let newPassword: UITextField = UITextField.init()
    let againPassword: UITextField = UITextField.init()

}
extension ConfigPasswordVC {
    ///验证码倒计时
    @objc func countDown() {
        
        if self.leftTime >= 1 {
            leftTime -= 1
        }
        if self.leftTime < 1 {
            self.leftTime = 60
            self.verificationBtn.isEnabled = true
            self.timer?.invalidate()
        }
        
        let count = String.init(format: "%ds后重新发送", self.leftTime)
        
        self.verificationBtn.setTitle(count, for: .disabled)
        //请求二维码的接口
        
        
    }
    ///点击发送验证码按钮
    @objc func verficationActin(btn: UIButton) {
        if !self.inputPhone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        btn.isEnabled = false
        
        self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        //请求二维码的接口
        ///type，type，注册1,找回密码2，绑定银行卡3,设置支付密码4
        guard let vcType = self.userInfo as? VCActionType else {
            return
        }
        var type: Int = 0
        if vcType == VCActionType.changePayPassword {
            type = 4
        }
        if vcType == VCActionType.changeLoginPassword {
            type = 0
        }
        let paramete = ["mobile": self.inputPhone, "type": type, "token": token] as [String : Any]
        
        let router = Router.post("Getverificationcode/rest", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                if let timer = self.timer {
                    RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
                }
            }else {
                self.timer?.invalidate()
                self.leftTime = 60
                btn.isEnabled = true
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
    
    @objc func tapAction(tap: UITapGestureRecognizer) {
        self.verficationField.resignFirstResponder()
        self.newPassword.resignFirstResponder()
        self.againPassword.resignFirstResponder()
        
    }
    @objc func setAction(sender: UIButton) {
        if self.inputverfication.count == 0 {
            GDAlertView.alert("验证码不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.inputpasswrod.passwordLawful() {
            GDAlertView.alert("密码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.inputpasswrod != self.inputagainPassword {
            GDAlertView.alert("两次密码输入不同", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        
        guard let vcType = self.userInfo as? VCActionType else {
            return
        }
        
        switch vcType {
        case .changeLoginPassword:
            let paramete = ["token": token, "mobile": self.inputPhone, "mobliecode": self.inputverfication, "newpassword": self.inputpasswrod, "oldpassword": inputpasswrod]
            let router = Router.post("Findpassword/rest", .api, paramete, nil)
            self.request(router: router, type: String.self, success: { (model) in
                if model.status == 200 {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: {
                        self.popToPreviousVC()
                    })
                }else {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                }
            }, failure: {
                mylog("失败")
            })
        case .changePayPassword:
            let paramete = ["token": token, "code": self.inputverfication, "payword": self.inputpasswrod]
            let router = Router.put("Mttupdateinfo/updatepayword", .api, paramete, nil)
            self.request(router: router, type: String.self, success: { (model) in
                if model.status == 200 {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: {
                        self.popToPreviousVC()
                    })
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
    
    
}


