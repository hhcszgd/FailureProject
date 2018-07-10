//
//  ConsultDetailVC.swift
//  Project
//
//  Created by wy on 2018/4/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
let blueTextColor: UIColor = UIColor.colorWithHexStringSwift("6a96fc")
class ConsultDetailVC: GDNormalVC {
    lazy var refuseBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("拒绝申请", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor.colorWithRGB(red: 101, green: 148, blue: 244)
        
        return btn
    }()
    weak var cover: DDCoverView?
    lazy var agreeBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("同意申请", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.backgroundColor = UIColor.colorWithRGB(red: 101, green: 148, blue: 244)
        return btn
    }()
    let statusLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: blueTextColor, text: "*****")
    let subStatusLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: blueTextColor, text: "*****")
    let customView = UIView.init(frame: CGRect.init(x: 15, y:100 + 10, width: SCREENWIDTH - 30, height: 95))
    /// 协商title
    let configOrder: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "协商编号:")
    ///协商编号
    let configOrderValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "")
    ///约定号
    let appointmentOrdre: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "约定号:")
    
    let appointmentOrdreValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "")
    
    let appointmentName: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "约定名称:")
    
    let appointmentNameValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "")
    let consultHistory: DDRowView = DDRowView.init(frame: CGRect.init(x: 15, y: 0, width: SCREENWIDTH - 30, height: 40))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = self.userInfo as? ConsultModel {
            self.consultModel = model
        }
        self.view.addSubview(self.scrollview)
        self.scrollview.backgroundColor = backColor
        
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "协商详情")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.request()
    }
    
    let scrollview: UIScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - TabBarHeight))
    
    
    var consultModel: ConsultModel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 约定处理报酬
    let appointmentdealLabel: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "约定处理报酬:")
    ///原定报酬
    let appointmentOldPrice: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "原定报酬")
    ///实际报酬
    let appointmentPayPrice: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "实际报酬")
    ///退回报酬
    let appointmentReturnPrice: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "退回报酬")
    
    let appointmentApply: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "申请原因")
    
    let appointmentApplyTime: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "申请时间:")
    ///原定报酬
    let appointmentOldPriceValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "************")
    ///实际报酬
    let appointmentPayPriceValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "******")
    ///退回报酬
    let appointmentReturnPriceValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "******")
    
    let appointmentApplyValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "*********")
    
    let appointmentApplyTimeValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "*******")

    let middleView = UIView.init()
    var middleheight: CGFloat = 0
    var data: ConsultModel?
    
    lazy var headerView: UIView = {
        let view  = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 100))
        self.scrollview.addSubview(view)
        view.backgroundColor = UIColor.white
        return view
    }()
    let rightImage = UIImageView.init(image: UIImage.init(named: "sswaqae"))

}

extension ConsultDetailVC {
    func request() {
        var paramete: [String: String] = [String: String]()
        if let id = self.consultModel.id {
            mylog("约定ID为空")
            paramete["id"] = id
        }else {
            
        }
        if let vid = self.consultModel.v_id {
            mylog("约定详情id是空")
            paramete["vid"] = vid
        }
        if let aid = self.consultModel.aid {
            paramete["aid"] = aid
            
        }
        if let bid = self.consultModel.bid  {
            paramete["bid"] = bid
        }
        
        
        
        paramete["type"] = self.consultModel.type ?? "1"
        let router: Router = Router.post("Consultdetail/rest", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: ConsultModel.self).subscribe(onNext: { [weak self](model) in
            if model.status == 200 {
                self?.configOrderValue.text = model.data?.id
                self?.appointmentOrdreValue.text = model.data?.order_id
                self?.appointmentNameValue.text = model.data?.full_name
                self?.appointmentOldPriceValue.text = "¥" + (model.data?.price ?? "")
                self?.appointmentPayPriceValue.text = "¥" + (model.data?.pay_price ?? "")
                self?.appointmentReturnPriceValue.text = "¥" + (model.data?.rest_price ?? "")
                self?.appointmentApplyValue.text = model.data?.content
                
                self?.appointmentApplyTimeValue.text = model.data?.create_date
                self?.statusLabel.text = model.data?.text
                self?.data = model.data
                if model.data?.display == "1" {
                    self?.refuseBtn.isHidden = true
                    self?.agreeBtn.isHidden = true
                }else {
                    self?.refuseBtn.isHidden = false
                    self?.agreeBtn.isHidden = false
                }
                self?.configStautsView()
                self?.configConsultOrder()
                self?.configMiddleView()
                self?.upUI(str: model.data?.content ?? "")
                
                
                
            }else {
                DDErrorView.init(superView: (self?.view)!, error: DDError.noExpectData(model.message)).automaticRemoveAfterActionHandle = {
                    self?.request()
                }
                self?.view.bringSubview(toFront: (self?.naviBar)!)
               
            }
            
        }, onError: { (error) in
            mylog(error)
            DDErrorView.init(superView: (self.view)!, error: DDError.networkError).automaticRemoveAfterActionHandle = {
                self.request()
            }
            self.view.bringSubview(toFront: (self.naviBar))
            
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
    func configStautsView() {
        
        
        if self.statusLabel.superview == nil {
            headerView.addSubview(self.statusLabel)
        }
        if self.subStatusLabel.superview == nil {
            headerView.addSubview(self.subStatusLabel)
        }
        
        self.subStatusLabel.isHidden = true
        
        self.statusLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(60)
            make.top.equalToSuperview().offset(25)
        }
        self.subStatusLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(60)
            make.top.equalTo(self.statusLabel.snp.bottom).offset(15)
            
        }
        self.statusLabel.sizeToFit()
        self.subStatusLabel.sizeToFit()
        if self.rightImage.superview == nil {
            headerView.addSubview(rightImage)
        }
        
        rightImage.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-60)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
    }
    func configConsultOrder() {
        if self.customView.superview == nil {
            self.scrollview.addSubview(self.customView)
        }
        
        
        self.customView.backgroundColor = UIColor.white
        if self.configOrder.superview == nil {
            self.customView.addSubview(self.configOrder)
        }
        
        if self.configOrderValue.superview == nil {
            self.customView.addSubview(self.configOrderValue)
        }
        if self.appointmentOrdre.superview == nil {
            self.customView.addSubview(self.appointmentOrdre)
        }
        if self.appointmentName.superview == nil {
            self.customView.addSubview(self.appointmentName)
        }
        if self.appointmentNameValue.superview == nil {
            self.customView.addSubview(self.appointmentNameValue)
        }
        if self.appointmentOrdreValue.superview == nil {
            self.customView.addSubview(self.appointmentOrdreValue)
        }
        
        
        self.configOrder.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(80)
        }
        self.configOrderValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.configOrder.snp.right).offset(0)
            make.top.equalTo(self.configOrder.snp.top).offset(0)
            make.right.equalToSuperview().offset(-15)
            
        }
        self.appointmentOrdre.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.configOrder.snp.bottom).offset(10)
            make.width.equalTo(80)
        }
        self.appointmentOrdreValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.appointmentOrdre.snp.right)
            make.top.equalTo(self.appointmentOrdre.snp.top)
            make.right.equalToSuperview().offset(-15)
        }
        
        self.appointmentName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.appointmentOrdre.snp.bottom).offset(10)
            make.width.equalTo(80)
        }
        self.appointmentNameValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.appointmentOrdre.snp.right)
            make.top.equalTo(self.appointmentName.snp.top)
            make.right.equalToSuperview().offset(-15)
        }
        
        
    }
    
    
    func upUI(str: String = "我的") {
        let size = "我".sizeWith(font: UIFont.systemFont(ofSize: 14), maxSize: CGSize.init(width: 100, height: 20)) ?? CGSize.init(width: 20, height: 20)
        
        let labelHeight: CGFloat = size.height + 2
        self.appointmentdealLabel.frame = CGRect.init(x: 15, y: 10, width: 100, height: labelHeight)
        
        self.appointmentOldPrice.frame = CGRect.init(x: 30, y: self.appointmentdealLabel.max_Y + 10, width: 80, height: labelHeight)
        self.appointmentOldPriceValue.frame = CGRect.init(x: self.appointmentOldPrice.max_X, y: self.appointmentdealLabel.max_Y + 10, width: self.customView.width - self.appointmentOldPrice.max_X, height: labelHeight)
        
        self.appointmentPayPrice.frame = CGRect.init(x: 30, y: self.appointmentOldPrice.max_Y + 10, width: 80, height: labelHeight)
        self.appointmentPayPriceValue.frame = CGRect.init(x: self.appointmentPayPrice.max_X, y: self.appointmentOldPrice.max_Y + 10, width: self.customView.width - self.appointmentPayPrice.max_X, height: labelHeight)
        self.appointmentReturnPrice.frame = CGRect.init(x: 30, y: self.appointmentPayPrice.max_Y + 10, width: 80, height: labelHeight)
        
        self.appointmentReturnPriceValue.frame = CGRect.init(x: self.appointmentReturnPrice.max_X, y: self.appointmentPayPrice.max_Y + 10, width: self.customView.width - self.appointmentReturnPrice.max_X, height: labelHeight)
        
        self.appointmentApply.frame = CGRect.init(x: 15, y: self.appointmentReturnPrice.max_Y + 10, width: 80, height: labelHeight)
        let applysize = str.sizeWith(font: self.appointmentApplyValue.font, maxWidth: self.customView.width - 60)
        self.appointmentApplyValue.frame = CGRect.init(x: 30, y: self.appointmentApply.max_Y + 10, width: self.customView.width - 60, height: applysize.height)
        
        self.appointmentApplyTime.frame = CGRect.init(x: 15, y: self.appointmentApplyValue.max_Y + 10, width: 80, height: labelHeight)
        self.appointmentApplyTimeValue.frame = CGRect.init(x: self.appointmentApplyTime.max_X, y: self.appointmentApplyValue.max_Y + 10, width: self.customView.width - self.appointmentApplyTime.max_X, height: labelHeight)
        
        self.middleView.frame = CGRect.init(x: self.middleView.x, y: self.middleView.y, width: self.middleView.width, height: self.appointmentApplyTime.max_Y + 10)
        
        self.consultHistory.frame = CGRect.init(x: self.middleView.x, y: self.middleView.max_Y, width: self.consultHistory.width, height: 40)
        self.refuseBtn.frame = CGRect.init(x: 15, y: self.consultHistory.max_Y + 20, width: (SCREENWIDTH - 60) / 2.0, height: 40)
        self.agreeBtn.frame = CGRect.init(x: self.refuseBtn.max_X + 30, y: self.consultHistory.max_Y + 20, width: self.refuseBtn.width, height: 40)
        self.scrollview.contentSize = CGSize.init(width: SCREENWIDTH, height: self.refuseBtn.max_Y + 30)
        
        self.consultHistory.frame = CGRect.init(x: 15, y: self.middleView.max_Y + 10, width: SCREENWIDTH - 30, height: 40)
        
        
    }
    func configMiddleView() {
        if self.middleView.superview == nil {
            self.scrollview.addSubview(self.middleView)
        }
        
        self.middleView.frame = CGRect.init(x: 15, y: self.customView.max_Y + 1, width: SCREENWIDTH - 30, height: 100)
        self.middleView.backgroundColor = UIColor.white
        if self.appointmentdealLabel.superview == nil {
            self.middleView.addSubview(self.appointmentdealLabel)
        }
        if self.appointmentOldPrice.superview == nil {
            self.middleView.addSubview(self.appointmentOldPrice)
        }
        if self.appointmentOldPriceValue.superview == nil {
            self.middleView.addSubview(appointmentOldPriceValue)
        }
        if appointmentPayPrice.superview == nil {
            self.middleView.addSubview(self.appointmentPayPrice)
        }
        
        if appointmentPayPriceValue.superview == nil {
            self.middleView.addSubview(self.appointmentPayPriceValue)
        }
        if appointmentReturnPrice.superview == nil {
            self.middleView.addSubview(self.appointmentReturnPrice)
        }
        if appointmentReturnPriceValue.superview == nil {
            self.middleView.addSubview(self.appointmentReturnPriceValue)
        }
        if appointmentApply.superview == nil {
            self.middleView.addSubview(self.appointmentApply)
        }
        
        if appointmentApplyValue.superview == nil {
            self.middleView.addSubview(self.appointmentApplyValue)
        }
        if appointmentApplyTime.superview == nil {
            self.middleView.addSubview(self.appointmentApplyTime)
        }
        if appointmentApplyTimeValue.superview == nil {
            self.middleView.addSubview(self.appointmentApplyTimeValue)
        }
        if consultHistory.superview == nil {
            self.scrollview.addSubview(self.consultHistory)
        }
        
        self.appointmentApplyValue.numberOfLines = 0
        self.consultHistory.title = "协商历史"
        self.consultHistory.additionalImageIsHidden = false
        self.consultHistory.addTarget(self, action: #selector(consultHistoryAction), for: .touchUpInside)
        if self.refuseBtn.superview == nil {
            self.scrollview.addSubview(self.refuseBtn)
            self.refuseBtn.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            
        }
        if agreeBtn.superview == nil {
            self.scrollview.addSubview(self.agreeBtn)
            self.agreeBtn.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        }
        
        
        
        self.upUI(str: "我")
        
    }
    @objc func action(sender: UIButton) {
        if sender == self.refuseBtn {
            let endVC = EndAppointmentVC()
            endVC.userInfo = self.data?.id
            self.navigationController?.pushViewController(endVC, animated: true)
        }else {
            self.cover = DDCoverView.init(superView: self.view)
            self.cover?.deinitHandle = {
                self.coverClick()
            }
            let containerView = ConsultDetailAlertView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH - 80, height: 180))
            containerView.center = CGPoint.init(x: SCREENWIDTH / 2.0, y: -100)
            containerView.payPrice.text = "实际报酬:￥" + (self.data?.pay_price ?? "")
            containerView.returnPrice.text = "退回报酬:￥" + (self.data?.rest_price ?? "")
            containerView.finished = { [weak self] (result) in
                if result {
                    self?.agree()
                }else {
                    self?.coverClick()
                }
                
            }
            self.cover?.addSubview(containerView)
            UIView.animate(withDuration: 0.3) {
                containerView.center = CGPoint.init(x: SCREENWIDTH / 2.0, y: SCREENHEIGHT / 2.0)
            }
            
            
        }
    }
    func agree() {
        var paramete: [String: String] = [String: String]()
        if let cid = self.data?.id, cid.count > 0 {
            paramete["cid"] = cid
        }else {
            mylog("cid为空")
            return
        }
        if let vid = self.data?.v_id, vid.count > 0 {
            paramete["v_id"] = vid
        }else {
            mylog("vid为空")
            return
        }
        let router = Router.post("Agreeterappointment/rest", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                self.coverClick()
                self.request()
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
        }, onCompleted: nil, onDisposed: nil)
    }
    
    
    func coverClick() {
        self.cover?.removeFromSuperview()
        self.cover = nil
    }
    
    
    
    
    
    
    @objc func consultHistoryAction() {
        guard let vid = self.consultModel.v_id else {
            mylog("约定详情id是空")
            return
        }
        guard let aid = self.consultModel.aid else {
            mylog("付款人ID")
            return
        }
        guard let bid = self.consultModel.bid else {
            mylog("收款人ID")
            return
        }
        self.navigationController?.pushVC(vcIdentifier: "ConsultHistoryVC", userInfo: self.consultModel)
        
        
        
    }
    
    
}


