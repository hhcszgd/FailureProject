//
//  AccountVC.swift
//  Project
//
//  Created by wy on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class AccountVC: GDNormalVC {

 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)

        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "换绑手机号")
        self.scroll.addSubview(self.phoneTitle)
        self.phoneTitle.text = "现在绑定的手机号:"
        self.scroll.addSubview(self.phoneValue)
        self.inputPhone = DDAccount.share.username ?? ""
        
        if self.inputPhone.mobileLawful() {
            let phoneStr = NSString.init(string: self.inputPhone)
            let prefix = phoneStr.substring(to: 3)
            let sub = phoneStr.substring(from: 7)
            let id = prefix + "****" + sub
            self.phoneValue.text = id
        }
        
        
        
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
        
        self.newPassword.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(self.verficationField.snp.bottom).offset(1)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        self.configTextfield(placeholder: " 请输入原登录密码", font: UIFont.systemFont(ofSize: 14), textfield: self.newPassword)

        self.scroll.addSubview(self.setBtn)
        
        self.setBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
            make.top.equalTo(self.newPassword.snp.bottom).offset(40)
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
        self.verficationField.keyboardType = .numberPad
        self.newPassword.keyboardType = .default
        
        
        
        // Do any additional setup after loading the view.
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
        btn.setTitle("下一步", for: .normal)
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
    var inputverfication: String = ""
    var leftTime: Int = 60
    var timer: Timer?
    var inputPhone: String = ""
    let verficationField: UITextField = UITextField.init()
    let newPassword: UITextField = UITextField.init()
    
}
extension AccountVC {
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
        let paramete = ["mobile": self.inputPhone, "type": 0, "token": token] as [String : Any]
        
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
        
    }
    @objc func setAction(sender: UIButton) {
        if !self.inputPhone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.inputverfication.count == 0 {
            GDAlertView.alert("验证码不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.inputpasswrod.passwordLawful() {
            GDAlertView.alert("密码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }

        
        let paramete = ["token": token, "mobilecode": self.inputverfication, "password": self.inputpasswrod, "mobile": self.inputPhone]
        let router = Router.post("Verorimobile/rest", .api, paramete, nil)
        
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                let changePhone = ChangePhoneVC()
                
                self.navigationController?.pushViewController(changePhone, animated: true)
            }else {
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
    }
    
    
}


