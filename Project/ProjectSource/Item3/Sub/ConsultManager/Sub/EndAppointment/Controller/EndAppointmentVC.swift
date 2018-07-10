//
//  EndAppointmentVC.swift
//  Project
//
//  Created by wy on 2018/5/2.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class EndAppointmentVC: GDNormalVC, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var scrollVIew: UIScrollView!
    @IBOutlet var appionmentName: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var oldPriceLabel: UILabel!
    @IBOutlet var returnPrice: UILabel!
    @IBOutlet var reason: UILabel!
    @IBOutlet var oldSubPrice: UILabel!
    @IBOutlet var payPriceTextField: UITextField!
    @IBOutlet var returnPriceTextField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var placeholder: UILabel!
    @IBOutlet var textCount: UILabel!
    
    @IBOutlet var height: NSLayoutConstraint!
    let width: CGFloat = SCREENWIDTH - 70
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.payPriceTextField.returnKeyType = .done
        self.returnPriceTextField.returnKeyType = .done
        self.status.text = "处理中待确认"
        if #available(iOS 11.0, *) {
            self.scrollVIew.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "终止约定")
        self.top.constant = DDNavigationBarHeight + 15
        self.view.layoutSubviews()
        self.scrollVIew.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.requestDate()
        self.textView.delegate = self
        self.payPriceTextField.delegate = self
        self.returnPriceTextField.delegate = self
        self.textView.returnKeyType = .done
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(complete))
        self.scrollVIew.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    @objc func complete() {
        self.textView.resignFirstResponder()
        self.payPriceTextField.resignFirstResponder()
        self.returnPriceTextField.resignFirstResponder()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholder.isHidden = true
        if DDKeyBoardHandler.manager.keyboardY > 0 {
            DDKeyBoardHandler.manager.configContentSet(containerView: textView, inputView: self.scrollVIew)
        }else {
            DDKeyBoardHandler.manager.zkqsetViewToBeDealt(containerView: textView, inPutView: self.scrollVIew)
        }

    }
    
    @IBOutlet var zhuyiLabel: UILabel!
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count > 0 {
            self.placeholder.isHidden = true
        }else {
            self.placeholder.isHidden = false
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var totalStr: String = ""
        mylog(textView.text)
        if text != "" {
            
            if text == "\n" {
                totalStr = textView.text
            }else {
                totalStr = textView.text + text
            }
            
            self.textCount.text = String(totalStr.count) + "/200"
            
        }else {
            if textView.text.count > 1 {
                self.textCount.text = String(textView.text.count - 1) + "/200"
            }else {
                self.textCount.text = "0/200"
            }
        }
        
        if (text == "\n") || (totalStr.count == 200) {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DDKeyBoardHandler.manager.keyboardY > 0 {
            DDKeyBoardHandler.manager.configContentSet(containerView: textField, inputView: self.scrollVIew)
        }else {
            DDKeyBoardHandler.manager.zkqsetViewToBeDealt(containerView: textField, inPutView: self.scrollVIew)
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.payPriceTextField == textField {
            var totalStr: String = ""
            if string != "" {
                if string == "\n" {
                    textField.resignFirstResponder()
                    return false
                }
                totalStr = (textField.text ?? "") + string
                if let price = Float(self.data?.price ?? "0"), let truePrice = Float(totalStr) {
                    if truePrice > price {
//                        返回false的话，新输入的值不会添加到textfield的text中。
                        GDAlertView.alert("实际报酬不能超过原定报酬", image: nil, time: 1, complateBlock: nil)
                        return false
                    }else {
                        let returnPrice = price - truePrice
                        self.returnPriceTextField.text = String.init(format: "%0.2f", returnPrice)
                    }
                }else {
                    GDAlertView.alert("请输入正确的报酬", image: nil, time: 1, complateBlock: nil)
                    return false
                
                }
            }else {
                if let text = textField.text, text.count > 0 {
                    totalStr = text.substring(to: text.index(text.endIndex, offsetBy: -1))
                }
                mylog(textField.text)
            }
            mylog(totalStr)
        }
        
        
        if self.returnPriceTextField == textField {
            var totalStr: String = ""
            if string != "" {
                if string == "\n" {
                    textField.resignFirstResponder()
                    return false
                }
                totalStr = (textField.text ?? "") + string
                if let price = Float(self.data?.price ?? "0"), let returnPrice = Float(totalStr) {
                    if let truePrice = Float(self.payPriceTextField.text ?? "0") {
                        let sub = price - truePrice
                        
                        if returnPrice > sub {
                            //                        返回false的话，新输入的值不会添加到textfield的text中。
                            GDAlertView.alert("退回超额", image: nil, time: 1, complateBlock: nil)
                            return false
                        }else {
                            
                        }
                    }
                    
                }else {
                    GDAlertView.alert("请输入正确的报酬", image: nil, time: 1, complateBlock: nil)
                    return false
                    
                }
            }else {
                if let text = textField.text, text.count > 0 {
                    totalStr = text.substring(to: text.index(text.endIndex, offsetBy: -1))
                }
                mylog(textField.text)
            }
            mylog(totalStr)
        }
        
        return true
        
    }
    
    @IBOutlet var status: UILabel!
    var data: ConsultModel?
    func requestDate() {
        guard let cid = self.userInfo as? String else { return  }
        let paramete = ["cid": cid]
        let router = Router.post("Refuseterappointment/rest", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: ConsultModel.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                self.data = model.data
                self.appionmentName.text = self.data?.full_name
                self.priceLabel.text = self.data?.pay_price
                self.oldPriceLabel.text = self.data?.price
                self.returnPrice.text = self.data?.rest_price
                self.reason.text = self.data?.content
                if let reasonText = self.data?.content, reasonText.count > 0 {
                    let size = reasonText.sizeWith(font: self.reason.font, maxWidth: self.reason.width)
                    if size.height > 35 {
                        let h = size.height - 35
                        self.height.constant = h + 200 + 20
                        self.scrollVIew.layoutIfNeeded()
                    }
                }
                
                self.zhuyiLabel.text = "注： 索要报酬数目不得大于本约定中约定报酬" + "\(self.data?.price ?? "")"
                self.oldSubPrice.text = self.data?.price
                self.payPriceTextField.text = ""
                self.returnPriceTextField.text = ""
                
                
            }else {
                
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        var paramete: [String: String] = [String: String]()
        if let aid = self.data?.aid, aid.count > 0 {
            paramete["aid"] = aid
        }else {
            mylog("aid为空")
            return
        }
        if let bid = self.data?.bid , bid.count > 0{
            paramete["bid"] = bid
        }else {
            mylog("bid为空")
            return
        }
        if let price = self.data?.price, price.count > 0{
            paramete["Oriamount"] = price
        }else {
            mylog("原定报酬为空")
            return
        }
        if let truePrice = self.payPriceTextField.text, truePrice.count > 0 {
            paramete["Payamount"] = truePrice
        }else {
            GDAlertView.alert("实际报酬不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        if let price = self.returnPriceTextField.text, price.count > 0 {
            paramete["Retamount"] = price
        }else {
            GDAlertView.alert("退回报酬不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        if let reason = self.textView.text, reason.count > 0 {
            paramete["Reason"] = reason
        }else {
            GDAlertView.alert("请填写终止原因", image: nil, time: 1, complateBlock: nil)
            return
        }
        
        guard let cid = self.userInfo as? String else {
            mylog("vid不能为空")
            return
            
        }
        paramete["cid"] = cid
        
        
        let router = Router.post("Refuseterappsubmit/rest", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                self.popToPreviousVC()
            }else {
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
