//
//  ChangePhoneVC.swift
//  Project
//
//  Created by wy on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ChangePhoneVC: GDNormalVC {

    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var phonetext: UITextField!
    
    @IBOutlet var codeText: UITextField!
    @IBOutlet var finishedBtn: UIButton!
    @IBAction func finishAction(_ sender: UIButton) {
        if !self.inputPhone.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        if self.inputverfication.count == 0 {
            GDAlertView.alert("验证码不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        let paramete = ["token": token, "mobilecode": self.inputverfication, "mobile": self.inputPhone]
        let router = Router.post("Modifyname/rest", .api, paramete, nil)
        
        NetWork.manager.requestData(router: router, type: DDAccount.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                
                
                UserDefaults.standard.set(self.inputPhone, forKey: "loginName")
                let count = self.navigationController?.childViewControllers.count
                let vc = self.navigationController?.childViewControllers[count! - 2]
                let target = self.navigationController?.viewControllers.index(of: vc!)
                self.navigationController?.viewControllers.remove(at: target!)
                
                DDAccount.share.username = self.inputPhone
                DDAccount.share.save()
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
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "换绑手机号")
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.top.constant = DDNavigationBarHeight + 15
        self.codeText.rightViewMode = .always
        self.codeText.rightView = self.verificationBtn
        self.codeText.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputverfication = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.phonetext.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputPhone = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.phonetext.leftViewMode = .always
        self.phonetext.leftView = self.areaBtn
        
        self.codeText.returnKeyType = .done
        self.phonetext.returnKeyType = .done
     
        // Do any additional setup after loading the view.
    }
   
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.phonetext.resignFirstResponder()
        self.codeText.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func selectAreaCode(sender: UIButton) {
        
    }
    
    
    lazy var verificationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 38))
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.colorWithRGB(red: 103, green: 150, blue: 248)
        btn.addTarget(self, action: #selector(verficationActin(btn:)), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var areaBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 38))
        btn.setTitle("+86", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(lineColor, for: .normal)
        let lineView = UIView.init()
        btn.addSubview(lineView)
        lineView.backgroundColor = lineColor
        lineView.frame = CGRect.init(x: 49, y: 0, width: 1, height: 40)
        
        btn.addTarget(self, action: #selector(selectAreaCode(sender:)), for: .touchUpInside)
        return btn
    }()

    
    var inputverfication: String = ""
    var leftTime: Int = 60
    var timer: Timer?
    var inputPhone: String = ""

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChangePhoneVC {
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
        ///type，type，注册1,找回密码2，绑定银行卡3,设置支付密码4, 获取验证码的类型0
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
}



