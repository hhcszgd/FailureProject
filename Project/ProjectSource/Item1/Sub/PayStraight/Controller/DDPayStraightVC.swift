//
//  DDPayStraightVC.swift
//  Project
//
//  Created by WY on 2018/4/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPayStraightVC: DDNormalVC {
    var userID = ""
    let container = UIView()
    let icon = UIImageView()
    let name  = UILabel()
    let mobile = UILabel()
    let moneyTips = UILabel()
    var currentAccountMobile : String = ""
    let rmbLogo = UILabel()
    let line = UIView()
    ///金额输入框
    let moneyInput = UITextField()
    let payButton = UIButton()
    
    ///密码输入框
    let backgroundTextfield = UITextField()
    let accessoryView = DDInputAccessoryView(frame: CGRect(x: 0, y: 0, width: 330, height: 88))
    
    var model : ApiModel<DDPartnerInfoModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.DDLightGray
        self.title = "直接付款"
        self.userID = self.userInfo as? String ?? ""
        // Do any additional setup after loading the view.
        _addSubviews()
        self.whetherSetPayPassword {}
        self.requestApi()
    }
    func requestApi() {//DDPartnerInfoModel
        DDRequestManager.share.getPartnerInfo(type: ApiModel<DDPartnerInfoModel>.self , userID: self.userID) { (model ) in
            if model?.status ?? 0 == 200{
                self.model = model
                self.configContent()
                
            }else{
                GDAlertView.alert(model?.message, image: nil , time: 2 , complateBlock: nil)
            }
        }
    }
    func _layoutSubviews(){
       
    }
    
    
    @objc func performPay() {
        mylog("performPay")
    }

    func _addSubviews() {
        self.view.addSubview(container)

        self.view.addSubview(backgroundTextfield)
        backgroundTextfield.keyboardType = .numberPad
        backgroundTextfield.inputAccessoryView = accessoryView
        backgroundTextfield.delegate = self
        accessoryView.passwordComplateHandle = {[weak self ] password in
            self?.backgroundTextfield.text = ""
            mylog(password)
            mylog("联网验证密码是否正确")
           
            let requestPara = ["mid":self?.model?.data?.id ?? (self?.userID)!,"type":"0","price":self?.moneyInput.text ?? "0","payword":password]
            PayManager.share.pay(paremete:requestPara as AnyObject, payMentType: PayMentType.DirectPay, finished: { (payType, para ) in
                mylog(payType)
                mylog(para)
                if para.result {
                     self?.view.endEditing(true )
                    self?.navigationController?.pushVC(vcIdentifier: "DDPayStraightResultVC", userInfo: true)
                }else{
                    GDAlertView.alert(para.failurereason, image: nil , time: 2 , complateBlock: nil )
                }
                
            })
            
        }
        accessoryView.cancleHandle = {[weak self ]  in
            self?.backgroundTextfield.text = ""
            self?.view.endEditing(true )
        }
        accessoryView.forgetHandle = {[weak self ]  in
            self?.backgroundTextfield.text = ""
            self?.view.endEditing(true )
            
            self?.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC")
        }
        container.addSubview(icon)
        container.backgroundColor = .white
        icon.backgroundColor = UIColor.DDLightGray
        container.addSubview(name)
        name.textColor = UIColor.DDTitleColor
        container.addSubview(mobile)
        mobile.textColor = UIColor.DDSubTitleColor
        mobile.font = UIFont.systemFont(ofSize: 14)
        name.textAlignment = .center
        mobile.textAlignment = .center
        container.addSubview(moneyTips)
        moneyTips.text = "直接付款金额"
        moneyTips.textColor = UIColor.DDTitleColor
        container.addSubview(rmbLogo)
        rmbLogo.text = "¥"
        rmbLogo.font = UIFont.systemFont(ofSize: 30)
        container.addSubview(line)
        line.backgroundColor = UIColor.DDThemeColor
        container.addSubview(moneyInput)
        moneyInput.keyboardType = .decimalPad
        moneyInput.delegate = self
        container.addSubview(payButton)
        payButton.setTitle("确定付款", for: UIControlState.normal)
        payButton.backgroundColor = UIColor.DDThemeColor
        
        self.payButton.isEnabled = false
        self.payButton.backgroundColor = UIColor.lightGray
        
        self.payButton.addTarget(self , action: #selector(payButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        let borderMargin : CGFloat = 20
        container.frame = CGRect(x:  borderMargin, y:  DDNavigationBarHeight + borderMargin, width: self.view.bounds.width - borderMargin * 2, height: 353)
        let iconWH : CGFloat = 72
        icon.frame = CGRect(x: container.bounds.width/2 - iconWH/2, y: borderMargin, width: iconWH, height: iconWH)
        name.frame = CGRect(x: 0, y: icon.frame.maxY + borderMargin, width: container.bounds.width, height: 20)
        mobile.frame = CGRect(x: 0, y: name.frame.maxY , width: container.bounds.width, height: 20)
        moneyTips.frame = CGRect(x: borderMargin, y: mobile.frame.maxY + borderMargin * 1.2, width: container.bounds.width/2, height: 30)
        line.frame = CGRect(x: borderMargin, y: moneyTips.frame.maxY + borderMargin * 3, width: container.bounds.width - borderMargin * 2, height: 2)
        rmbLogo.frame = CGRect(x: borderMargin, y: line.frame.minY - 44, width: 44, height: 44)
        moneyInput.frame = CGRect(x: rmbLogo.frame.maxX, y: line.frame.minY - 44, width: container.bounds.width - borderMargin * 2 - rmbLogo.frame.width, height: 44)
        payButton.frame = CGRect(x: borderMargin * 2, y: line.frame.maxY + borderMargin, width: container.bounds.width - borderMargin * 4 , height: 44)
        
        
//        DDKeyBoardHandler.share.setViewToBeDealt(containerView: container, inPutView: moneyInput)
    }
    func configContent() {
       self.icon.setImageUrl(url: self.model?.data?.head_images)
        self.name.text = self.model?.data?.nickname
        self.mobile.text = "(\(self.model?.data?.mobile ?? ""))"
    }

}


extension DDPayStraightVC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DDKeyBoardHandler.share.setViewToBeDealt(containerView: container, inPutView: textField)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        mylog(textField.text)
        mylog(range )
        mylog(string )
        if textField == backgroundTextfield {
            if range.length == 0{//写
                if let text = textField.text {
                    self.accessoryView.inputString = text + string
                }
            }else if range.length == 1{//删
                if let text = textField.text {
                    var text = text
                    text.removeLast()
                    self.accessoryView.inputString = text
                }
            }
        }else if textField == moneyInput{
            
            if range.length == 0{//写
                if let inputValue  = textField.text{
                    if inputValue.contains(".") && string == "."{return false }
                    if let doutRange =  inputValue.range(of: "."){
                        let sub = inputValue.suffix(from:inputValue.index(doutRange.lowerBound, offsetBy: 0) )
                        let str = String(sub)
                        if str.count > 2{
                            return false
                        }
                    }
                    let result  = inputValue + string
                    self.judgeEnouph(Str: result )
                }
            }else if range.length == 1{//删
                if let text = textField.text {
                    var text = text
                    text.removeLast()
                    let result = text
                    self.judgeEnouph(Str: result )
                }
            }
        }
        
        
        return true
    }
    func judgeEnouph(Str : String ){
        
            let nsStr  = NSString.init(string: Str)
            let strFloat = nsStr.floatValue
            if Str.hasSuffix(".") || Str.hasPrefix(".") || strFloat == 0{
                self.payButton.isEnabled = false
                self.payButton.backgroundColor = UIColor.lightGray
            }else{
                self.payButton.isEnabled = true
                self.payButton.backgroundColor = UIColor.DDThemeColor
            }
    }
    /*
    func judgeEnouph(Str : String ){
        
        if let banlance = self.model?.data?.balance{
            let nsBanlance = NSString.init(string: banlance)
            let banlanceFloat = nsBanlance.floatValue

            let nsStr  = NSString.init(string: Str)
            let strFloat = nsStr.floatValue
            if Str.hasSuffix(".") || Str.hasPrefix(".") || strFloat == 0{
                self.getCashButton.isEnabled = false
                self.getCashButton.backgroundColor = UIColor.lightGray
                return
            }else{

                //                self.getCashButton.isEnabled = true
                //                self.getCashButton.backgroundColor = UIColor.orange
            }

            if banlanceFloat < strFloat {//有小数点不好判断
                self.getCashEnableNum.text = "输入金额超过提现金额"
                self.getCashButton.isEnabled = false
                self.getCashEnableNum.textColor  = .red
                self.getCashButton.backgroundColor = UIColor.lightGray
            }else{
                self.getCashEnableNum.text = "可提现额度 : \(banlance)"
                self.getCashEnableNum.textColor  = UIColor.DDSubTitleColor
                self.getCashButton.isEnabled = true
                self.getCashButton.backgroundColor = UIColor.orange
            }
        }
        
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true )
    }
    struct  PasswordSetedStatus : Codable{
        var name : String
        var status : Int
    }
    /// name    手机号    string
    /// status    状态(1:已设置，0:未设置)    int
    func whetherSetPayPassword(hasSetCallBack:@escaping ()->()) {
        DDRequestManager.share.whetherSetPayPassword(type: ApiModel<PasswordSetedStatus>.self) { (model ) in
            self.currentAccountMobile =  model?.data?.name ?? ""
            if model?.data?.status == 0 {// 未设置
                self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC" , userInfo: VCActionType.changePayPassword)
            }else {
                hasSetCallBack()
            }
        }
    }
    
    @objc func payButtonClick(sender:UIButton) {
        if Float(self.moneyInput.text ?? "0")! > 2000 {
            mylog("做限额")
            self.view.endEditing(true)
            DDRequestManager.share.sentCode(type: ApiModel<String>.self , mobile: self.currentAccountMobile, complate: { (model ) in
                dump(model)
                if model?.status ?? 0 == 200{
                    let alert = DDPayLimitView.init(superView: self.view)
                    alert.mobile = self.currentAccountMobile
                    alert.actionHandle = {[ weak self ] para in
                        mylog(para )
                        if let result = para as? String , result == "success"  {
//                            if (self?.backgroundTextfield.canBecomeFirstResponder) ?? false{
//                                self?.backgroundTextfield.becomeFirstResponder()
//                            }
                            self?.choosePayType()
                        }
                    }
                }else{
                    GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil )
                }
            })
            
        }else{
            self.view.endEditing(true)
            let alert = DDPayStraightAssistView.init(superView: self.view)
            alert.money = self.moneyInput.text ?? "0"
            alert.actionHandle = {[ weak self ] para in
                if let payType = para as?  DDPayStraightAssistView.DDPayType {
                    switch payType {
                    case .laoPay:
                        self?.whetherSetPayPassword {
                            if self?.backgroundTextfield.canBecomeFirstResponder ?? false{
                                self?.backgroundTextfield.becomeFirstResponder()
                            }
                        }
                        mylog("捞付余额支付\(self?.moneyInput.text ?? "0")元")
                    case .wechatPay:
                        mylog("微信支付\(self?.moneyInput.text ?? "0")元")
                         let requestPara = ["mid":self?.model?.data?.id ?? "","type":"5","price":self?.moneyInput.text ?? "0"]
                        PayManager.share.pay(paremete:requestPara as AnyObject, payMentType: PayMentType.DirectPay, finished: { (payType, para ) in
                            self?.payResultAction(payType: payType, para: para)
                        })
                    case .alipay:
                        mylog("支付宝 支付\(self?.moneyInput.text ?? "0")元")
                         let requestPara = ["mid":self?.model?.data?.id ?? "","type":"4","price":self?.moneyInput.text ?? "0"]
                        PayManager.share.pay(paremete:requestPara as AnyObject, payMentType: PayMentType.DirectPay, finished: { (payType, para ) in
                            self?.payResultAction(payType: payType, para: para)
                        })
                    }
                }
            }
            
//            if self.backgroundTextfield.canBecomeFirstResponder{
//                self.backgroundTextfield.becomeFirstResponder()
//            }
        }
    }
    func payResultAction(payType: PayMentType, para:PayResult)  {
        if para.result {
            self.navigationController?.pushVC(vcIdentifier: "DDPayStraightResultVC", userInfo: true)
            mylog("支付回到成功")
            
        }else{
            GDAlertView.alert(para.failurereason, image: nil , time: 2, complateBlock: nil )
        }
    }
    func choosePayType() {
        self.view.endEditing(true)
        let alert = DDPayStraightAssistView.init(superView: self.view)
        alert.money = self.moneyInput.text ?? "0"
        alert.actionHandle = {[ weak self ] para in
            if let payType = para as?  DDPayStraightAssistView.DDPayType {
                switch payType {
                case .laoPay:
                    self?.whetherSetPayPassword {
                        if self?.backgroundTextfield.canBecomeFirstResponder ?? false{
                            self?.backgroundTextfield.becomeFirstResponder()
                        }
                    }
                    mylog("捞付余额支付\(self?.moneyInput.text ?? "0")元")
                case .wechatPay:
                    mylog("微信支付\(self?.moneyInput.text ?? "0")元")
                    let requestPara = ["mid":self?.model?.data?.id ?? "","type":"5","price":self?.moneyInput.text ?? "0"]
                    PayManager.share.pay(paremete:requestPara as AnyObject, payMentType: PayMentType.DirectPay, finished: { (payType, para ) in
                        self?.payResultAction(payType: payType, para: para)
                    })
                    
                case .alipay:
                    mylog("支付宝 支付\(self?.moneyInput.text ?? "0")元")
                    let requestPara = ["mid":self?.model?.data?.id ?? "","type":"4","price":self?.moneyInput.text ?? "0"]
                    PayManager.share.pay(paremete:requestPara as AnyObject, payMentType: PayMentType.DirectPay, finished: { (payType, para ) in
                        self?.payResultAction(payType: payType, para: para)
                    })
                }
            }
        }
    }
}


class DDPayLimitView: DDCoverView {
    var mobile : String?{
        didSet{
            var mobileUnwrap = mobile ?? ""
            
            if let temp = mobile{
                if temp.count == 11{
                    mobileUnwrap = temp
                    mobileUnwrap.replaceSubrange( mobile!.index(mobile!.startIndex, offsetBy: 3) ..< mobile!.index(mobile!.endIndex, offsetBy: -4) , with: "****")
                }
                
            }
            self.label.text = "您付款金额超过限额，请输入\(mobileUnwrap)收到的验证码"
        }
    }
    let container = UIView()
    let label = UILabel()
    let inputField = UITextField()
    let cancel = UIButton()
    let button = UIButton()
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(container)
        self.isHideWhenWhitespaceClick = false
        container.addSubview(label)
        label.textColor = .lightGray
        label.numberOfLines = 2
        container.addSubview(inputField)
        container.addSubview(button)
        container.addSubview(cancel)
        button.addTarget(self , action: #selector(continueGetCash(sender:)), for: UIControlEvents.touchUpInside)
        button.setTitle("继续付款", for: UIControlState.normal)
        cancel.setTitle("取消", for: UIControlState.normal)
        button.backgroundColor = UIColor.DDThemeColor
        cancel.backgroundColor = UIColor.DDThemeColor
        cancel.addTarget(self , action: #selector(continueGetCash(sender:)), for: UIControlEvents.touchUpInside)
        container.backgroundColor = .white
        inputField.backgroundColor = UIColor.DDLightGray
        inputField.placeholder = "请输入验证码"
        
    }
    @objc func continueGetCash(sender:UIButton){
        if sender == self.button{
            //验证验证码
            DDRequestManager.share.checkAuthCode(type: ApiModel<String>.self, mobile: self.mobile ?? "", code: self.inputField.text ?? "", complate: { (model ) in
                if model?.status ?? 0 == 200 {
                    self.actionHandle?("success")
                    self.remove()
                }else{
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                }
            })
        }else if sender == self.cancel{
            self.remove()
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toBorderMargin : CGFloat = 20
        let containerW = self.bounds.width - toBorderMargin * 2
        let containerH = containerW * 0.7
        container.bounds = CGRect(x: 0, y: 0, width: containerW, height: containerH)
        container.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2 - container.bounds.height/3)
        cancel.frame = CGRect(x: containerW - 44, y: 0, width: 44, height: 44)
        label.frame  = CGRect(x: toBorderMargin, y: cancel.frame.maxY, width: containerW - toBorderMargin * 2 , height: 64)
        inputField.frame = CGRect(x: toBorderMargin, y: label.frame.maxY, width: containerW - toBorderMargin * 2 , height: 40)
        button.frame = CGRect(x: toBorderMargin * 4, y: containerH - 54, width: containerW - toBorderMargin * 8 , height: 40)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        mylog("death")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
