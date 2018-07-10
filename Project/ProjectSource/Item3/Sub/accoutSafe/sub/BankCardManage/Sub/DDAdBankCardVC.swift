//
//  DDAdBankCardVC.swift
//  Project
//
//  Created by WY on 2018/1/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//  首次绑定银行卡


import UIKit
import RxSwift
class DDAdBankCardVC: GDNormalVC, UITextFieldDelegate {

    @IBOutlet var bankName: UILabel!
    
    @IBOutlet var cardNum: UITextField!
    @IBOutlet var promptLabel2: UILabel!
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var topViewHeight: NSLayoutConstraint!


    
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var name: UITextField!
    
    @IBOutlet var IDCard: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var code: UITextField!
    
    
    @IBAction func bankNameTitleTapAction(_ sender: UITapGestureRecognizer) {
        self.chooseBankClick()
    }
    
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        
        self.cardNum.resignFirstResponder()
        self.IDCard.resignFirstResponder()
        self.phone.resignFirstResponder()
        self.code.resignFirstResponder()
        
        
    }
    var doneHandle : (()->())?
    var timer: Timer?
    var leftTime: Int = 60
    var apiModel : ApiModel<[DDBandBrandModel]>?
    var selectedBankBrandModel : DDBandBrandModel?
    weak var cover  : DDCoverView?
    @IBOutlet weak var bandBtn: UIButton!
    var bankNameStr: String = ""
    var cardNumStr: String = ""
    var nameStr: String = ""
    var IDCardStr: String = ""
    var phoneStr: String = ""
    var codeStr: String = ""
    
    
    @IBOutlet var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.scroll.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.top.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()

        self.cardNum.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.cardNumStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.name.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.nameStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.IDCard.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.IDCardStr = title
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
      
    }
    func configTextField() {
        self.verificationBtn.isUserInteractionEnabled = true
        self.name.delegate = self
        self.cardNum.delegate = self
        self.IDCard.delegate = self
        self.phone.delegate = self
        self.code.delegate = self
        
        self.leftView(textField: self.cardNum, leftLabelStr: "  银行卡号")
        self.leftView(textField: self.name, leftLabelStr: "  持卡人")
        self.leftView(textField: self.IDCard, leftLabelStr: "  身份证")
        self.leftView(textField: self.phone, leftLabelStr: " 手机号")
        self.leftView(textField: self.code, leftLabelStr: " 验证码")
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        mylog(self.view.bounds)
    }
    
    ///设置textfield左边的文字
    func leftView(textField: UITextField, leftLabelStr: String) {
        let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("333333"), text: leftLabelStr)
        label.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        textField.leftViewMode = UITextFieldViewMode.always
        textField.leftView = label
        textField.returnKeyType = .done
        
    }
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func noticeClick(_ sender: UIButton) {
        GDAlertView.alert("姓名一经填写,不能修改", image: nil , time: 2, complateBlock: nil )
        self.view.endEditing(true)
    }
    
    @IBAction func sendAuthCodeClick(_ sender: UIButton) {
        self.view.endEditing(true)
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
    
    ///银行ID
    var bankID: String?
    
    
    @objc func chooseBankClick()  {
        self.resign()
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
    @IBAction func scrollTap(_ sender: UITapGestureRecognizer) {
        self.resign()
    }
    func resign() {
        self.name.resignFirstResponder()
        self.IDCard.resignFirstResponder()
        self.phone.resignFirstResponder()
        self.code.resignFirstResponder()
        self.cardNum.resignFirstResponder()
    }
    

    
}

///textfield代理方法
extension DDAdBankCardVC {
    
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DDKeyBoardHandler.manager.keyboardY > 0 {
            DDKeyBoardHandler.manager.configContentSet(containerView: textField, inputView: self.scroll)
        }else {
            DDKeyBoardHandler.manager.zkqsetViewToBeDealt(containerView: textField, inPutView: self.scroll)
        }
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        return true
        //        if textField ==  name{
        //            if (name.text?.count ?? 0) > 6 {
        //                GDAlertView.alert("请输入2到6个汉字的姓名", image: nil, time: 2, complateBlock: nil)
        //                return false
        //            }else {return true }
        //        }else if textField ==  cardNum{
        //            //^([1-9]{1})(\d{14}|\d{18})$
        //            let regex = "^([1-9]{1})(\\d{14}|\\d{18})$"
        //            let regextext = NSPredicate.init(format: "SELF MATCHES %@", regex)
        //            let result: Bool = regextext.evaluate(with: cardNum.text ?? "")
        //            return true
        //        }else if textField == mobile {
        //            if (mobile.text?.count ?? 0) > 11{return false }else{return true }
        //        }else if textField == authCode {
        //            if (authCode.text?.count ?? 0) > 6{return false }else{return true }
        //        }else{return true }
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        DDKeyBoardHandler.share.setViewToBeDealt(containerView: self.scroll, inPutView: textField)
//        return true
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        mylog(textField.placeholder)
        //        if textField ==  name{
        //            if (name.text?.count ?? 0) > 6 || (name.text?.count ?? 0) < 2{
        //                GDAlertView.alert("请输入2到6个汉字的姓名", image: nil, time: 2, complateBlock: nil)
        //            }
        //        }else if textField ==  cardNum{
        //            let result: Bool = (cardNum.text ?? "").bankCardCheck()
        //            if !result  {
        //                GDAlertView.alert("银行卡号不正确", image: nil, time: 2, complateBlock: nil)
        //            }
        //        }else if textField == mobile {
        //            if let lawful =  mobile.text?.mobileLawful(),lawful == false {
        //                GDAlertView.alert("请输入正确手机号", image: nil, time: 2, complateBlock: nil)
        //            }
        //        }else if textField == authCode {
        //            if (authCode.text?.count ?? 0) != 6{GDAlertView.alert("请输入6位数字的验证码", image: nil, time: 2, complateBlock: nil) }
        //        }else{
        //
        //        }
    }
    
    
}



extension DDAdBankCardVC {
    func didSelectModel(model: DDBandBrandModel) {
        self.bankName.text = model.name
        self.bankNameStr = model.name ?? ""
        self.bankID = model.id
        self.cover?.remove()
        self.cover = nil
    }
    
    
    ///点击发送验证码按钮
    @objc func verficationActin(btn: UIButton) {
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
    @IBAction func bandBtnClick(_ sender: UIButton) {
        sender.isEnabled = false
        if self.nameStr.count == 0 {
            GDAlertView.alert("姓名为空", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }else if self.cardNumStr.count == 0 {
            GDAlertView.alert("银行卡号为空", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }else if self.bankNameStr.count == 0  {
            GDAlertView.alert("银行名称为空", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }else if self.phoneStr.count == 0  {
            GDAlertView.alert("手机号为空", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }else if self.codeStr.count == 0  {
            GDAlertView.alert("验证码为空", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        
        if !self.nameStr.userNameLawful() {
            GDAlertView.alert("请输入2到6位汉字的用户名", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        if !(self.cardNumStr.bankCardCheck())  {
            GDAlertView.alert("请输入正确的银行卡号", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        if !self.codeStr.authoCodeLawful() {
            GDAlertView.alert("请输入验证码", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        if !self.phoneStr.mobileLawful() {
            GDAlertView.alert("请输入正确的手机号", image: nil, time: 2, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        if self.bankID == nil {
            GDAlertView.alert("没有选择正确的银行", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        if !self.IDCardStr.idCardLawful() {
            GDAlertView.alert("身份证号格式不对", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        
        let paramete = ["token": token, "bank": self.bankID! , "card_num": self.cardNumStr, "truename": self.nameStr, "id_num": self.IDCardStr, "mobile": self.phoneStr, "code": self.codeStr]
        let router = Router.post("Mttupdateinfo/bindcard", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            sender.isEnabled = true
            if model.status == 200 {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: { [weak self] in
                    self?.popToPreviousVC()
                })
                
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            sender.isEnabled = true
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }

    
}

///////////

protocol DDBankChooseDelegate : NSObjectProtocol {
    
    func didSelectRowAt(indexPath : IndexPath)
    func didSelectRowAt(indexPath: IndexPath, target: UIView?)
    func didSelectModel(model: DDBandBrandModel)
    
    
}
extension DDBankChooseDelegate {
    func didSelectRowAt(indexPath : IndexPath){}
    func didSelectRowAt(indexPath: IndexPath, target: UIView?){}
    func didSelectModel(model: DDBandBrandModel){}
}

extension DDAdBankCardVC : DDBankChooseDelegate {


}

class DDLevelCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(myTitleLabel)
        self.contentView.addSubview(self.myImageView)
        self.myTitleLabel.sizeToFit()
        
        self.myImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(SCREENWIDTH / 2.0 - 70)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        self.myTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.myImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        self.myImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
    }
    var model: DDBandBrandModel? {
        didSet{
            self.myTitleLabel.text = model?.name
            if let image = model?.icon {
                self.myImageView.sd_setImage(with: imgStrConvertToUrl(image))
            }
           
            
            
        }
    }
    
    
    let myImageView: UIImageView = UIImageView.init()
    let myTitleLabel: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
