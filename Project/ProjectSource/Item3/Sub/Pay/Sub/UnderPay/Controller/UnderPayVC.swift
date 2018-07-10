//
//  UnderPayVC.swift
//  Project
//
//  Created by wy on 2018/3/16.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import Photos
enum UnderPayType {
    
    /// 充值大额支付
    case rechargeType
    
    /// 线下支付
    case underPayType
}
class UnderPayVC: GDNormalVC {
    @IBOutlet var topView: NSLayoutConstraint!
    @IBOutlet var bottomView: NSLayoutConstraint!
    
    @IBOutlet var companyAddress: UILabel!
    @IBOutlet var companyName: UILabel!
    
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var beizhu: UILabel!
    @IBOutlet var bank: UILabel!
    @IBOutlet var account: UILabel!
    @IBOutlet var scroll: UIScrollView!

    @IBOutlet var propmtTitle: UILabel!
    
    @IBOutlet var priceView: UIView!
    @IBOutlet var propmtDetail: UILabel!
    
    
    var type: UnderPayType = UnderPayType.underPayType
    var orderID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = lineColor
        self.topView.constant = DDNavigationBarHeight
        self.view.layoutIfNeeded()
        
        
        if type == UnderPayType.underPayType {
            self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "线下汇款")
            if let model = self.userInfo as? UnderPayModel {
                self.companyName.text = model.name
                self.companyAddress.text = model.address
                self.totalPrice.text = String(model.price ?? 0) + "元"
                self.beizhu.text = model.ls
                self.bank.text = model.card_name
                self.account.text = model.card_number
            }
            self.propmtTitle.text = ""
            self.propmtDetail.text = ""
        }else {
          
            self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "大额充值")
            self.priceView.isHidden = true
            
            if let model = self.userInfo as? UnderPayModel {
                self.companyName.text = model.name
                self.companyAddress.text = model.address
                self.beizhu.text = model.ls
                self.bank.text = model.card_name
                self.account.text = model.card_number
            }
        }
        
        
    
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ///出现之后删除前面一个支付页面的控制器
        ///判断前一个控制器是什么类型，如果是订单详情那么就征程返回
        if self.type == .rechargeType {
            self.navigationController?.removeSpecifyVC(RechargeVC.self)
        }else {
            
        }
        
    
    }
    
    
    @IBOutlet var payBtn: UIButton!
    
    override func popToPreviousVC() {
        if self.type == .underPayType {
            let count = (self.navigationController?.viewControllers.count)!
            self.navigationController?.viewControllers.removeSubrange(1..<count)
            rootNaviVC?.selectChildViewControllerIndex(index: 3)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        self.scroll.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        self.screenSnapshot(save: true)
        
    }
    func screenSnapshot(save save: Bool) {
        
        guard let window = UIApplication.shared.keyWindow else { return  }
        
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if save {
            if image != nil {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image!)
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess {
                        DispatchQueue.main.async {
                        
//                            self.pushVC(vcIdentifier: "UpPayVC", userInfo: ["order": self.orderID, "result": "underSuccess"])
                        }
                        
                        GDAlertView.alert("保存成功", image: nil, time: 1, complateBlock: {
                            
                        })
                        
    
                    }else {
                        GDAlertView.alert("保存失败", image: nil, time: 1, complateBlock: nil)
                    }
                })
            }
            
            
        }
        
    
    }
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class UnderZhiFuModel: Codable {
        ///收款人地址
        var system_receiver_address: String = ""
        ///收款银行
        var system_receiver_bank_name: String = ""
        ///收款账号
        var system_receiver_bank_number: String = ""
        ///收款姓名
        var system_receiver_name: String = ""
        ///付款随机码
        var payment_code: String = ""
        ///价格
        var order_price: String = ""
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
