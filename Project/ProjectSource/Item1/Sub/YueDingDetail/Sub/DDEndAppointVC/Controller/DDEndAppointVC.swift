//
//  DDEndAppointVC.swift
//  Project
//
//  Created by WY on 2018/4/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDEndAppointVC: DDNormalVC {
    
    let endAppointView = DDEndAppointView.init(frame: CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight))
    var maxY : CGFloat = 0.0
    var originMonay : String?
    var endAppoint : DDEndAppointModel?
    var dict : [String:String]?
    var endCount : Int = 0
    var messageIndex : Int = 0
    var specialArr : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "终止约定"
        
        if #available(iOS 11.0, *) {
            self.endAppointView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        let specialWords = "~ · ！ @ # ￥ ¥ ￥ % …… & * （ ） —— + - = { } 【 】 ： “ | ； ‘ 、 《 》 ？ ， 。 、 ~ ` ! @ # $ % ^ & * ( ) _ + - = { } [ ] : \" | ; ' \\ < > ? , . / ￡ ¤ § ¨ 「 」『 』 ￠ ￢ ￣ —— _ €"
        specialArr = specialWords.components(separatedBy:" ")
        
        dict = self.userInfo as? [String:String]
        self.view.addSubview(endAppointView)
        endAppointView.isHidden = true
        
        endAppointView.payNum.delegate = self
        endAppointView.backNum.delegate = self
        endAppointView.stopDeti.delegate = self
        endAppointView.scrollView.delegate = self
        endAppointView.submitBtn.addTarget(self, action: #selector(submitBtnClick), for: UIControlEvents.touchUpInside)
        
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
                self.endAppointView.scrollView.contentOffset.y = margin + 10 + self.endAppointView.scrollView.contentOffset.y
            }
            maxY = maxY - margin - 10
        }
    }
    
    @objc func submitBtnClick(_ sender: UIButton) {
        if endAppointView.payNum.text?.count == 0 {
            GDAlertView.alert("实际报酬不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        if endAppointView.backNum.text?.count == 0 {
            GDAlertView.alert("退回报酬不能为空", image: nil, time: 2, complateBlock: nil)
            return
        }
        let aid = dict?["aid"] ?? ""
        let bid = dict?["bid"] ?? ""
        let oriamount = originMonay ?? ""
        let payamount = endAppointView.payNum.text
        let retamount = endAppointView.backNum.text
        let reason = endAppointView.stopDeti.text
        let vid = endAppoint?.vid
        DDAlertVC.showAlert(currentVC: self, title: "终止约定", meg: "终止约定，即与对方解除约定关系，若双方之间存在修改报酬，则该报酬无效", cancelBtn: "取消", certainBtn: "确定", cancelHandler: nil, certainHandler: {
            DDRequestManager.share.postEndAppointInfo(type: ApiModel<String>.self, aid: aid, bid: bid, Oriamount: oriamount, Payamount: payamount ?? "", Retamount: retamount ?? "", Reason: reason ?? "", vid: vid ?? "") { (model) in
                
                if model?.status == 200 {
                    DDAlertVC.showAlertOneAction(currentVC: self, title: nil, meg: "提交成功，请等待对方回复", cancelBtn: "确定", cancelHandler: {
                        self.navigationController?.popToSpecifyVC(DDConventionVC.self, animate: true)
                    })
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }
        })
    }
    
    func requestData() {
        DDRequestManager.share.getOriginalMonay(type: ApiModel<DDEndAppointModel>.self, appointment_id: dict?["appointment_id"] ?? "", aid: dict?["aid"] ?? "", bid: dict?["bid"] ?? "") { (model) in
            if model?.status == 200 {
                self.endAppointView.isHidden = false
                self.endAppoint = model?.data
                self.endAppointView.appointName.text = model?.data?.full_name
                self.endAppointView.originNumber = model?.data?.account
                let origin = NSString(string: model?.data?.account ?? "").floatValue
                self.originMonay = String(format: "%.2f", origin)
            } else {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DDEndAppointVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        endAppointView.placeHolder.text = ""
        if let window = UIApplication.shared.delegate?.window {
            var rect: CGRect = CGRect.zero
            rect = textView.convert(textView.bounds, to:window)
            maxY = rect.maxY
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            endAppointView.placeHolder.text = "请简要叙述终止约定的原因"
            endAppointView.wordNum.text = "0/200"
            return
        }
//        if self.checkString(string: textView.text) {
//            endAppointView.placeHolder.text = ""
//            let textLength = textView.text.count
//            endAppointView.wordNum.text = "\(textLength)" + "/200"
//            return
//        }
//        GDAlertView.alert("只能输入汉字、数字和英文", image: nil, time: 2, complateBlock: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let maxWords = 200
        var textString = textView.text ?? ""
        var length = textString.count
        
        if textString.contains("\n") && length <= maxWords {
            textString.removeLast()
            length -= 1
            textView.text = textString
            self.view.endEditing(true)
            self.endAppointView.scrollView.contentOffset.y = 0
            return
        }
        if length > maxWords {
            textString = String(textString.prefix(maxWords))
            textView.text = textString
            length = maxWords
        }
//        if checkString(string: textView.text) {
//            if textString.contains("\n") && length <= maxWords {
//                textString.removeLast()
//                length -= 1
//                textView.text = textString
//                self.view.endEditing(true)
//                self.endAppointView.scrollView.contentOffset.y = 0
//                return
//            }
//            if length > maxWords {
//                textString = String(textString.prefix(maxWords))
//                textView.text = textString
//                length = maxWords
//            }
//        } else {
//            let index = textString.index(textString.startIndex, offsetBy: endCount)//获取字符d的索引
//            textString = textString.substring(to: index)
//            textView.text = textString
//            length = textString.count
//        }
        endAppointView.wordNum.text = "\(length)" + "/" + "\(maxWords)"
        endCount = textString.count
    }
    
    func checkString(string : String) -> Bool {
        for word in specialArr {
            if string.contains(word) {
                return false
            }
        }
        return true
    }
}

extension DDEndAppointVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let window = UIApplication.shared.delegate?.window {
            var rect: CGRect = CGRect.zero
            switch textField {
            case endAppointView.payNum:
                rect = endAppointView.payNum.convert(endAppointView.payNum.bounds, to:window)
            case endAppointView.backNum:
                rect = endAppointView.backNum.convert(endAppointView.backNum.bounds, to:window)
            default:
                break
            }
            maxY = rect.maxY
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case endAppointView.payNum:
            if (endAppointView.payNum.text?.checkDecimalNumberString(string: endAppointView.payNum.text ?? "")) ?? false {
                let origin = NSString(string: originMonay ?? "").floatValue
                let pay = NSString(string: endAppointView.payNum.text ?? "").floatValue
                if pay > origin {
                    GDAlertView.alert("报酬不得大于原定报酬", image: nil, time: 2, complateBlock: nil)
                    endAppointView.payNum.text = ""
                } else {
                    let back = origin - pay
                    endAppointView.payNum.text = String(format: "%.2f", pay)
                    endAppointView.backNum.text = String(format: "%.2f", back)
                }
                return
            }
            endAppointView.payNum.text = ""
        case endAppointView.backNum:
            if (endAppointView.backNum.text?.checkDecimalNumberString(string: endAppointView.backNum.text ?? "")) ?? false {
                let origin = NSString(string: originMonay ?? "").floatValue
                let pay = NSString(string: endAppointView.payNum.text ?? "").floatValue
                let back = NSString(string: endAppointView.backNum.text ?? "").floatValue
                if back > origin {
                    GDAlertView.alert("报酬不得大于原定报酬", image: nil, time: 2, complateBlock: nil)
                    endAppointView.backNum.text = ""
                } else if pay + back > origin {
                    GDAlertView.alert("实际报酬和退回报酬之和不得大于原定报酬", image: nil, time: 2, complateBlock: nil)
                    endAppointView.backNum.text = ""
                } else {
                    endAppointView.backNum.text = String(format: "%.2f", back)
                }
                return
            }
            endAppointView.backNum.text = ""
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        maxY = 0
        self.view.endEditing(true)
        self.endAppointView.scrollView.contentOffset.y = 0
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
            endAppointView.submitBtn.isUserInteractionEnabled = false
            endAppointView.submitBtn.backgroundColor = UIColor.lightGray
        }else{
            endAppointView.submitBtn.isUserInteractionEnabled = true
            endAppointView.submitBtn.backgroundColor = UIColor.DDThemeColor
        }
    }
}
