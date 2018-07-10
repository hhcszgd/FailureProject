//
//  FeedBackVC.swift
//  Project
//
//  Created by wy on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
class FeedBackVC: GDNormalVC, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var titlelabel: UILabel!
    
    @IBOutlet var subTitlelabel: UILabel!
    @IBOutlet var opinionTextView: UITextView!
    @IBOutlet var phone: UITextField!
    
    @IBOutlet var sureBtn: UIButton!
    
    @IBOutlet var topViewTop: NSLayoutConstraint!
    @IBAction func sureAction(_ sender: UIButton) {
        if self.content.count < 1 {
            GDAlertView.alert("请填写建议内容", image: nil, time:3, complateBlock: nil)
            return
        }
        if self.phoneStr.count < 1 {
            GDAlertView.alert("请填写手机号码", image: nil, time: 1, complateBlock: nil)
            return
        }
        if !self.phoneStr.mobileLawful() {
            GDAlertView.alert("请输入正确的手机号码", image: nil, time: 1, complateBlock: nil)
            return
        }
        let paramete = ["content": self.content, "mobile": self.phoneStr]
        let router = Router.post("Mttupdateinfo/userFeedback", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                GDAlertView.alert("您的建议已成功提交，感谢您的建议。", image: nil, time: 3, complateBlock: {
                    self.popToPreviousVC()
                })
            }else {
                GDAlertView.alert("您的建议提交失败，请重新提交", image: nil, time: 3, complateBlock: {
                })
            }
        }, onError: { (error) in
            
        }, onCompleted: nil, onDisposed: nil)
    }
    var phoneStr: String = ""
    var content: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "用户反馈")
        self.topViewTop.constant = DDNavigationBarHeight + 15
        self.view.layoutIfNeeded()
        self.opinionTextView.delegate = self
        self.phone.delegate = self
        self.opinionTextView.layer.borderColor = UIColor.clear.cgColor
        self.view.backgroundColor = UIColor.colorWithRGB(red: 233, green: 238, blue: 243)
        self.opinionTextView.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.content = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.phone.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.phoneStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        // Do any additional setup after loading the view.
    }
    ///textviewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholdr.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            self.placeholdr.isHidden = false
        }else {
            self.placeholdr.isHidden = true
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    @IBOutlet var placeholdr: UILabel!
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        self.opinionTextView.resignFirstResponder()
        self.phone.resignFirstResponder()
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
