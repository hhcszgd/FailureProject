//
//  PayVC.swift
//  Project
//
//  Created by wy on 2018/3/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
class PayVC: GDNormalVC {

    @IBOutlet var top: NSLayoutConstraint!
    
    var completeHandle : ((PayMentType, PayResult) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.top.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()
        self.imageViewS = [weChatImage,aliPayImage, uniconImage, underImage]
        self.view.backgroundColor = lineColor
        guard let subdict = self.userInfo as? [String: String] else {
            return
        }
        guard let price = subdict["price"] else { return }
        self.price = price
        self.priceLabel.text = "￥" + price
    
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.navigationController?.automaticallyAdjustsScrollViewInsets = false 
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mylog(self.scrollView.contentSize)
        mylog(self.scrollView.contentInset)
        mylog(self.scrollView.contentOffset)
    }

    
    var imageViewS:[UIImageView] = [UIImageView]()
    @IBOutlet var weChatImage: UIImageView!
    @IBOutlet var aliPayImage: UIImageView!
    @IBOutlet var uniconImage: UIImageView!
    @IBOutlet var underImage: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var sureBtn: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    var price: String?
    @IBAction func sureBtnAction(_ sender: UIButton) {
        //开始支付的时候禁止点击确定按钮
        sender.isEnabled = false
        guard var subdict = self.userInfo as? [String: String] else {
            sender.isEnabled = true
            return
        }
        guard let mid = subdict["orderID"] else { return }

        if self.selectImageView == nil {
            GDAlertView.alert("请先选择支付方式", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        
        switch self.selectImageView! {
        case self.weChatImage:
            
            
            PayManager.share.pay(paremete: mid as AnyObject, payMentType: PayMentType.WeiChatpay) { [weak self](_, result) in
                sender.isEnabled = true
                if result.result {
                    let vc = PayResultVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else {
                    GDAlertView.alert("支付失败，请重新支付", image: nil, time: 1, complateBlock: nil)
                }
            }
            
            
            
            
            
            
            break
        case self.aliPayImage:
            var dict = [String: String]()
            PayManager.share.pay(paremete: mid as AnyObject, payMentType: PayMentType.Alipay, finished: { [weak self](type, result) in
                sender.isEnabled = true
                if result.result {
                    let vc = PayResultVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else {
                    GDAlertView.alert(result.failurereason, image: nil, time: 1, complateBlock: nil)
                }
            })
            

            
            
        case self.uniconImage:
            
            self.whetherSetPayPassword {[weak self] in
                
                let psdInput =  DDPayPasswordInputView(superView: (self?.view)!)
                psdInput.passwordComplateHandle = {[weak self]password in
                    mylog(password)
                    
                    PayManager.share.pay(paremete:  ["order_code": mid, "payword": password] as AnyObject, payMentType: PayMentType.balancePay) { (paytype , result ) in
                        self?.completeHandle?(paytype , result )
                        
                        self?.trueBtn.isEnabled = true
                        if result.result {
                            let vc = PayResultVC()
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }else {
                            GDAlertView.alert(result.failurereason, image: nil, time: 1, complateBlock: nil)
                        }
                    }
                }
                
                psdInput.forgetHandle = {[weak self] in
                    self?.trueBtn.isEnabled = true
                    let vc = ConfigPasswordVC()
                    vc.userInfo = VCActionType.changePayPassword
                    self?.navigationController?.pushViewController(vc, animated: true)
                    mylog("perform forget pay password ")
                }
                psdInput.cancleHandle = {[weak self] in
                    self?.trueBtn.isEnabled = true
                    
                }
                
                
                
            }
            
            
            
        case self.underImage:
            PayManager.share.pay(paremete: mid as AnyObject, payMentType: .under, finished: { (payType, result) in
                if result.result {
                    self.sureBtn.isEnabled = true
                    self.navigationController?.pushVC(vcIdentifier: "UnderPayVC", userInfo: result.paramete)
                }else {
                    GDAlertView.alert(result.failurereason, image: nil, time: 1, complateBlock: nil)
                }
                sender.isEnabled = true

            })
            
        default:
            break
        }

    }
    override func popToPreviousVC() {
        
        let alertView = PayAlertView.init(frame: CGRect.init(x: 30, y: (SCREENHEIGHT - 170) / 2.0, width: SCREENWIDTH - 60, height: 170))
        
        self.cover = DDCoverView.init(superView: self.view)
        self.cover?.deinitHandle = {
            self.cover?.removeFromSuperview()
            self.cover = nil
        }
        alertView.sureBtn.addTarget(self, action: #selector(sureAction(sender:)), for: .touchUpInside)
        alertView.cancleBtn.addTarget(self, action: #selector(cancleaction(sender:)), for: .touchUpInside)
        self.cover?.addSubview(alertView)
        
        
        
    }
    
    @objc func sureAction(sender: UIButton) {
        let count = (self.navigationController?.viewControllers.count)!
        self.navigationController?.viewControllers.removeSubrange(1..<count)
        rootNaviVC?.selectChildViewControllerIndex(index: 3)
    }
    @objc func cancleaction(sender: UIButton) {
        self.cover?.removeFromSuperview()
        self.cover = nil
    }
    var cover: DDCoverView?
    
    struct  PasswordSetedStatus : Codable{
        var name : String
        var status : Int
    }
    func whetherSetPayPassword(hasSetCallBack:@escaping ()->()) {
        DDRequestManager.share.whetherSetPayPassword(type: ApiModel<PasswordSetedStatus>.self) { (model ) in
            if model?.data?.status == 0 {// 未设置
                self.navigationController?.pushVC(vcIdentifier: "ConfigPasswordVC" , userInfo: VCActionType.changePayPassword)
            }else {
                hasSetCallBack()
            }
        }
    }
    
    
    @IBOutlet var trueBtn: UIButton!
    let selectImage: UIImage = UIImage.init(named: "selected")!
    let unselectImage: UIImage = UIImage.init(named: "unchecked")!
    func configCell(selectImageView: UIImageView) {
        self.imageViewS.forEach { (imageView) in
            if imageView == selectImageView {
                imageView.image = self.selectImage
                self.selectImageView = imageView
                self.trueBtn.isEnabled = true
            }else {
                imageView.image = self.unselectImage
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "支付")
       
    }
    var selectImageView: UIImageView?
    @IBAction func weChatAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.weChatImage)
        guard let price = self.price else {
            return
        }
        if let price = Float(price) {
            let priceStr = String.init(format: "支付￥%0.2f", price * POUNDAGE)
            self.sureBtn.setTitle( priceStr, for: .normal)
            self.priceLabel.text = String.init(format: "￥%0.2f", price * POUNDAGE)
        }
        
    }
    @IBAction func aliPayAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.aliPayImage)
        guard let price = self.price else {
            return
        }
        if let price = Float(price) {
            let priceStr = String.init(format: "支付￥%0.2f", price * POUNDAGE)
            self.sureBtn.setTitle( priceStr, for: .normal)
            self.priceLabel.text = String.init(format: "￥%0.2f", price * POUNDAGE)
        }
    }
    @IBAction func unionPayAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.uniconImage)
        guard let price = self.price else {
            return
        }
        if let price = Float(price) {
            let priceStr = String.init(format: "支付￥%0.2f", price)
            self.sureBtn.setTitle( priceStr, for: .normal)
            self.priceLabel.text = String.init(format: "￥%0.2f", price)
        }
    }
    @IBAction func underAction(_ sender: UITapGestureRecognizer) {
        self.configCell(selectImageView: self.underImage)
        self.sureBtn.setTitle("进入线下支付页面", for: .normal)
        self.priceLabel.text = String.init(format: "%@元", price ?? "")
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
