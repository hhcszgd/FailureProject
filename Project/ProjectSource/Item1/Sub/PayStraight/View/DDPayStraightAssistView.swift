//
//  DDPayStraightAssistView.swift
//  Project
//
//  Created by WY on 2018/4/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPayStraightAssistView: DDCoverView {
    var money : String?{
        didSet{
            self.moneyLabel.text = "¥\(money ?? "")"
        }
    }
    var currentPayType = DDPayType.laoPay{
        didSet{
            switch currentPayType {
            case .laoPay:
                self.choosePayType.subTitle = "余额"
            case .wechatPay:
                self.choosePayType.subTitle = "微信支付"
            case .alipay:
                self.choosePayType.subTitle = "支付宝"
            }
        }
    }
    
    
    let containerPayDetail = UIView()
    let payDetailLabel = UILabel()
    let moneyLabel = UILabel()
    let choosePayType = DDRowView()
    let payButton = UIButton()
    let cancel = UIButton()
    
    
    let containerPayType = UIView()
    let payTypeLabel = UILabel()
    let wechatPay = UIButton()
    let alipay = UIButton()
    let laoPay = UIButton()
    let back = UIButton()
    
    
    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(containerPayDetail)
        containerPayDetail.addSubview(payDetailLabel)
        containerPayDetail.addSubview(moneyLabel)
        containerPayDetail.addSubview(choosePayType)
        containerPayDetail.addSubview(payButton)
        containerPayDetail.addSubview(cancel)
        
        self.addSubview(containerPayType)
        containerPayType.addSubview(payTypeLabel)
        containerPayType.addSubview(laoPay)
        containerPayType.addSubview(wechatPay)
        containerPayType.addSubview(alipay)
        containerPayType.addSubview(back)
        
        payDetailLabel.text = "付款详情"
        payDetailLabel.backgroundColor = .white
        choosePayType.backgroundColor = .white
        payDetailLabel.textAlignment = .center
        moneyLabel.backgroundColor = .white
        moneyLabel.textAlignment = .center
        moneyLabel.text = "¥"
        choosePayType.title = "付款方式"
        choosePayType.subTitle = "余额"
        choosePayType.additionalImageIsHidden = false
        
        payButton.backgroundColor = UIColor.DDThemeColor
        payButton.setTitle("立即付款", for: UIControlState.normal)
        cancel.setTitle("取消", for: UIControlState.normal)
        back.setTitle("返回", for: UIControlState.normal)
        back.setTitleColor(UIColor.gray, for: UIControlState.normal)
        cancel.setTitleColor(UIColor.gray, for: UIControlState.normal)
        
        back.addTarget(self , action: #selector(backAction(sender:)), for: UIControlEvents.touchUpInside)
        cancel.addTarget(self , action: #selector(cancelAction(sender:)), for: UIControlEvents.touchUpInside)
        payTypeLabel.backgroundColor = .white
        payTypeLabel.text = "选择支付方式"
        payTypeLabel.textAlignment = .center
        
        payDetailLabel.textColor = UIColor.DDTitleColor
        payTypeLabel.textColor = UIColor.DDTitleColor
        
        laoPay.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        wechatPay.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        alipay.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        laoPay.setTitle("余额", for: UIControlState.normal)
        wechatPay.setTitle("微信支付", for: UIControlState.normal)
        alipay.setTitle("支付宝", for: UIControlState.normal)
        
        laoPay.backgroundColor = .white
        wechatPay.backgroundColor = .white
        alipay.backgroundColor = .white
        
        choosePayType.addTarget(self , action: #selector(choosePayTypeAction(sender:)), for: UIControlEvents.touchUpInside)
        
        payButton.addTarget(self , action: #selector(payAction(sender:)), for: UIControlEvents.touchUpInside)
        
        laoPay.addTarget(self , action: #selector(choosed(sender:)), for: UIControlEvents.touchUpInside)
        wechatPay.addTarget(self , action: #selector(choosed(sender:)), for: UIControlEvents.touchUpInside)
        alipay.addTarget(self , action: #selector(choosed(sender:)), for: UIControlEvents.touchUpInside)
        containerPayDetail.backgroundColor =  UIColor.DDLightGray
        containerPayType.backgroundColor =  UIColor.DDLightGray
        
        
    }
    
    @objc func choosed(sender:UIButton){
        if sender == self.laoPay {
            self.currentPayType = .laoPay
            switchBottomViewStatus(type: DDPayStraightAssistView.DDSwitchType.payDetail)
        }else if sender == self.wechatPay {
            self.currentPayType = .wechatPay
            switchBottomViewStatus(type: DDPayStraightAssistView.DDSwitchType.payDetail)
        }else if sender == self.alipay {
            self.currentPayType = .alipay
            switchBottomViewStatus(type: DDPayStraightAssistView.DDSwitchType.payDetail)
        }
    }
    
    @objc func cancelAction(sender:UIButton){
        self.remove()
    }
    
    @objc func backAction(sender:UIButton){
        self.switchBottomViewStatus(type: DDPayStraightAssistView.DDSwitchType.payDetail)
    }
    
    @objc func choosePayTypeAction(sender:UIButton){
        self.switchBottomViewStatus(type: DDPayStraightAssistView.DDSwitchType.payType)
    }
    
    @objc func payAction(sender:UIButton){
        
        //        switch currentPayType {
        //        case .laoPay:
        //            mylog("捞付余额支付\(money ?? "")元")
        self.actionHandle?(self.currentPayType)
        //        case .wechatPay:
        //            mylog("微信支付\(money ?? "")元")
        //        case .alipay:
        //            mylog("支付宝 支付\(money ?? "")元")
        //        }
        self.remove()
    }
    
    enum DDSwitchType {
        case payDetail
        case payType
    }
    enum DDPayType {
        case laoPay
        case wechatPay
        case alipay
    }
    
    func switchBottomViewStatus(type:DDSwitchType)  {
        let containerH : CGFloat = 333
        switch type {
        case .payDetail:
            UIView.animate(withDuration: 0.25, animations: {
                self.containerPayDetail.frame = CGRect(x: 0, y: self.bounds.height - containerH, width: self.bounds.width , height: containerH)
                
                self.containerPayType.frame = CGRect(x: self.bounds.width , y: self.bounds.height - containerH, width: self.bounds.width , height: containerH)
            })
        case .payType:
            UIView.animate(withDuration: 0.25, animations: {
                self.containerPayDetail.frame = CGRect(x: -self.bounds.width, y: self.bounds.height - containerH, width: -self.bounds.width , height: containerH)
                
                self.containerPayType.frame = CGRect(x: 0 , y: self.bounds.height - containerH, width: self.bounds.width, height: containerH)
            })
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        CGRect(x: 0, y: 0, width: self.bounds.width , height: 0)
        
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _layoutSubviewsFrame()
    }
    func _layoutSubviewsFrame() {
        let containerH : CGFloat = 333
        let containerW : CGFloat = self.currentSuperView?.bounds.width ?? 0
        let margin : CGFloat = 5
        self.containerPayDetail.frame = CGRect(x: 0, y: (self.currentSuperView?.bounds.height ??  0 ) - containerH, width: self.bounds.width , height: containerH)
        payDetailLabel.frame = CGRect(x: 0, y: 0, width: containerPayDetail.bounds.width , height: 40)
        cancel.frame = CGRect(x: containerPayDetail.bounds.width - 44, y: 0, width: 40 , height: 40)
        moneyLabel.frame = CGRect(x: 0, y:payDetailLabel.frame.maxY + margin, width: self.currentSuperView?.bounds.width ?? 0 , height: 64)
        choosePayType.frame = CGRect(x: 0, y: moneyLabel.frame.maxY + margin, width: containerPayDetail.bounds.width , height: 40)
        payButton.frame = CGRect(x: (self.currentSuperView?.bounds.width ?? 0)/4, y: containerH - 40 - margin * 4, width:  ( self.currentSuperView?.bounds.width ?? 0 ) / 2 , height: 40)
        
        
        self.containerPayType.frame = CGRect(x: self.bounds.width , y: self.bounds.height - containerH, width: self.bounds.width , height: containerH)
        payTypeLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width , height: 40)
        back.frame = CGRect(x: 4, y: 0, width: 40 , height: 40)
        
        laoPay.frame = CGRect(x: 0, y: payTypeLabel.frame.maxY + margin, width: containerW , height: 40)
        wechatPay.frame = CGRect(x: 0, y: laoPay.frame.maxY + margin, width: containerW , height: 40)
        alipay.frame = CGRect(x: 0, y:wechatPay.frame.maxY + margin, width: containerW , height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        mylog("death")
    }
}




////////////////////////////////////////////////////////////////////////////////////////
class DDPayStraightAssistViewOld: DDCoverView {
    var money : String?{
        didSet{
            self.moneyLabel.text = "¥\(money ?? "")"
        }
    }
    var currentPayType = DDPayType.laoPay{
        didSet{
            switch currentPayType {
            case .laoPay:
                self.choosePayType.subTitle = "余额"
            case .wechatPay:
                self.choosePayType.subTitle = "微信支付"
            case .alipay:
                self.choosePayType.subTitle = "支付宝"
            }
        }
    }
    
    
    let containerPayDetail = UIView()
    let payDetailLabel = UILabel()
    let moneyLabel = UILabel()
    let choosePayType = DDRowView()
    let payButton = UIButton()
    let cancel = UIButton()
    
    
    let containerPayType = UIView()
    let payTypeLabel = UILabel()
    let wechatPay = UIButton()
    let alipay = UIButton()
    let laoPay = UIButton()
    let back = UIButton()
    

    override init(superView: UIView) {
        super.init(superView: superView)
        self.addSubview(containerPayDetail)
        containerPayDetail.addSubview(payDetailLabel)
        containerPayDetail.addSubview(moneyLabel)
        containerPayDetail.addSubview(choosePayType)
        containerPayDetail.addSubview(payButton)
        containerPayDetail.addSubview(cancel)
        
        self.addSubview(containerPayType)
        containerPayType.addSubview(payTypeLabel)
        containerPayType.addSubview(laoPay)
        containerPayType.addSubview(wechatPay)
        containerPayType.addSubview(alipay)
        containerPayType.addSubview(back)
        
        payDetailLabel.text = "付款详情"
        payDetailLabel.backgroundColor = .white
        choosePayType.backgroundColor = .white
        payDetailLabel.textAlignment = .center
        moneyLabel.backgroundColor = .white
        moneyLabel.textAlignment = .center
        moneyLabel.text = "¥"
        choosePayType.title = "付款方式"
        choosePayType.subTitle = "余额"
        choosePayType.additionalImageIsHidden = false
        
        payButton.backgroundColor = UIColor.DDThemeColor
        payButton.setTitle("立即付款", for: UIControlState.normal)
        cancel.setTitle("取消", for: UIControlState.normal)
        back.setTitle("返回", for: UIControlState.normal)
        back.setTitleColor(UIColor.gray, for: UIControlState.normal)
        cancel.setTitleColor(UIColor.gray, for: UIControlState.normal)
        
        back.addTarget(self , action: #selector(backAction(sender:)), for: UIControlEvents.touchUpInside)
        cancel.addTarget(self , action: #selector(cancelAction(sender:)), for: UIControlEvents.touchUpInside)
        payTypeLabel.backgroundColor = .white
        payTypeLabel.text = "选择支付方式"
        payTypeLabel.textAlignment = .center
        
        payDetailLabel.textColor = UIColor.DDTitleColor
        payTypeLabel.textColor = UIColor.DDTitleColor
            
        laoPay.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        wechatPay.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        alipay.setTitleColor(UIColor.DDSubTitleColor, for: UIControlState.normal)
        laoPay.setTitle("余额", for: UIControlState.normal)
        wechatPay.setTitle("微信支付", for: UIControlState.normal)
        alipay.setTitle("支付宝", for: UIControlState.normal)
        
        laoPay.backgroundColor = .white
        wechatPay.backgroundColor = .white
        alipay.backgroundColor = .white
        
        choosePayType.addTarget(self , action: #selector(choosePayTypeAction(sender:)), for: UIControlEvents.touchUpInside)
        
        payButton.addTarget(self , action: #selector(payAction(sender:)), for: UIControlEvents.touchUpInside)
        
        laoPay.addTarget(self , action: #selector(choosed(sender:)), for: UIControlEvents.touchUpInside)
        wechatPay.addTarget(self , action: #selector(choosed(sender:)), for: UIControlEvents.touchUpInside)
        alipay.addTarget(self , action: #selector(choosed(sender:)), for: UIControlEvents.touchUpInside)
        containerPayDetail.backgroundColor =  UIColor.DDLightGray
        containerPayType.backgroundColor =  UIColor.DDLightGray

        
    }
    
    @objc func choosed(sender:UIButton){
        if sender == self.laoPay {
            self.currentPayType = .laoPay
            switchBottomViewStatus(type: DDPayStraightAssistViewOld.DDSwitchType.payDetail)
        }else if sender == self.wechatPay {
            self.currentPayType = .wechatPay
            switchBottomViewStatus(type: DDPayStraightAssistViewOld.DDSwitchType.payDetail)
        }else if sender == self.alipay {
            self.currentPayType = .alipay
            switchBottomViewStatus(type: DDPayStraightAssistViewOld.DDSwitchType.payDetail)
        }
    }
 
    @objc func cancelAction(sender:UIButton){
        self.remove()
    }

    @objc func backAction(sender:UIButton){
       self.switchBottomViewStatus(type: DDPayStraightAssistViewOld.DDSwitchType.payDetail)
    }
    
    @objc func choosePayTypeAction(sender:UIButton){
       self.switchBottomViewStatus(type: DDPayStraightAssistViewOld.DDSwitchType.payType)
    }
    
    @objc func payAction(sender:UIButton){
        
//        switch currentPayType {
//        case .laoPay:
//            mylog("捞付余额支付\(money ?? "")元")
            self.actionHandle?(self.currentPayType)
//        case .wechatPay:
//            mylog("微信支付\(money ?? "")元")
//        case .alipay:
//            mylog("支付宝 支付\(money ?? "")元")
//        }
        self.remove()
    }
    
    enum DDSwitchType {
        case payDetail
        case payType
    }
    enum DDPayType {
        case laoPay
        case wechatPay
        case alipay
    }
    
    func switchBottomViewStatus(type:DDSwitchType)  {
        let containerH : CGFloat = 333
        switch type {
        case .payDetail:
            UIView.animate(withDuration: 0.25, animations: {
                self.containerPayDetail.frame = CGRect(x: 0, y: self.bounds.height - containerH, width: self.bounds.width , height: containerH)
                
                self.containerPayType.frame = CGRect(x: self.bounds.width , y: self.bounds.height - containerH, width: self.bounds.width , height: containerH)
            })
        case .payType:
            UIView.animate(withDuration: 0.25, animations: {
                self.containerPayDetail.frame = CGRect(x: -self.bounds.width, y: self.bounds.height - containerH, width: -self.bounds.width , height: containerH)
                
                self.containerPayType.frame = CGRect(x: 0 , y: self.bounds.height - containerH, width: self.bounds.width, height: containerH)
            })
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()

//        CGRect(x: 0, y: 0, width: self.bounds.width , height: 0)
        
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        _layoutSubviewsFrame()
    }
    func _layoutSubviewsFrame() {
        let containerH : CGFloat = 333
        let containerW : CGFloat = self.currentSuperView?.bounds.width ?? 0
        let margin : CGFloat = 5
        self.containerPayDetail.frame = CGRect(x: 0, y: (self.currentSuperView?.bounds.height ??  0 ) - containerH, width: self.bounds.width , height: containerH)
        payDetailLabel.frame = CGRect(x: 0, y: 0, width: containerPayDetail.bounds.width , height: 40)
        cancel.frame = CGRect(x: containerPayDetail.bounds.width - 44, y: 0, width: 40 , height: 40)
        moneyLabel.frame = CGRect(x: 0, y:payDetailLabel.frame.maxY + margin, width: self.currentSuperView?.bounds.width ?? 0 , height: 64)
        choosePayType.frame = CGRect(x: 0, y: moneyLabel.frame.maxY + margin, width: containerPayDetail.bounds.width , height: 40)
        payButton.frame = CGRect(x: (self.currentSuperView?.bounds.width ?? 0)/4, y: containerH - 40 - margin * 4, width:  ( self.currentSuperView?.bounds.width ?? 0 ) / 2 , height: 40)
        
        
        self.containerPayType.frame = CGRect(x: self.bounds.width , y: self.bounds.height - containerH, width: self.bounds.width , height: containerH)
        payTypeLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width , height: 40)
        back.frame = CGRect(x: 4, y: 0, width: 40 , height: 40)
        
        laoPay.frame = CGRect(x: 0, y: payTypeLabel.frame.maxY + margin, width: containerW , height: 40)
        wechatPay.frame = CGRect(x: 0, y: laoPay.frame.maxY + margin, width: containerW , height: 40)
        alipay.frame = CGRect(x: 0, y:wechatPay.frame.maxY + margin, width: containerW , height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        mylog("death")
    }
}
