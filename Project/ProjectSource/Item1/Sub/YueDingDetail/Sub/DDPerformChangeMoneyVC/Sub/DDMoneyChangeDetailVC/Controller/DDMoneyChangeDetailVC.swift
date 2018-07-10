//
//  DDMoneyChangeDetailVC.swift
//  Project
//
//  Created by 金曼立 on 2018/4/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDMoneyChangeDetailVC: DDNormalVC {
    
    let changeDetailView = DDMoneyChangeDetailView.init(frame: CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight))
    var dict : [String:String]?
    var changeDetailModel : DDChangeDetailModel?
    var isChangeMoney = false
    var maxY : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改报酬详情"
        dict = self.userInfo as? [String:String]
        self.view.addSubview(changeDetailView)
        changeDetailView.payNumText.delegate = self
        changeDetailView.backNumText.delegate = self
        
        if #available(iOS 11.0, *) {
            self.changeDetailView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        changeDetailView.rightBtnCallBack = { (tag) ->()  in
            switch tag {
            case "7":
                self.stopAppoint()
            case "2":
                self.stopAppoint()
            case "4":
                self.stopAppoint()
            case "3":
                self.acceptChangeMoney()
            default:
                break
            }
        }
        changeDetailView.leftBtnCallBack = { (tag) ->()  in
            switch tag {
            case "7":
//                self.payBtnClick()
                break
            case "2":
                self.acceptSecondMoneyChange()
            case "3":
                self.refuseChangeMoney()
            case "4":
                self.postChangeMoney()
            default:
                break
            }
        }
        
        requestData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillChangeFrame(note: Notification) {
        
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        if maxY > y {
            let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let margin = maxY - y
            UIView.animate(withDuration: duration) {
                self.changeDetailView.scrollView.contentOffset.y = margin + 10 + self.changeDetailView.scrollView.contentOffset.y
            }
            maxY = maxY - margin - 10
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    func requestData() {
        DDRequestManager.share.getChangeMoneyDetail(type: ApiModel<DDChangeDetailModel>.self, orderid: dict?["orderid"] ?? "", fid: dict?["fid"] ?? "") { (model) in
            if model?.status == 200 {
                self.changeDetailModel = model?.data
                self.changeDetailView.detailModel = model?.data
            } else {
                GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
            }
        }
    }
    
    func stopAppoint() {
//        DDAlertVC.showAlert(currentVC: self, title: "终止约定", meg: "终止约定，即与对方解除约定关系，若双方之间存在修改金额则就该金额无效", cancelBtn: "取消", certainBtn: "继续", cancelHandler: nil, certainHandler: {
            let para = ["appointment_id":self.dict?["appointment_id"] ?? ""  , "aid" : self.dict?["aid"] , "bid": self.dict?["bid"]]
            self.navigationController?.pushVC(vcIdentifier: "DDEndAppointVC", userInfo: para)
//        })
    }
    
    // 乙方同意修改，甲方放款
    func payBtnClick() {
        
        DDAlertVC.showAlert(currentVC: self, title: "", meg: "您是否接受对方修改的报酬，接受后放款报酬将按照修改后的报酬进行放款", cancelBtn: "取消", certainBtn: "确定", cancelHandler: nil, certainHandler: {
            if self.changeDetailModel?.set_tag ?? "" == "0" {
                // 未设密码
                self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC", userInfo: VCActionType.changePayPassword)
            } else if self.changeDetailModel?.set_tag ?? "" == "1" {
                // 已设置密码
                let psdInput =  DDPayPasswordInputView(superView: self.view)
                psdInput.passwordComplateHandle = { password in
                    self.view.endEditing(true)
                    DDRequestManager.share.payToPartner(type: ApiModel<String>.self, partnerIDs: [self.dict?["fid"] ?? ""], payword: password, complate: { (model) in
                        if model?.status == 200 {
                            GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: {
                                self.navigationController?.popToSpecifyVC(DDConventionVC.self)
                            })
                        } else {
                            GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                        }
                    })
                }
                psdInput.forgetHandle = {
                    self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC", userInfo: VCActionType.changePayPassword)
                }
            }
        })
    }
    
    // 乙方修改金额，甲方同意并放款
    func acceptSecondMoneyChange() {

        DDAlertVC.showAlert(currentVC: self, title: "", meg: "您是否接受对方修改的报酬，接受后放款报酬将按照修改后的报酬进行放款", cancelBtn: "取消", certainBtn: "确定", cancelHandler: nil, certainHandler: {
            
            // 自动校验  手动不校验
            if self.dict?["lenders"] == "2" {
                
                DDRequestManager.share.checkAutoInvalid(type: ApiModel<DDCheckAutoInvalidModel>.self, orderid: self.dict?["orderid"] ?? "", rid: self.changeDetailModel?.other?.rid ?? "", complate: { (model) in
                    
                    if model?.status == 200 {
                        if model?.data?.invalid == "2" {
                            // 1 有效 未过期     2 无效 过期
                            
                            if self.changeDetailModel?.set_tag ?? "" == "0" {
                                // 未设密码
                                self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC", userInfo: VCActionType.changePayPassword)
                            } else if self.changeDetailModel?.set_tag ?? "" == "1" {
                                // 已设置密码
                                let psdInput =  DDPayPasswordInputView(superView: self.view)
                                psdInput.passwordComplateHandle = { password in
                                    self.view.endEditing(true)
                                    self.acceptSecondMoneyChange(password: password)
                                }
                                psdInput.forgetHandle = {
                                    self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC", userInfo: VCActionType.changePayPassword)
                                }
                            }
                            
                        } else if model?.data?.invalid == "1" {
                            self.acceptSecondMoneyChange(password: "")
                        }
                    } else {
                        GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                    }
                })
            } else if self.dict?["lenders"] == "1" {
                self.acceptSecondMoneyChange(password: "")
            }
        })
    }
    
    func acceptSecondMoneyChange(password : String) {
        DDRequestManager.share.acceptSecondMoneyChange(type: ApiModel<String>.self, orderid:self.dict?["orderid"] ?? "", rid: self.changeDetailModel?.other?.rid ?? "", payword: password, complate: { (model) in
            if model?.status == 200 {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: {
                    self.navigationController?.popToSpecifyVC(DDConventionVC.self)
                })
            } else {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        })
    }
    
    func refuseChangeMoney() {
        // 乙方拒绝甲方修改金额
        if isChangeMoney {
            postChangeMoney()
            return
        }
        DDAlertVC.showAlert(currentVC: self, title: "拒绝提示", meg: "双方若无法达成一致，则均无法得到原定报酬，且拒绝后无法更改报酬，建议您拒绝前先与对方联系，双方协商一致后再填写报酬，以免造成财产损失。", cancelBtn: "取消", certainBtn: "继续拒绝", cancelHandler: nil, certainHandler: {
            self.changeDetailView.setOriginMoney()
            self.changeDetailView.earnerUpdateLayout()
            self.isChangeMoney = true
        })
    }
    
    // 乙方提交自己修改的金额
    func postChangeMoney() {
        self.view.endEditing(true)
        let payNum = self.changeDetailView.payNumText.text
        let backNum = self.changeDetailView.backNumText.text
        if payNum == "" || payNum == nil {
            GDAlertView.alert("实际报酬不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        if backNum == "" || backNum == nil {
            GDAlertView.alert("退回报酬不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        if payNum?.checkDecimalNumberString(string: payNum ?? "") ?? false && backNum?.checkDecimalNumberString(string: backNum ?? "") ?? false {
            let rid = self.changeDetailModel?.info?.rid ?? (self.changeDetailModel?.other?.rid ?? "")
            DDRequestManager.share.refuseMoneyChange(type: ApiModel<String>.self, orderid: self.dict?["orderid"] ?? "", rid: rid, pay_price : payNum ?? "", rest_price : backNum ?? "") { (model) in
                if model?.status == 200 {
                    self.isChangeMoney = false
                    GDAlertView.alert("已通知对方，待对方接受后价格才发生改变", image: nil, time: 1, complateBlock: {
                        self.navigationController?.popToSpecifyVC(DDConventionVC.self, animate: true)
                    })
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
                }
            }
        }
    }
    
    // 乙方接受甲方修改金额
    func acceptChangeMoney() {
        DDRequestManager.share.acceptMoneyChange(type: ApiModel<String>.self, orderid: self.dict?["orderid"] ?? "", rid: self.changeDetailModel?.info?.rid ?? "") { (model) in
            if model?.status == 200 {
                GDAlertView.alert("您已接受对方修改的报酬，接下来放款报酬将按照修改后的报酬发放", image: nil, time: 2, complateBlock: {
                    self.navigationController?.popToSpecifyVC(DDConventionVC.self, animate: true)
                })
            } else {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension DDMoneyChangeDetailVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.changeDetailView.scrollView.contentOffset.y = 0
        if let window = UIApplication.shared.delegate?.window {
            var rect: CGRect = CGRect.zero
            switch textField {
            case changeDetailView.payNumText:
                rect = changeDetailView.payNumText.convert(changeDetailView.payNumText.bounds, to:window)
            case changeDetailView.backNumText:
                rect = changeDetailView.backNumText.convert(changeDetailView.backNumText.bounds, to:window)
            default:
                break
            }
            maxY = rect.maxY
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.changeDetailView.scrollView.contentOffset.y = 0
        switch textField {
        case changeDetailView.payNumText:
            if (changeDetailView.payNumText.text?.checkDecimalNumberString(string: changeDetailView.payNumText.text ?? "")) ?? false {
                let origin = NSString(string: changeDetailModel?.info?.price ?? "").floatValue
                let pay = NSString(string: changeDetailView.payNumText.text ?? "").floatValue
                if pay > origin {
                    GDAlertView.alert("报酬不得大于原定报酬", image: nil, time: 2, complateBlock: nil)
                    changeDetailView.payNumText.text = ""
                } else {
                    let back = origin - pay
                    changeDetailView.payNumText.text = String(format: "%.2f", pay)
                    changeDetailView.backNumText.text = String(format: "%.2f", back)
                }
                return
            }
            changeDetailView.payNumText.text = ""
        case changeDetailView.backNumText:
            if (changeDetailView.backNumText.text?.checkDecimalNumberString(string: changeDetailView.backNumText.text ?? "")) ?? false {
                let origin = NSString(string: changeDetailModel?.info?.price ?? "").floatValue
                let pay = NSString(string: changeDetailView.payNumText.text ?? "").floatValue
                let back = NSString(string: changeDetailView.backNumText.text ?? "").floatValue
                if back > origin {
                    GDAlertView.alert("报酬不得大于原定报酬", image: nil, time: 2, complateBlock: nil)
                    changeDetailView.backNumText.text = ""
                } else if pay + back > origin {
                    GDAlertView.alert("支付报酬和退回报酬之和不得大于原定报酬", image: nil, time: 2, complateBlock: nil)
                    changeDetailView.backNumText.text = ""
                } else {
                    changeDetailView.backNumText.text = String(format: "%.2f", back)
                }
                return
            }
            changeDetailView.backNumText.text = ""
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        maxY = 0
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
//                let result  = inputValue + string
//                self.judgeEnouph(Str: result )
            }
        }else if range.length == 1{//删
            if let text = textField.text {
                var text = text
                text.removeLast()
//                let result = text
//                self.judgeEnouph(Str: result )
            }
        }
        return true
    }
    func judgeEnouph(Str : String ){
        let nsStr  = NSString.init(string: Str)
        let strFloat = nsStr.floatValue
        if Str.hasSuffix(".") || Str.hasPrefix(".") || strFloat == 0{
            changeDetailView.earner.isUserInteractionEnabled = false
            changeDetailView.earner.backgroundColor = UIColor.lightGray
        }else{
            changeDetailView.earner.isUserInteractionEnabled = true
            changeDetailView.earner.backgroundColor = UIColor.DDThemeColor
        }
    }
}
