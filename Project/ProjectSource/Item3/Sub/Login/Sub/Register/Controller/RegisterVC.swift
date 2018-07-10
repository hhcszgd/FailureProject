//
//  RegisterVC.swift
//  Project
//
//  Created by wy on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class RegisterVC: GDNormalVC, UITextFieldDelegate {

    @IBOutlet var promtLabel: UILabel!
    @IBOutlet var promtlabel2: UILabel!
    @IBOutlet var promtlabel3: UILabel!
    @IBOutlet var promtlabel4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func gdAddSubViews() {
        self.registerPasswordRightBtn.backgroundColor = UIColor.clear
        self.registeragainRightBtn.backgroundColor = UIColor.clear
        self.verificationBtn.backgroundColor = UIColor.clear
        self.registerPassword.isSecureTextEntry = true
        self.againPassword.isSecureTextEntry = true
        self.registerName.delegate = self
        self.registerPassword.delegate = self
        self.registerVergion.delegate = self
        self.againPassword.delegate = self
        self.againPassword.returnKeyType = .done
        self.registerVergion.returnKeyType = .done
        self.registerName.returnKeyType = .done
        self.registerPassword.returnKeyType = .done
        self.backViewTop.constant = (DDDevice.type == .iphoneX) ? 108 : 84
        self.lineView(textField: self.registerName)
        self.lineView(textField: self.registerVergion)
        self.lineView(textField: self.registerPassword)
        self.lineView(textField: self.againPassword)
        self.view.layoutIfNeeded()
        self.leftView(textField: self.registerName, leftImageStr: "phone_number")
        self.leftView(textField: self.registerVergion, leftImageStr: "verification_code")
        self.leftView(textField: self.registerPassword, leftImageStr: "password")
        self.leftView(textField: self.againPassword, leftImageStr: "password")
        self.registerBtn.setTitle("注 册", for: .normal)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(font: UIFont.systemFont(ofSize: 17), textColor: UIColor.white, text: "注册")
        
        self.registerName.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputPhone = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.registerVergion.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputVergion = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.registerPassword.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputPassword = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.againPassword.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputsubPassword = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let nameRx = self.registerName.rx.text.orEmpty.map { (title) -> Bool in
            return title.mobileLawful()
        }
        self.promtLabel.text = ""
        let vergionRx = self.registerVergion.rx.text.orEmpty.map { (title) -> Bool in
            return title.count > 0
        }
        self.promtlabel2.text = ""
        let passwordRx = self.registerPassword.rx.text.orEmpty.map { (title) -> Bool in
            return title.passwordLawful()
        }
        passwordRx.subscribe(onNext: { (bo) in
            if !bo {
                self.promtlabel3.text = "6-16位数字加字母，区分大小写，不包含特殊字符"
            }else {
                self.promtlabel3.text = ""
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        let againPassRx = self.againPassword.rx.text.orEmpty.map { (title) -> Bool in
            return title.passwordLawful()
        }
        againPassRx.subscribe(onNext: { (bo) in
            if !bo {
                self.promtlabel4.text = "6-16位数字加字母，区分大小写，不包含特殊字符"
            }else {
                self.promtlabel4.text = ""
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let _ = Observable.combineLatest([nameRx, vergionRx, passwordRx, againPassRx]).map { (arr) -> Bool in
            return arr.reduce(true, {$0 && $1})
            }.subscribe(onNext: { (result) in
                if result {
                    self.registerBtn.isEnabled = true
                    self.registerBtn.backgroundColor = UIColor.colorWithHexStringSwift("6292f6")
                }else {
                    self.registerBtn.isEnabled = false
                    self.registerBtn.backgroundColor = UIColor.colorWithHexStringSwift("e2e2e2")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        configKeyboard(subView: textField, view: self.backScroll)
        return true
    }
    
    
    @IBOutlet var backScroll: UIScrollView!
    
    
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
        self.registerVergion.rightViewMode = UITextFieldViewMode.always
        self.registerVergion.rightView = btn
        return btn
    }()
    
    
    lazy var registerPasswordRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        btn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        btn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        self.registerPassword.rightViewMode = UITextFieldViewMode.always
        self.registerPassword.rightView =  btn

        return btn
    }()
    lazy var registeragainRightBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        btn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        btn.addTarget(self, action: #selector(showPassword(sender:)), for: .touchUpInside)
        self.againPassword.rightViewMode = UITextFieldViewMode.always
        self.againPassword.rightView =  btn
        return btn
    }()
    
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.registerPassword.isSecureTextEntry = !btn.isSelected
    }
    
    @objc func showPassword(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.againPassword.isSecureTextEntry = !sender.isSelected
    }
    
    @IBOutlet var backView: UIView!
    @IBOutlet var backViewTop: NSLayoutConstraint!
    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var registerName: UITextField!
    @IBOutlet var registerVergion: UITextField!
    @IBOutlet var registerPassword: UITextField!
    @IBOutlet var selctBtn: UIButton!
    @IBOutlet var againPassword: UITextField!
    var inputPhone: String = ""
    var inputVergion: String = ""
    var inputPassword: String = ""
    var inputsubPassword: String = ""
    
 
    @IBAction func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBOutlet var propmtLabel: UILabel!
    
    @IBOutlet var protocolBtn: UIButton!
    

    @IBAction func protocolAction(_ sender: UIButton) {
        let web = SetWebVC()
        web.userInfo = BaseUrlStr.api.rawValue + "Fcontent?language=110"
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    @IBOutlet var registerBtn: UIButton!
    
    
   
    @IBOutlet var loginBtn: UIButton!
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.popToPreviousVC()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RegisterVC {
    
    @IBAction func regitsterAction(_ sender: UIButton) {
        if !self.selctBtn.isSelected {
            GDAlertView.alert("阅读协议", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.inputPhone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.inputVergion.count == 0 {
            GDAlertView.alert("验证码不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.inputPassword.passwordLawful() {
            GDAlertView.alert("密码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.inputsubPassword.passwordLawful() {
            GDAlertView.alert("确认密码不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.inputPassword != self.inputsubPassword {
            GDAlertView.alert("两次密码不同", image: nil, time: 1, complateBlock: nil)
            return
        }
        //type,0一把通，1玉龙
        NetWork.manager.initToken().subscribe(onNext: { (bo) in
            if !bo {
                GDAlertView.alert("初始化失败请重试", image: nil, time: 1, complateBlock: nil)
                return
            }
            let paramete = ["token": token, "mobile": self.inputPhone, "mobilecode": self.inputVergion, "password": self.inputPassword, "type": "0"]
            let router = Router.post("Register/rest", .api, paramete, nil)
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
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        
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
        ///type，注册1,找回密码2，绑定银行卡3,设置支付密码4
        NetWork.manager.initToken().subscribe(onNext: { (bo) in
            if !bo {
                GDAlertView.alert("初始化失败请重试", image: nil, time: 1, complateBlock: nil)
                return
            }
            let paramete = ["mobile": self.inputPhone, "type": "1", "token": token] as [String : Any]
            NetWork.manager.requestData(router: Router.post("Getverificationcode/rest", .api, paramete, nil), type: String.self).subscribe(onNext: { (model) in
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
                btn.isEnabled = true
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
            
        }, onError: { (error) in
            
        }, onCompleted: nil, onDisposed: nil)
        

    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.resignFirstResponderAction()
    }
    @IBAction func subAction(_ sender: UITapGestureRecognizer) {
        self.resignFirstResponderAction()
    }
    
    func resignFirstResponderAction() {
        self.registerName.resignFirstResponder()
        self.registerPassword.resignFirstResponder()
        self.registerVergion.resignFirstResponder()
        self.againPassword.resignFirstResponder()
    }
    
//    @objc func keyboardWillShow(notification: Notification) {
//        if let keyBoardFrameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey], let keyBoardFrame = (keyBoardFrameValue as AnyObject).cgRectValue {
//            let keyboardHeight: CGFloat = keyBoardFrame.height
//            let keyBoardY: CGFloat = SCREENHEIGHT - keyboardHeight
//            let backViewY: CGFloat = self.backView.max_Y
//            if keyBoardY < backViewY {
//                //如果键盘的Y值，小于backView的下面
//                self.configShowAnimation(keyBoardY: keyBoardY, backViewY: backViewY, keyboardHeight: keyboardHeight)
//            }
//
//        }
//
//
//    }
//    func configShowAnimation(keyBoardY: CGFloat, backViewY: CGFloat, keyboardHeight: CGFloat) {
//        var move: CGFloat = backViewY - keyBoardY
//        if (DDDevice.type == .iPhone4) || (DDDevice.type == .iPhone5) {
//            let rect = self.logoImage.convert(self.logoImage.bounds, to: self.view)
//            move = rect.maxY - DDNavigationBarHeight
//        }
//        UIView.animate(withDuration: 0.25, animations: {
//
//            if (DDDevice.type == .iPhone4) || (DDDevice.type == .iPhone5) {
//                self.view.frame = CGRect.init(x: 0, y: -keyboardHeight + DDNavigationBarHeight, width: self.view.width, height: self.view.height)
//            }else {
//                self.backViewTop.constant = self.backViewTop.constant - move
//            }
//
//
//            self.view.layoutIfNeeded()
//
//        })
//    }
//
//
//    @objc func keyboardWillHide(notification: Notification) {
//
//        UIView.animate(withDuration: 0.25, animations: {
//            if (DDDevice.type == .iPhone4) || (DDDevice.type == .iPhone5) {
//                self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: self.view.height)
//            }else {
//                self.backViewTop.constant = (DDDevice.type == .iphoneX) ? 108 : 84
//            }
//
//            self.view.layoutIfNeeded()
//
//        })
//    }
//
//
    
    
    
    
    
}


