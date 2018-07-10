//
//  PhoneVC.swift
//  Project
//
//  Created by wy on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class PhoneVC: GDNormalVC {

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
    }
    @IBOutlet var sureBtn: UIButton!
    @IBAction func sureAction(_ sender: UIButton) {
        guard let actionKey = self.userInfo as? VCActionType else {
            return
        }
        
        
        if self.inputverfication.count == 0 {
            GDAlertView.alert("验证码不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        switch actionKey {
            
        case .changeUserMobile:
            let parameter = ["token": token, "mobile": self.inputPhone, "mobilecode": self.inputverfication]
            let router = Router.post("Modifymobile/rest", .api, parameter, nil)
            self.request(router: router, type: DDAccount.self, success: { (model) in
                if model.status == 200 {
                    DDAccount.share.mobile = self.inputPhone
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
    
    
    
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var codeText: UITextField!
    @IBOutlet var phonetext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.top.constant = DDNavigationBarHeight + 15
        self.view.layoutIfNeeded()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "手机号")
        self.phonetext.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputPhone = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.codeText.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.inputverfication = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.view.addSubview(self.verificationBtn)
        self.verificationBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(35)
            make.width.equalTo(100)
            make.centerY.equalTo(self.codeText)
        }
        self.phonetext.returnKeyType = .done
        self.codeText.returnKeyType = .done
        
        // Do any additional setup after loading the view.
    }
    deinit {
        mylog("销毁")
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
    var timer: Timer?
    var leftTime: Int = 60
    var inputPhone: String = ""
    var inputverfication: String = ""
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
