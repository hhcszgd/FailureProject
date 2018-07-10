//
//  RechargeVC.swift
//  Project
//
//  Created by wy on 2018/5/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class RechargeVC: GDNormalVC, UITextFieldDelegate, DDBankChooseDelegate {
    @IBOutlet var top: NSLayoutConstraint!
    
    @IBOutlet var type1: UIView!
    
    @IBOutlet var type2: UIView!
    
    @IBOutlet var styleIcon: UIImageView!
    
    @IBOutlet var styleName: UILabel!
    
    @IBOutlet var bankIcon: UIImageView!
    
    @IBOutlet var bankName: UILabel!
    
    @IBOutlet var bankCardType: UILabel!
    
    @IBOutlet var bankCardLast: UILabel!
    
    @IBOutlet var promptLabel: UILabel!
    @IBOutlet var textfield: UITextField!
    
    @IBOutlet var bigRecharggeBtn: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    let rechargeLimit: Int = 200000
    let rechargeLimitLost: Int = 1
    
    
    var rechargeType: PayMentType = PayMentType.AlipayRecharge
    let unitLabel: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 35), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "￥")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.top.constant = DDNavigationBarHeight + 20
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "充值")
        self.textfield.leftViewMode = .always
        self.unitLabel.frame = CGRect.init(x: 0, y: 0, width: 35, height: self.textfield.height)
        self.textfield.leftView = self.unitLabel
        self.textfield.delegate = self
        self.textfield.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.price = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        // Do any additional setup after loading the view.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.cover?.removeFromSuperview()
        self.cover = nil
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "-" {
            GDAlertView.alert("充值不能为负数", image: nil, time: 1, complateBlock: nil)
            return false
        }
        let str = (textField.text ?? "") + string
        if let num = Int(str) {
            if num < rechargeLimitLost {
                GDAlertView.alert("充值金额不能小于1", image: nil, time: 1, complateBlock: nil)
            }
            if num > rechargeLimit {
                GDAlertView.alert("充值金额不能大于\(rechargeLimit)", image: nil, time: 1, complateBlock: nil)
            }
            if num >= rechargeLimitLost && num <= rechargeLimit {
                return true
            }else {
                return false
            }
        }else {
            GDAlertView.alert("请输入正确的数字", image: nil, time: 1, complateBlock: nil)
            return false
        }
        
    }
    
    var price: String = "0"
    @IBAction func rechargeBtnAction(_ sender: UIButton) {
       self.rearchage()
        
        
    }
    
    func judgeBigRearchge() -> Bool {
        if self.rechargeType == .UnderPayReacharge {
            return true
        }
        if self.price == "" {
            return true
        }
        if self.price == "0" {
            return true
        }
        if let price = Int(self.price), price == 0 {
            return true
        }
        if let price = Int(self.price), price > 200000 {
            return true
        }
        return false
    }
    @IBAction func registerAction(_ sender: UITapGestureRecognizer) {
        self.textfield.resignFirstResponder()
    }
    func rearchage() {
        
        
        
        PayManager.share.pay(paremete: ((self.rechargeType == PayMentType.UnderPayReacharge) ? "1":self.price) as AnyObject, payMentType: self.rechargeType) { (type, result) in
            if result.result {
                if self.judgeBigRearchge() {
                    let vc = UnderPayVC()
                    vc.userInfo = result.paramete
                    vc.type = .rechargeType
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    GDAlertView.alert("充值成功", image: nil, time: 1, complateBlock: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
                
            }else {
                GDAlertView.alert(result.failurereason, image: nil, time: 1, complateBlock: nil)
            }
        }
        
        
        
       
    }
    
    @IBAction func bigRearchargeBtnAction(_ sender: UIButton) {
        self.rechargeType = PayMentType.UnderPayReacharge
        self.rearchage()
        
        
        
        
    }
    @IBAction func tap1Action(_ sender: UITapGestureRecognizer) {
        self.selectReargeType()
    }
    @IBAction func tap2Action(_ sender: UITapGestureRecognizer) {
        self.textfield.resignFirstResponder()
        self.selectReargeType()
    }
    
    @IBOutlet var tap2Acttion: UITapGestureRecognizer!
    
    
    
    
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
    weak var cover: DDCoverView?

}
extension RechargeVC {
    func selectReargeType() {
        
        cover = DDCoverView.init(superView: self.view)
        cover?.deinitHandle = {
        self.conerClick()
        }
        let pickerContainerH :CGFloat = 250
        let aplipyModel = DDBandBrandModel.init()
        aplipyModel.backicon = "alipay"
        aplipyModel.name = "支付宝支付"
        aplipyModel.type = 1
        let weixinModel = DDBandBrandModel.init()
        weixinModel.backicon = "wechat"
        weixinModel.name = "微信支付"
        weixinModel.type = 2
        let bigModel = DDBandBrandModel.init()
        bigModel.name = "大额支付"
        bigModel.type = 3
        let pickerContainer = DDBankContainer.init(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: pickerContainerH), dataArr: [aplipyModel, weixinModel, bigModel])
        pickerContainer.delegate = self
        pickerContainer.titleLabel.text = "选择充值方式"
        pickerContainer.cancleBtn.addTarget(self, action: #selector(conerClick), for: .touchUpInside)
        self.cover?.addSubview(pickerContainer)
        pickerContainer.backgroundColor = .white
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
        pickerContainer.frame = CGRect(x: 0 , y: self.view.bounds.height - pickerContainerH, width: self.view.bounds.width, height: pickerContainerH)
        }, completion: { (bool ) in
        })
        
    }
    func didSelectModel(model: DDBandBrandModel) {
        if let type = model.type {
            if type == 1 {
                self.styleIcon.image = UIImage.init(named: model.backicon!)
                self.styleName.text = model.name
                self.rechargeType = .AlipayRecharge
            }else if type == 2 {
                self.styleIcon.image = UIImage.init(named: model.backicon!)
                self.styleName.text = model.name
                self.rechargeType = .WeiXinRecharge
            }else {
                self.styleIcon.image = nil
                self.styleName.text = "大额支付"
                self.promptLabel.isHidden = true
                self.rechargeType = .UnderPayReacharge
            }
            self.conerClick()
        }
        
    }

    @objc func conerClick()  {
        self.cover?.removeFromSuperview()
        self.cover = nil
    }
}
