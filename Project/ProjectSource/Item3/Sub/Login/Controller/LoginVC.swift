//
//  LoginVC.swift
//  Project
//
//  Created by wy on 2018/1/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift

class LoginVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet var backView: UIView!
    @IBOutlet var registerBtn: UIButton!
    @IBOutlet var forgetPassword: UIButton!
    @IBOutlet var lognBtn: UIButton!
    @IBOutlet var loginName: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var backViewTop: NSLayoutConstraint!
    @IBOutlet var logoImage: UIImageView!
    
    override func gdAddSubViews() {
        let lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithRGB(red: 202, green: 202, blue: 202)
        self.loginName.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(1)
        }
        
        let subLineView = UIView.init()
        subLineView.backgroundColor = UIColor.colorWithRGB(red: 202, green: 202, blue: 202)
        self.loginPassword.addSubview(subLineView)
        subLineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(1)
        }
        self.backViewTop.constant = (DDDevice.type == .iphoneX) ? 108 : 84
        self.view.layoutIfNeeded()
        self.proptmLabel.isHidden = true
        self.proptmLabel2.isHidden = true
       
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "登录")
        
        
        self.loginName.leftViewMode = UITextFieldViewMode.always
        let loginNameLeftImage = UIImageView.init(image: UIImage.init(named: "phone_number"))
        loginNameLeftImage.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        loginNameLeftImage.contentMode = UIViewContentMode.center
        self.loginName.leftView = loginNameLeftImage
        self.loginPassword.leftViewMode = UITextFieldViewMode.always
        
        
        let loginPasswordImage = UIImageView.init(image: UIImage.init(named: "password"))
        loginPasswordImage.contentMode = .center
        loginPasswordImage.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.loginPassword.leftView = loginPasswordImage
        self.loginPassword.rightViewMode = UITextFieldViewMode.always
        let showBtn = UIButton.init(type: UIButtonType.custom)
        showBtn.setImage(UIImage.init(named: "hidden_password"), for: .normal)
        showBtn.setImage(UIImage.init(named: "show_the_password"), for: .selected)
        showBtn.addTarget(self, action: #selector(showBtnAction(btn:)), for: .touchUpInside)
        showBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.loginPassword.rightView = showBtn
        self.loginPassword.isSecureTextEntry = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        if let phone = UserDefaults.standard.value(forKey: "loginName") as? String {
            self.loginName.text = phone
        }
        self.loginName.rx.text.orEmpty.subscribe(onNext: { (input) in
            self.userName = input
        }, onError: nil, onCompleted: nil, onDisposed: nil)

        self.loginPassword.rx.text.orEmpty.subscribe(onNext: { (input) in
            self.password = input
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        let nameRx = self.loginName.rx.text.orEmpty.map { (title) -> Bool in
            return title.mobileLawful()
        }
        nameRx.subscribe(onNext: { (result) in
            if result {
                self.proptmLabel.isHidden = true
            }else {
                self.proptmLabel.isHidden = false
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let passRx = self.loginPassword.rx.text.orEmpty.map { (title) -> Bool in
            return title.passwordLawful()
        }
        passRx.subscribe(onNext: { (result) in
            if result {
                self.proptmLabel2.isHidden = true
            }else {
                self.proptmLabel2.isHidden = false
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        let _ = Observable.combineLatest([nameRx, passRx]).map { (arr) -> Bool in
            return arr.reduce(true, {$0 && $1})
            }.subscribe(onNext: { (result) in
                if result {
                    self.lognBtn.isEnabled = true
                    self.lognBtn.backgroundColor = UIColor.colorWithHexStringSwift("6292f6")
                }else {
                    self.lognBtn.isEnabled = false
                    self.lognBtn.backgroundColor = UIColor.colorWithHexStringSwift("e2e2e2")
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        self.loginName.returnKeyType = .done
        self.loginPassword.returnKeyType = .done
        
        
        self.navigationBackImage = (DDDevice.type == .iphoneX) ? UIImage.init(named: "twobeijing") : UIImage.init(named: "beijing")
        self.naviBar.naviagationBackImage.backgroundColor = UIColor.red
        mylog(self.naviBar.naviagationBackImage)
        mylog(self.naviBar.naviagationBackImage.image)
    
        
    }
    
    var userName: String = ""
    var password: String = ""
    
    
    @IBOutlet var proptmLabel: UILabel!
    @IBOutlet var proptmLabel2: UILabel!
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.resignFirstResponderAction()
        
    }
    
    @IBAction func backTapAction(_ sender: UITapGestureRecognizer) {
        self.resignFirstResponderAction()
    }
    
    func resignFirstResponderAction() {
        self.loginName.resignFirstResponder()
        self.loginPassword.resignFirstResponder()
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyBoardFrameValue = notification.userInfo![UIKeyboardFrameEndUserInfoKey], let keyBoardFrame = (keyBoardFrameValue as AnyObject).cgRectValue {
            let keyboardHeight: CGFloat = keyBoardFrame.height
            let keyBoardY: CGFloat = SCREENHEIGHT - keyboardHeight
            let backViewY: CGFloat = self.backView.max_Y
            if keyBoardY < backViewY {
                //如果键盘的Y值，小于backView的下面
                self.configShowAnimation(keyBoardY: keyBoardY, backViewY: backViewY, keyboardHeight: keyboardHeight)
            }
            
        }
        
        
    }
    func configShowAnimation(keyBoardY: CGFloat, backViewY: CGFloat, keyboardHeight: CGFloat) {
        var move: CGFloat = backViewY - keyBoardY
        if (DDDevice.type == .iPhone4) || (DDDevice.type == .iPhone5) {
            let rect = self.logoImage.convert(self.logoImage.bounds, to: self.view)
            move = rect.maxY - DDNavigationBarHeight
        }
        UIView.animate(withDuration: 0.25, animations: {
            
            if (DDDevice.type == .iPhone4) || (DDDevice.type == .iPhone5) {
                self.view.frame = CGRect.init(x: 0, y: -keyboardHeight + DDNavigationBarHeight, width: self.view.width, height: self.view.height)
            }else {
                self.backViewTop.constant = self.backViewTop.constant - move
            }
            
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    
    @objc func keyboardWillHide(notification: Notification) {
        
        UIView.animate(withDuration: 0.25, animations: {
            if (DDDevice.type == .iPhone4) || (DDDevice.type == .iPhone5) {
                self.view.frame = CGRect.init(x: 0, y: 0, width: self.view.width, height: self.view.height)
            }else {
                self.backViewTop.constant = (DDDevice.type == .iphoneX) ? 108 : 84
            }
            
            self.view.layoutIfNeeded()
            
        })
        
        
        
    }
    

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func showBtnAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.loginPassword.isSecureTextEntry = !btn.isSelected
    }

    @IBAction func loginBtnAction(_ sender: UIButton) {
        if !self.userName.mobileLawful() {
            GDAlertView.alert("用户名格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
//<<<<<<< HEAD
//
//
//
//
//        let paramete = ["token": token, "username": self.userName, "password": self.password]
//        NetWork.manager.requestData(router: Router.post("Login/rest", .api, paramete, nil), type: DDAccount.self).subscribe(onNext: { (model) in
//            if model.status == 200 {
//
//
//                ////////
//                if let jpushID = DDStorgeManager.share.string(forKey: "JPUSHID"){
//                    if jpushID != "HasUploaded"{
//                        DDRequestManager.share.saveJpushID(type: ApiModel<String>.self, registrationID: jpushID, complate: { (model ) in
//                            if let status = model?.status , status == 200 {
//                                DDStorgeManager.share.setValue("HasUploaded", forKey: "JPUSHID")
//                            }
//                            mylog(model?.status)
//                            mylog(model?.message)
//                            mylog(model?.data)
//                        })
//=======
        NetWork.manager.initToken().subscribe(onNext: { (bo) in
            
            if !bo {
                GDAlertView.alert("初始化失败请重试", image: nil, time: 1, complateBlock: nil)
                return
            }
            let paramete = ["token": token, "username": self.userName, "password": self.password]
            NetWork.manager.requestData(router: Router.post("Login/rest", .api, paramete, nil), type: DDAccount.self).subscribe(onNext: { (model) in
                if model.status == 200 {
                    
                    UserDefaults.standard.set(self.userName, forKey: "loginName")
                    ////////
                    if let jpushID = DDStorgeManager.share.string(forKey: "JPUSHID"){
                        if jpushID != "HasUploaded"{
                            DDRequestManager.share.saveJpushID(type: ApiModel<String>.self, registrationID: jpushID, complate: { (model ) in
                                if let status = model?.status , status == 200 {
                                    DDStorgeManager.share.setValue("HasUploaded", forKey: "JPUSHID")
                                }
                                mylog(model?.status)
                                mylog(model?.message)
                                mylog(model?.data)
                            })
                        }
//>>>>>>> 3df96f42a5cc2b98256259b2f547950db2ccb5c0
                    }
                    
                    DDAccount.share.setPropertisOfShareBy(otherAccount: model.data)
                    DDNotification.postLoginSuccess()
                    
                    
                    
                    
                    
                    
                }else {
                    GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
                    
                    
                }
                
            }, onError: { (error) in
                
                
            }, onCompleted: {
                mylog("结束")
            }) {
                mylog("回收")
            }
            
            
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
       
        
        
        
        
        
    }
    @IBAction func forgetPasswordAction(_ sender: UIButton) {
        
        let vc = ForgetPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func registerAction(_ sender: UIButton) {
        alertBeforePrivacy()
        //
    }
    
    func alertBeforePrivacy()   {
        let alert = PrivacyAlert.init(superView : self.view)
        alert.actionHandle = {[weak self]  para in
            if let paraStr = para as? String {
                if paraStr == "accept" {
                    self?.gotoRegisterVC()
                }
                if paraStr == "seePravicy" {
                    self?.gotoPrivacy()
                }
                
            }
        }
    }
    func gotoRegisterVC() {
        
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func gotoPrivacy()  {
        let id = DDAccount.share.id ?? ""
        let web = SetWebVC()
        web.userInfo = BaseUrlStr.api.rawValue + "Fcontent?language=110&id=\(2)"
        self.navigationController?.pushViewController(web, animated: true)
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
