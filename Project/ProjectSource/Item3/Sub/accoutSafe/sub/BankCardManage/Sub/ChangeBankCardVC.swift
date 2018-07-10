//
//  ChangeBankCardVC.swift
//  Project
//
//  Created by wy on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ChangeBankCardVC: GDNormalVC, UITextFieldDelegate,DDBankChooseDelegate {
    @IBOutlet var scroll: UIScrollView!
    
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var cardholder: UITextField!
    @IBOutlet var idCard: UITextField!

    @IBOutlet var bankName: UILabel!
    @IBOutlet var phone: UITextField!
    @IBOutlet var cardName: UITextField!
    @IBOutlet var bindBtn: UIButton!
    @IBOutlet var code: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()

        self.cardName.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.cardNumStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.phone.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.phoneStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.code.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.codeStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "绑定银行卡")
        self.configTextField()
        
        if #available(iOS 11.0, *) {
            self.scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func bankNameTitleTapAction(_ sender: UITapGestureRecognizer) {
        self.chooseBankClick()
        
    }
    
    
    func configTextField() {
        self.verificationBtn.isUserInteractionEnabled = true
        self.cardName.delegate = self
        self.phone.delegate = self
        self.code.delegate = self
        
        self.leftView(textField: self.cardholder, leftLabelStr: "  持卡人")
        self.leftView(textField: self.idCard, leftLabelStr: " 身份证")
        self.leftView(textField: self.cardName, leftLabelStr: "  银行卡号")
        self.leftView(textField: self.phone, leftLabelStr: " 手机号")
        self.leftView(textField: self.code, leftLabelStr: " 验证码")
        
    }

    ///设置textfield左边的文字
    func leftView(textField: UITextField, leftLabelStr: String) {
        let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("333333"), text: leftLabelStr)
        label.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
        textField.leftViewMode = UITextFieldViewMode.always
        textField.leftView = label
    }
    
    
    lazy var verificationBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 38))
        btn.setTitle("验证码", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(verficationActin(btn:)), for: .touchUpInside)
        btn.backgroundColor = UIColor.colorWithHexStringSwift("6a96fc")
        
        self.phone.rightViewMode = UITextFieldViewMode.always
        self.phone.rightView = btn
        return btn
    }()
    ///点击发送验证码按钮
    @objc func verficationActin(btn: UIButton) {
        if self.phoneStr.count < 1 {
            GDAlertView.alert("请填写手机号码", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.phoneStr.mobileLawful() {
            GDAlertView.alert("手机号码格式不对", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        btn.isEnabled = false
        self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        //请求二维码的接口
        ///type，注册1,找回密码2，绑定银行卡3,设置支付密码4
        let paramete = ["mobile": self.phoneStr, "type": "3", "token": token] as [String : Any]
        
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
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
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
    
    
    
    @IBAction func bindClick(_ sender: UIButton) {
        if self.nameStr.count == 0 {
            GDAlertView.alert("姓名为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if self.cardNumStr.count == 0 {
            GDAlertView.alert("银行卡号为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if self.bankNameStr.count == 0  {
            GDAlertView.alert("银行名称为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if self.phoneStr.count == 0  {
            GDAlertView.alert("手机号为空", image: nil, time: 2, complateBlock: nil)
            return
        }else if self.codeStr.count == 0  {
            GDAlertView.alert("验证码为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        
        if !self.nameStr.userNameLawful() {
            GDAlertView.alert("请输入2到6位汉字的用户名", image: nil, time: 2, complateBlock: nil)
            return
        }
        if !(self.cardNumStr.bankCardCheck())  {
            GDAlertView.alert("请输入正确的银行卡号", image: nil, time: 2, complateBlock: nil)
            return
        }
        if !self.codeStr.authoCodeLawful() {
            GDAlertView.alert("请输入六位数字的验证码", image: nil, time: 2, complateBlock: nil)
            return
        }
        if !self.phoneStr.mobileLawful() {
            GDAlertView.alert("请输入正确的手机号", image: nil, time: 2, complateBlock: nil)
            return
        }
        if self.bankID == nil {
            GDAlertView.alert("没有选择正确的银行", image: nil, time: 1, complateBlock: nil)
            return
        }
        let paramete = ["token": token, "bank": self.bankID! , "card_num": self.cardNumStr, "type": "储蓄卡", "truename": self.nameStr, "id_num": self.IDCardStr, "mobile": self.phoneStr, "code": self.codeStr]
        let router = Router.post("Mttupdateinfo/bindcard", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        
    }
    @IBAction func tapActrion(_ sender: UITapGestureRecognizer) {
        self.bankName.resignFirstResponder()
        self.cardName.resignFirstResponder()
        self.phone.resignFirstResponder()
        self.code.resignFirstResponder()
    }
    func didSelectModel(model: DDBandBrandModel) {
        self.bankName.text = model.name
        self.bankNameStr = model.name ?? ""
        self.bankID = model.id
        self.cover?.remove()
        self.cover = nil
    }
    
    
    var bankID: String?
    var doneHandle : (()->())?
    var timer: Timer?
    var leftTime: Int = 60
    var apiModel : ApiModel<[DDBandBrandModel]>?
    var selectedBankBrandModel : DDBandBrandModel?
    weak var cover  : DDCoverView?
    ///银行名
    var bankNameStr: String = ""
    ///银行卡号
    var cardNumStr: String = ""
    ///姓名
    var nameStr: String = ""
    ///身份证号
    var IDCardStr: String = ""
    ///电话号码
    var phoneStr: String = ""
    ///验证码
    var codeStr: String = ""
    
    @objc func chooseBankClick()  {
        
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
            self.conerClick()
        }
        
        
        let pickerContainerH :CGFloat = 250
        let pickerContainer = DDBankContainer(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: pickerContainerH))
        pickerContainer.delegate = self
        pickerContainer.cancleBtn.addTarget(self, action: #selector(conerClick), for: .touchUpInside)
        pickerContainer.models = self.apiModel?.data
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = .white
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContainerH, width: self.view.bounds.width, height: pickerContainerH)
        }, completion: { (bool ) in
        })
        
    }
    
    @objc func conerClick()  {
        
        self.cover?.removeFromSuperview()
        self.cover = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
