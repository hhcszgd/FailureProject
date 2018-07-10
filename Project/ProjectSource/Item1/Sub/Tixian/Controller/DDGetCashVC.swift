//
//  DDGetCashVC.swift
//  Project
//
//  Created by WY on 2018/1/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
enum GetCashType : Int {
    case getingCash
    case noBankCard
    case getCashSuccess
    case getCashFailure
}
class DDGetCashVC: DDNormalVC {
    var apiModel : ApiModel<DDGetCashPageDataModel>?
    var mobileCode : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现"
        self.view.addSubview(backgroundTextfield)
        self.backgroundTextfield.delegate = self
        self.layoutNoBankCard()
        self.layoutGetCash()
        self.layoutGetCashResult()
//        self.switchStatus(status: .getingCash)
        requestApi()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated )
        if noBankCardContainer.isHidden == false {
            requestApi()
        }
    }
    func switchStatus(status : GetCashType)  {
        switch status {
        case .noBankCard:
            getCashResultContainer.isHidden = true
            getCashContainer.isHidden = true
            noBankCardContainer.isHidden = false
        case .getingCash:
            getCashResultContainer.isHidden = true
            getCashContainer.isHidden = false
            noBankCardContainer.isHidden = true
        case .getCashSuccess:
            getCashResultContainer.isHidden = false
            getCashContainer.isHidden = true
            noBankCardContainer.isHidden = true
            getCashResultReason.isHidden = true
            getCashResultConfirm.frame = CGRect(x: 60, y: getCashLog.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
//            if getCashResultReason.isHidden {
//                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultBank.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
//            }else{
//                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultReason.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
//            }
            self.setValueToUIAfterGetCash()
            
        case .getCashFailure:
            getCashResultContainer.isHidden = false
            getCashContainer.isHidden = true
            noBankCardContainer.isHidden = true
            getCashResultReason.isHidden = false
            if getCashResultReason.isHidden {
                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultBank.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
            }else{
                getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultReason.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
            }
        }
    }
    func setValueToUIAfterGetCash() {
        getCashResultMoney.text = "提现金额:¥ \(self.moneyInput.text ?? "")"
        var mutableAttributeStr = NSMutableAttributedString.init()
        mutableAttributeStr.append(NSAttributedString.init(string: "提现账户 : "))
        if let bankLogo = self.bankLogo.image{
            let logoAtt = bankLogo.imageConvertToAttributedString(bounds: CGRect(x: 0, y: -4, width: getCashResultBank.font.lineHeight, height: getCashResultBank.font.lineHeight))
            mutableAttributeStr.append(logoAtt)
        }
        if let bankNum  = self.apiModel?.data?.card_number , bankNum.count >= 4{
            let num = bankNum.suffix(from:bankNum.index(bankNum.endIndex, offsetBy: -4) )
            let numAttribute = NSAttributedString.init(string: " \(self.apiModel?.data?.bank ?? "") 尾号 (\(num))")
            mutableAttributeStr.append(numAttribute)
//            getCashResultBank.text = "提现账户 : \(self.apiModel?.data?.bank_name ?? "") 尾号 (\(num))"
            
        }else{
            let numAttribute = NSAttributedString.init(string: "\(self.apiModel?.data?.bank ?? "") 尾号 (\(self.apiModel?.data?.card_number ?? ""))")
            mutableAttributeStr.append(numAttribute)
//            getCashResultBank.text = "提现账户 : \(self.apiModel?.data?.bank_name ?? "") 尾号 (\(self.apiModel?.data?.number ?? ""))"
        }
        getCashResultBank.attributedText = mutableAttributeStr
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func requestApi() {
        mylog("请求接口")
        DDRequestManager.share.getCashPageApi(type: ApiModel<DDGetCashPageDataModel>.self) { (model ) in
//            let temp = DDGetCashPageDataModel()
//            temp.bank = "中国银行"
//            temp.card_number = "68451323241"
//            model?.data?.balance = "20"
//            temp.id = "3333"
//            model?.data = temp
            if model?.status ?? 0 == 200 {
                
                self.apiModel = model
                self.setValueToUI()
            }else{
                GDAlertView.alert(model?.message, image: nil , time: 2 , complateBlock: nil )
            }
        }
//        DDRequestManager.share.getCashPage(true)?.responseJSON(completionHandler: { (response) in
//            if let apiModel = DDJsonCode.decodeAlamofireResponse(ApiModel<DDGetCsahApiDataModel>.self, from: response){
//                self.apiModel = apiModel
//                self.setValueToUI()
//            }
//
//        })
    }
    
    
    
    
    let noBankCardContainer = UIView()
    let noBankNoticeLabel = UILabel()
    let bandBankButton = UIButton()
    
    let getCashContainer = UIView()
    let bankLogo = UIImageView()
    let bankName = UILabel()
    let bankNumber = UILabel()
    let arrowBtn = UIButton()
    let line = UIView()
    let getCashNum = UILabel()
    
    let line2 = UIView()
    let rmbLogo = UILabel()
    let moneyInput = UITextField()
    
    let getCashEnableNum = UIButton()
    let getCashButton = UIButton()
    
    
    let getCashResultContainer = UIView()
    let getCashResultLabel = UILabel()
    let getCashResultTimeLabel = UILabel()
    let getCashLog = UIButton()//新增
    let getCashResultImage = UIImageView()
    let getCashResultMoney = UILabel()
    let getCashResultBank = UILabel()
    let getCashResultReason = UILabel()
    let getCashResultConfirm = UIButton()
    
    let backgroundTextfield = UITextField()
    let accessoryView = DDInputAccessoryView(frame: CGRect(x: 0, y: 0, width: 330, height: 92))
    
}

extension DDGetCashVC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DDKeyBoardHandler.share.setViewToBeDealt(containerView: getCashContainer, inPutView: textField)
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
        
        if let banlance = self.apiModel?.data?.balance{
            let nsBanlance = NSString.init(string: banlance)
            let banlanceFloat = nsBanlance.floatValue

            let nsStr  = NSString.init(string: Str)
            let strFloat = nsStr.floatValue
            if Str.hasSuffix(".") || Str.hasPrefix(".") || strFloat == 0{
                self.getCashButton.isEnabled = false
                self.getCashButton.backgroundColor = UIColor.lightGray
                let arrribute = ["可提现金额 : \(banlance)元",",全部提现"].setColor(colors: [UIColor.DDSubTitleColor , UIColor.DDThemeColor])
                self.getCashEnableNum.setAttributedTitle(arrribute, for: UIControlState.normal)
//                self.getCashEnableNum.attributedText = arrribute
//                self.getCashEnableNum.text = "可提现金额 : \(banlance)元"
//                self.getCashEnableNum.textColor  = UIColor.DDSubTitleColor
                return
            }else{

                self.getCashButton.isEnabled = true
                self.getCashButton.backgroundColor = UIColor.orange
            }

            if banlanceFloat < strFloat {//有小数点不好判断
//                self.getCashEnableNum.setTitleColor(UIColor.red , for: UIControlState.disabled)
//                self.getCashEnableNum.setTitle("输入金额超过提现金额", for: UIControlState.disabled)
                self.getCashButton.isEnabled = false
                self.getCashButton.backgroundColor = UIColor.lightGray
            }else{
                let arrribute = ["可提现金额 : \(banlance)元",",全部提现"].setColor(colors: [UIColor.DDSubTitleColor , UIColor.DDThemeColor])
                self.getCashEnableNum.setAttributedTitle(arrribute, for: UIControlState.normal)
//                self.getCashEnableNum.attributedText = arrribute
//                self.getCashEnableNum.text = "可提现金额 : \(banlance)元,全部提现"
//                self.getCashEnableNum.textColor  = UIColor.DDSubTitleColor
                self.getCashButton.isEnabled = true
                self.getCashButton.backgroundColor = UIColor.orange
            }
        }
        
    }
    struct  PasswordSetedStatus : Codable{
        var name : String
        var status : Int
    }
    /// name    手机号    string
    /// status    状态(1:已设置，0:未设置)    int
    func whetherSetPayPassword(hasSetCallBack:@escaping ()->()) {
        DDRequestManager.share.whetherSetPayPassword(type: ApiModel<PasswordSetedStatus>.self) { (model ) in
            if model?.data?.status == 0 {// 未设置
                self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC" , userInfo: VCActionType.changePayPassword)
            }else {
                hasSetCallBack()
            }
        }
    }
    @objc func getCashButtonClick(sender:UIButton) {
        self.whetherSetPayPassword {
            if Float(self.moneyInput.text ?? "0")! > 2000 {
                mylog("做限额")
                self.view.endEditing(true)
                DDRequestManager.share.sentCode(type: ApiModel<String>.self , mobile: self.apiModel?.data?.mobile ?? "", complate: { (model ) in
                    dump(model)
                    if model?.status ?? 0 == 200{
                        let alert = DDGetCashLimitVC.init(superView: self.view)
                        alert.mobile = self.apiModel?.data?.mobile
                        alert.actionHandle = {[ weak self ] para in
                            mylog(para )
                            if  let result = para as? String , result.count > 0  {
                                self?.mobileCode = result
//                                if (self?.backgroundTextfield.canBecomeFirstResponder) ?? false{
//                                    self?.backgroundTextfield.becomeFirstResponder()
//                                }
                                self?.payPasscodeInput()
                            }
                        }
                    }else{
                        GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil )
                    }
                })
                
            }else{
                self.payPasscodeInput()
//                if self.backgroundTextfield.canBecomeFirstResponder{
//                    self.backgroundTextfield.becomeFirstResponder()
//                }
            }
        }
        
    }
    
    func payPasscodeInput()  {
        let psdInput =  DDPayPasswordInputView(superView: self.view)
        psdInput.isHiddenComplateInput = false
        psdInput.passwordComplateHandle = { [weak self ] password in
            
            mylog(password)
            mylog("验证密码是否正确")
            
            let para =  (name:self?.apiModel?.data?.bank ?? "",card_number:self?.apiModel?.data?.card_number ?? "",price:self?.moneyInput.text ?? "",payPassword:password , code : self?.mobileCode)
            DDRequestManager.share.performGetCash(type: ApiModel<String>.self, para: para, complate: { (model) in
                dump(model)
                if model?.status == 200 {
                    self?.view.endEditing(true )
                    psdInput.remove()
                    self?.switchStatus(status: GetCashType.getCashSuccess)
                    DDNotification.postGetCashSuccess()
                }else{
                    GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil)
                }
            })
        }
        
        psdInput.forgetHandle = {[weak self ]  in
            self?.view.endEditing(true )
            
            self?.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC")
        }
        psdInput.cancleHandle = {[weak self ]  in
//            self?.view.endEditing(true )
//            self?.requestApi()
        }
    }
}
import SDWebImage
extension DDGetCashVC {
    
    @objc func getAllBalance() {
        mylog("全部提现")
        if let banlance = self.apiModel?.data?.balance{
            self.moneyInput.text = banlance
            self.getCashButton.isEnabled = true
            self.getCashButton.backgroundColor = UIColor.orange
            self.getCashButtonClick(sender: self.getCashButton)
        }
    }
    
    func setValueToUI(){
        if let id = self.apiModel?.data?.id {
            self.switchStatus(status: GetCashType.getingCash)
            
            if let url  = URL(string:self.apiModel?.data?.icon ?? "") {
                bankLogo.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                bankLogo.image = DDPlaceholderImage
            }
            
            if let banlance = self.apiModel?.data?.balance{
//                self.getCashEnableNum.text = "可提现额度 : \(banlance)"
                let arrribute = ["可提现金额 : \(banlance)元",",全部提现"].setColor(colors: [UIColor.DDSubTitleColor , UIColor.DDThemeColor])
                self.getCashEnableNum.setAttributedTitle(arrribute, for: UIControlState.normal)
//                self.getCashEnableNum.attributedText = arrribute
            }
            
            if let bankName  = self.apiModel?.data?.bank{
                self.bankName.text = bankName
            }
            if let bankNum  = self.apiModel?.data?.card_number , bankNum.count >= 4{
                let num = bankNum.suffix(from:bankNum.index(bankNum.endIndex, offsetBy: -4) )
                self.bankNumber.text = "尾号 (\(num))"
            }else{
                self.bankNumber.text = "尾号 (\(self.apiModel?.data?.card_number ?? ""))"
            }
            
            
        }else{
            self.switchStatus(status: GetCashType.noBankCard)
        }
    }
    
    func layoutGetCashResult() {
        self.view.addSubview(getCashResultContainer)
        getCashResultContainer.isHidden = true
        getCashResultContainer.addSubview(getCashResultLabel)
        getCashResultContainer.addSubview(getCashResultImage)
        getCashResultContainer.addSubview(getCashResultTimeLabel)
        getCashResultContainer.addSubview(getCashLog)
        getCashLog.addTarget(self , action: #selector(getCashHistory), for: UIControlEvents.touchUpInside)
//        getCashResultContainer.addSubview(getCashResultMoney)
//        getCashResultContainer.addSubview(getCashResultBank)
//        getCashResultContainer.addSubview(getCashResultReason)
        getCashResultContainer.addSubview(getCashResultConfirm)
        let containerMargin : CGFloat = 10
        getCashResultContainer.frame = CGRect(x: containerMargin, y:DDNavigationBarHeight + containerMargin, width: self.view.bounds.width - containerMargin  * 2, height: 400)
        getCashResultContainer.layer.borderWidth = 2
        getCashResultContainer.layer.borderColor = UIColor.DDLightGray.cgColor
        
        getCashResultImage.frame = CGRect(x: (getCashResultContainer.bounds.width - 180) / 2, y:  10, width: 180, height: 180)
        
        getCashResultLabel.text = "提现申请已提交"
        getCashResultLabel.textAlignment = .center
        getCashResultLabel.font = GDFont.systemFont(ofSize: 20)
        getCashResultLabel.textColor = UIColor.DDThemeColor
        getCashResultLabel.frame = CGRect(x:  0, y: getCashResultImage.frame.maxY, width: getCashResultContainer.bounds.width, height: 44)
        getCashResultTimeLabel.frame = CGRect(x: 0, y: getCashResultLabel.frame.maxY, width: getCashResultContainer.bounds.width, height: 20)
        getCashResultTimeLabel.text = "银行处理中,预计将在1~5个工作日内到账"
        getCashResultTimeLabel.textAlignment = .center
        getCashResultTimeLabel.textColor = UIColor.DDSubTitleColor
        getCashLog.setTitle("提现记录", for: UIControlState.normal)
        getCashLog.setTitleColor(UIColor.DDThemeColor, for: UIControlState.normal)
        getCashLog.bounds = CGRect(x: 0, y: 0, width: 94, height: 40)
        getCashLog.center = CGPoint(x: self.getCashResultContainer.bounds.width/2, y: self.getCashResultTimeLabel.frame.maxY  + 30 )
        
        getCashResultTimeLabel.font = GDFont.systemFont(ofSize: 14)
//        getCashResultImage.frame = CGRect(x: (getCashResultContainer.bounds.width - 80) / 2, y: getCashResultTimeLabel.frame.maxY + 20, width: 80, height: 80)
        getCashResultImage.image = UIImage(named:"successicon")
//        getCashResultMoney.text = "提现金额:¥ 150"
//        getCashResultMoney.frame = CGRect(x: 20, y: getCashResultImage.frame.maxY + 40, width: getCashResultContainer.width - 40, height: 40)
//
//        getCashResultBank.text = "提现账户 : 建设银行 尾号 (0234)"
//        getCashResultBank.frame = CGRect(x: 20, y: getCashResultMoney.frame.maxY , width: getCashResultContainer.width - 40, height: 40)
//        getCashResultBank.adjustsFontSizeToFitWidth = true
//        getCashResultReason.text = "提现失败 失败原因 网络问题"
//        getCashResultReason.frame = CGRect(x: 40, y: getCashResultBank.frame.maxY , width: getCashResultContainer.width - 40, height: 40)
        
        getCashResultConfirm.backgroundColor = UIColor.DDThemeColor
        getCashResultConfirm.setTitle("继续提现", for: UIControlState.normal)
        getCashResultConfirm.addTarget(self , action: #selector(confirmAfterGetCashSuccess), for: UIControlEvents.touchUpInside)
         getCashResultConfirm.frame = CGRect(x: 60, y: getCashLog.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
//        if getCashResultReason.isHidden {
//            getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultBank.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
//        }else{
//            getCashResultConfirm.frame = CGRect(x: 60, y: getCashResultReason.frame.maxY + 30, width: getCashResultContainer.width - 60 * 2, height: 44)
//        }
        
    }
    @objc func confirmAfterGetCashSuccess() {
        requestApi()
        self.moneyInput.text = nil
        self.getCashButton.isEnabled = false
        self.getCashButton.backgroundColor = .lightGray
        self.switchStatus(status: GetCashType.getingCash)
    }
    @objc func getCashHistory() {
        
        self.navigationController?.pushVC(vcIdentifier: "TransactionInfoVC", userInfo: nil )
    }
    
    func layoutGetCash() {
        self.view.addSubview(getCashContainer)
        getCashContainer.isHidden = true
        getCashContainer.addSubview(bankLogo)
        getCashContainer.addSubview(bankName)
        getCashContainer.addSubview(bankNumber)
        getCashContainer.addSubview(line)
        getCashContainer.addSubview(arrowBtn)
        
        getCashContainer.addSubview(getCashNum)
        getCashContainer.addSubview(line2)
        getCashContainer.addSubview(rmbLogo)
        getCashContainer.addSubview(moneyInput)
        moneyInput.delegate = self
        getCashContainer.addSubview(getCashEnableNum)
        getCashEnableNum.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        getCashEnableNum.addTarget(self , action:#selector(getAllBalance), for: UIControlEvents.touchUpInside)
        getCashEnableNum.contentHorizontalAlignment = .left
        getCashContainer.addSubview(getCashButton)
        
        let containerMargin : CGFloat = 10
        getCashContainer.frame = CGRect(x: containerMargin, y:DDNavigationBarHeight + containerMargin, width: self.view.bounds.width - containerMargin  * 2, height: 400)
        getCashContainer.layer.borderWidth = 2
        getCashContainer.layer.borderColor = UIColor.DDLightGray.cgColor
        
        bankLogo.frame = CGRect(x: containerMargin, y: containerMargin, width: 64, height: 64)
        bankLogo.layer.cornerRadius = bankLogo.bounds.width/2
        bankLogo.layer.masksToBounds = true
        bankName.frame = CGRect(x: bankLogo.frame.maxX + 10, y: bankLogo.frame.minY, width: getCashContainer.bounds.width
            - (bankLogo.frame.maxX + 10), height: 30)
        bankName.textColor = UIColor.DDSubTitleColor
        bankNumber.frame = CGRect(x: bankName.frame.minX, y: bankLogo.frame.midY, width: bankName.frame.width, height: bankName.frame.height)
        bankNumber.textColor = UIColor.DDSubTitleColor
        arrowBtn.frame = CGRect(x: getCashContainer.bounds.width - 44 - containerMargin, y: bankLogo.frame.midY - 44/2, width: 44, height: 44)
        
        line.frame = CGRect(x: 0, y: bankLogo.frame.maxY + containerMargin, width: getCashContainer.bounds.width, height: 2)
        line.backgroundColor = UIColor.DDLightGray
        getCashNum.frame = CGRect(x: bankLogo.frame.minX, y: line.frame.maxY + 10, width: getCashContainer.bounds.width - bankLogo.frame.minX, height: 44)
        getCashNum.text = "提现金额"
        getCashNum.textColor = UIColor.DDTitleColor
        line2.frame = CGRect(x: 30, y: getCashNum.frame.maxY + 64, width: getCashContainer.bounds.width - 30 * 2, height: 2)
        line2.backgroundColor = UIColor.DDLightGray
        rmbLogo.frame = CGRect(x: line2.frame.minX, y: line2.frame.minY - 44, width: 44, height: 44)
        moneyInput.frame = CGRect(x: rmbLogo.frame.maxX, y: rmbLogo.frame.minY, width: line.bounds.width - rmbLogo.frame.maxX, height: 44)
        getCashEnableNum.frame = CGRect(x: line2.frame.minX, y: line2.frame.maxY, width: line2.frame.width, height: 44)
//        getCashEnableNum.textColor = UIColor.DDSubTitleColor
        getCashButton.frame = CGRect(x: 60, y: getCashContainer.bounds.height - 44 - 10, width: getCashContainer.width - 60 * 2, height: 44)
        bankName.text = "建设银行"
        bankNumber.text = "尾号 (2348)"
        
        arrowBtn.setImage(UIImage(named:"enterthearrow"), for: UIControlState.normal)
        arrowBtn.addTarget(self , action: #selector(chooseBankCard), for: UIControlEvents.touchUpInside)
        rmbLogo.text = "¥"
        rmbLogo.font = GDFont.systemFont(ofSize: 30)
        moneyInput.placeholder = "请输入提现金额"
        moneyInput.font = GDFont.systemFont(ofSize: 26)
//        getCashEnableNum.text = "可提现额度 : "
        getCashButton.setTitle("确认提现", for: UIControlState.normal)
        getCashButton.backgroundColor = .lightGray
        getCashButton.isEnabled = false
//        bankLogo.image = UIImage(named:"installbusinessicons")
        moneyInput.keyboardType = .decimalPad
        
        backgroundTextfield.keyboardType = .numberPad
        backgroundTextfield.clearsOnBeginEditing = true
        backgroundTextfield.inputAccessoryView = accessoryView
        accessoryView.passwordComplateHandle = {[weak self ] password in
            mylog(password)
            mylog("验证密码是否正确")
            
            let para =  (name:self?.apiModel?.data?.bank ?? "",card_number:self?.apiModel?.data?.card_number ?? "",price:self?.moneyInput.text ?? "",payPassword:password , code : self?.mobileCode)
            DDRequestManager.share.performGetCash(type: ApiModel<String>.self, para: para, complate: { (model) in
                dump(model)
                if model?.status == 200 {
                    self?.view.endEditing(true )
                    self?.switchStatus(status: GetCashType.getCashSuccess)
                    DDNotification.postGetCashSuccess()
                }else{
                    GDAlertView.alert(model?.message, image: nil , time: 2, complateBlock: nil)
                }
            })
            // perform request api
//            DDRequestManager.share.getCashAction(bank_id: self.apiModel?.data?.id ?? "", price: self.moneyInput.text ?? "", payment_password: password)?.responseJSON(completionHandler: { (response ) in
//                mylog(response.debugDescription)
//
//                switch response.result {
//                case  .success:
//                    if let dict = response.value as? [String : Any]{
//                        if let code = dict["status"] as? Int , code == 200{
//                            self.switchStatus(status: GetCashType.getCashSuccess)
//                            NotificationCenter.default.post(name: NSNotification.Name.init("GetCashSuccess"), object: nil )
//                        }else{
//                            if let msg = dict["message"] as? String{
//                                GDAlertView.alert(msg, image: nil , time: 2, complateBlock: nil )
//                            }
//                        }
//                    }
//                case .failure:
//                    GDAlertView.alert("请求失败", image: nil , time: 2, complateBlock: nil )
//                }
//            })
        }
        accessoryView.cancleHandle = {
            self.view.endEditing(true )
        }
        accessoryView.forgetHandle = {[weak self ]  in
            self?.backgroundTextfield.text = ""
            self?.view.endEditing(true )
            
            self?.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC")
        }
        self.tempKeyboardHid()
        getCashButton.addTarget(self , action: #selector(getCashButtonClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    func tempKeyboardHid() {
//        DDKeyBoardHandler.share.setViewToBeDealt(containerView: getCashContainer, inPutView: moneyInput)
    }
    @objc func chooseBankCard() {
        mylog("choose bank card")
        let chooseBankVC = DDChooseBankListVC()
        chooseBankVC.doneHandle = {[weak self ] model in
            self?.apiModel?.data?.id = model.id
            self?.apiModel?.data?.bank = model.bank
            self?.apiModel?.data?.icon = model.icon
            self?.apiModel?.data?.card_number = model.card_number
            self?.setValueToUI()
//            mylog(model.bank_name)
        }
        self.navigationController?.pushViewController(chooseBankVC, animated: true )
    }

    func layoutNoBankCard() {
        noBankCardContainer.isHidden = true
        self.view.addSubview(noBankCardContainer)
        noBankCardContainer.addSubview(noBankNoticeLabel)
        noBankCardContainer.addSubview(bandBankButton)
        mylog(self.view.bounds)
        self.noBankCardContainer.frame = self.view.bounds
        self.noBankNoticeLabel.frame = CGRect(x: 0, y: noBankCardContainer.bounds.height/2 - 20 - 44, width: noBankCardContainer.bounds.width, height: 44)
        
        self.bandBankButton.frame = CGRect(x: 60, y: noBankCardContainer.bounds.height/2 + 20, width: noBankCardContainer.bounds.width - 120, height: 44)
        noBankNoticeLabel.textColor = UIColor.DDSubTitleColor
        noBankNoticeLabel.text = "您还没有绑定银行卡,请先绑定银行卡"
        noBankNoticeLabel.textAlignment = .center
        
        bandBankButton.setTitle("绑定银行卡", for: UIControlState.normal)
        bandBankButton.backgroundColor = UIColor.orange
        bandBankButton.addTarget(self , action: #selector(gotoBandBankCard), for: UIControlEvents.touchUpInside)
    }
    @objc func gotoBandBankCard()  {
        let vc = DDAdBankCardVC()
        vc.doneHandle = {[weak self] in
            self?.requestApi()//to do after add bank card
        }
        self.navigationController?.pushViewController(vc, animated: true )
    }

}

class DDInputAccessoryView: UIView {
    var inputString = ""{
        didSet{
            mylog(inputString)
            
            for ( index ,label)  in bottomContaienr.subviews.enumerated() {
                if let label = label as? UILabel{
                    if  index == bottomContaienr.subviews.count - 1{//最后一个
                        if  index == inputString.count - 1{
                            label.text = "*"
                            let str = inputString
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                                self.passwordComplateHandle?(str)
                                self.inputString = ""
                                self.clear()
                                
                            })
                        }
                    }else{
                        if  index <= inputString.count - 1{
                            label.text = "*"
                        }else{
                            label.text = nil
                        }
                    }
                }
            }
            
            
            
//            for ( index ,label)  in bottomContaienr.subviews.enumerated() {
//                if let label = label as? UILabel{
//                    if  index < inputString.count{
//                        label.text = "*"
//                    }else{label.text = nil }
//                }
//            }
//            if inputString.count == bottomContaienr.subviews.count{
//                let str = inputString
//                self.passwordComplateHandle?(str)
//                inputString = ""
//                self.clear()
//            }
        }
    }
    let titleLabel = UILabel()
    let bottomContaienr = UIView()
    let cancleBtn = UIButton()
    let forgetBtn = UIButton()
    var passwordComplateHandle : ((String)->())?
    var cancleHandle : (()->())?
    var forgetHandle : (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame )
        self.addSubview(titleLabel)
        self.addSubview(bottomContaienr)
        self.addSubview(cancleBtn)
        self.addSubview(forgetBtn)
        self.backgroundColor = UIColor.colorWithHexStringSwift("#f7f7f7")
        titleLabel.text = "请输入支付密码"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.DDTitleColor
        forgetBtn.setTitle("忘记密码", for: UIControlState.normal)
        cancleBtn.setTitle("取消", for: UIControlState.normal)
        forgetBtn.addTarget(self , action: #selector(forgetAction), for: UIControlEvents.touchUpInside)
        
        cancleBtn.addTarget(self , action: #selector(cancleAction), for: UIControlEvents.touchUpInside)
        forgetBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        cancleBtn.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        bottomContaienr.backgroundColor = UIColor.colorWithHexStringSwift("#f0f0f0")
        for _  in 0..<6 {
            let label = UILabel()
            bottomContaienr.addSubview(label)
            label.backgroundColor = .white
            label.textAlignment = .center
        }
    }
    
    
    @objc func forgetAction(){
        self.clear()
        self.forgetHandle?()
    }
    
    @objc func cancleAction(){
        self.clear()
        self.cancleHandle?()
    }
    func clear(){
        for ( index ,label)  in bottomContaienr.subviews.enumerated() {
            if let label = label as? UILabel{
                label.text = nil
            }
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.bounds.size
        cancleBtn.frame = CGRect(x: 0, y: 0, width: 44, height: size.height/2)
        forgetBtn.frame = CGRect(x: self.bounds.width - 88, y: 0, width: 88, height: size.height/2)
        titleLabel.frame = CGRect(x: forgetBtn.frame.width, y: 0, width: self.bounds.width - forgetBtn.frame.width * 2, height: size.height/2)
        bottomContaienr.frame = CGRect(x: 0, y: size.height/2, width: size.width, height: size.height/2)
        
        let toTopBorder : CGFloat = 3
        let gerdWH =  (size.height/2 - toTopBorder * 2 )
        let gerdMargin : CGFloat = 5
        let toLeftBorder : CGFloat = ( size.width - gerdWH  * 6 - gerdMargin * 5) / 2
        for (index , label) in bottomContaienr.subviews.enumerated() {
            label.frame = CGRect(x: toLeftBorder + CGFloat(index) * (gerdWH + gerdMargin), y: toTopBorder, width: gerdWH, height: gerdWH)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
