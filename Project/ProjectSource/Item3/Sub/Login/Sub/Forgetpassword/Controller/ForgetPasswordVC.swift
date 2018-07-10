//
//  ForgetPasswordVC.swift
//  Project
//
//  Created by wy on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
import HandyJSON
class ForgetPasswordVC: GDNormalVC, UITextFieldDelegate {
    @IBOutlet var backView: UIView!
    
    @IBOutlet var backScroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let phoneRx = self.phone.rx.text.orEmpty.map { (title) -> Bool in
            return title.mobileLawful()
        }
        let verificationRx = self.Verification.rx.text.orEmpty.map { (title) -> Bool in
            return title.count > 0
        }
        let passwordRx = self.newPassword.rx.text.orEmpty.map { (title) -> Bool in
            return title.passwordLawful()
        }
        passwordRx.subscribe(onNext: { (bo) in
            if !bo {
                self.proptLabel.text = "6-16位数字加字母，区分大小写，不包含特殊字符"
            }else {
                self.proptLabel.text = ""
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let subPasswordRx = self.subnewPassword.rx.text.orEmpty.map { (title) -> Bool in
            return title.passwordLawful()
        }
        subPasswordRx.subscribe(onNext: { (bo) in
            if !bo {
                self.proptLabel2.text = "6-16位数字加字母，区分大小写，不包含特殊字符"
            }else {
                self.proptLabel2.text = ""
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let _ = Observable.combineLatest([phoneRx, verificationRx, passwordRx, subPasswordRx]).map { (arr) -> Bool in
            return arr.reduce(true, {$0 && $1})
            }.subscribe(onNext: { (result) in
                if result {
                    self.resetBtn.isEnabled = true
                    self.resetBtn.backgroundColor = UIColor.colorWithHexStringSwift("6292f6")
                }else {
                    self.resetBtn.isEnabled = false
                    self.resetBtn.backgroundColor = UIColor.colorWithHexStringSwift("e2e2e2")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.phone.delegate = self
        self.Verification.delegate = self
        self.newPassword.delegate = self
        self.subnewPassword.delegate = self 
        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        configKeyboard(subView: textField, view: self.backScroll)
        return true
    }
    @IBOutlet var proptLabel: UILabel!
    
    @IBOutlet var proptLabel2: UILabel!
    var inputPhone: String = ""
    var verificationCode: String = ""
    var inputNewPassword: String = ""
    var inputSubPassword: String = ""
    override func gdAddSubViews() {
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "resetPassword")
        self.subnewPasswordRightBtn.backgroundColor = UIColor.clear
        self.newPasswordRightBtn.backgroundColor = UIColor.clear
        self.verificationBtn.backgroundColor = UIColor.clear
        self.newPassword.isSecureTextEntry = true
        self.backViewTop.constant = (DDDevice.type == .iphoneX) ? 108 : 84
        self.lineView(textField: self.phone)
        self.lineView(textField: self.Verification)
        self.lineView(textField: self.newPassword)
        self.lineView(textField: self.subnewPassword)
        self.view.layoutIfNeeded()
        self.leftView(textField: self.phone, leftImageStr: "phone_number")
        self.leftView(textField: self.Verification, leftImageStr: "verification_code")
        self.leftView(textField: self.newPassword, leftImageStr: "password")
        self.leftView(textField: self.subnewPassword, leftImageStr: "password")
        self.resetBtn.setTitle("重置", for: .normal)
        
        self.phone.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputPhone = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.Verification.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.verificationCode = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.newPassword.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputNewPassword = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.subnewPassword.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputSubPassword = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        self.subnewPassword.isSecureTextEntry = true
    }
    
    var timer: Timer?
    var leftTime: Int = 60
    

    func lineView(textField: UITextField) {
        let view = UIView.init()
        view.backgroundColor = UIColor.colorWithRGB(red: 203, green: 203, blue: 203)
        textField.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    func leftView(textField: UITextField, leftImageStr: String) {
        let image = UIImageView.init()
        image.contentMode = UIViewContentMode.center
        image.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        image.image = UIImage.init(named: leftImageStr)
        textField.leftViewMode = UITextFieldViewMode.always
        textField.leftView = image
    }
    lazy var verificationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 122, height: 38))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.colorWithHexStringSwift("999999"), for: .normal)
        let lineview = UIView.init(frame: CGRect.init(x: 0, y: 4, width: 1, height: 30))
        lineview.backgroundColor = UIColor.colorWithRGB(red: 203, green: 203, blue: 203)
        btn.addTarget(self, action: #selector(verficationActin(btn:)), for: .touchUpInside)
        btn.addSubview(lineview)
        self.Verification.rightViewMode = UITextFieldViewMode.always
        self.Verification.rightView = btn
        return btn
    }()


    lazy var newPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        btn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        btn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        self.newPassword.rightViewMode = UITextFieldViewMode.always
        self.newPassword.rightView =  btn
        return btn
    }()
    lazy var subnewPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        btn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        btn.addTarget(self, action: #selector(subNewPasswordShowAction(btn:)), for: .touchUpInside)
        self.subnewPassword.rightViewMode = UITextFieldViewMode.always
        self.subnewPassword.rightView =  btn
        return btn
    }()
    @objc func subNewPasswordShowAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.subnewPassword.isSecureTextEntry = !btn.isSelected
    }
    
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.newPassword.isSecureTextEntry = !btn.isSelected
    }
    
    
    @IBOutlet var backViewTop: NSLayoutConstraint!
    @IBOutlet var logoImage: UIImageView!

    @IBOutlet var phone: UITextField!
    @IBOutlet var Verification: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var subnewPassword: UITextField!
    




    @IBOutlet var resetBtn: UIButton!


 
   

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

extension ForgetPasswordVC {
    
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.resignFirstResponderAction()
    }
    
    @IBAction func secondTapAction(_ sender: UITapGestureRecognizer) {
        self.resignFirstResponderAction()
    }
    
    func resignFirstResponderAction() {
        self.phone.resignFirstResponder()
        self.Verification.resignFirstResponder()
        self.newPassword.resignFirstResponder()
        self.subnewPassword.resignFirstResponder()
    }
    
    
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
        
        
        NetWork.manager.initToken().subscribe(onNext: { (bo) in
            if !bo {
                GDAlertView.alert("初始化失败请重试", image: nil, time: 1, complateBlock: nil)
                return
            }
            
            ///type，type，注册1,找回密码2，绑定银行卡3,设置支付密码4
            let paramete = ["mobile": self.inputPhone, "type": 2, "token": token] as [String : Any]
            
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
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
       

    }
    ///重置密码
    @IBAction func resetAction(_ sender: UIButton) {
        if !self.inputPhone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.verificationCode.count == 0 {
            GDAlertView.alert("验证码不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.inputNewPassword.passwordLawful() {
            GDAlertView.alert("密码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.inputSubPassword.passwordLawful() {
            GDAlertView.alert("确认密码不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.inputNewPassword != self.inputSubPassword {
            GDAlertView.alert("两次密码不同", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        NetWork.manager.initToken().subscribe(onNext: { (bo) in
            if !bo {
                GDAlertView.alert("初始化失败请重试", image: nil, time: 1, complateBlock: nil)
                return
            }
            let paramete = ["token": token, "mobile": self.inputPhone, "mobliecode": self.verificationCode, "newpassword": self.inputNewPassword, "oldpassword": self.inputSubPassword]
            let router = Router.post("Findpassword/rest", .api, paramete, nil)
            NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
                if model.status == 200 {
                    self.popToPreviousVC()
                }else {
                    
                }
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                
            }, onError: { (error) in
                
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
            
            
        }, onError: { (_) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        

        
        
    }

    
    

}


