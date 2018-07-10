//
//  ProfileSubheader.swift
//  Project
//
//  Created by wy on 2018/4/1.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
///我的页面的四个按钮页面的代理
protocol ProfileSubHeaderDelegate: NSObjectProtocol {
    func profileSubHeaderAction(key: ProfileSubHeaderAction)
}
enum ProfileSubHeaderAction {
    ///直接付款
    case directPay
    ///冻结金额
    case freezing
    ///充值
    case recharge
    ///提现
    case withDraw
}
class ProfileSubheader: UIView {
    var containerView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("ProfileSubheader", owner: self, options: nil)?.last as! UIView
        self.addSubview(self.containerView)
        let label = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
        label.sizeToFit()
        label.textAlignment = NSTextAlignment.center
        self.freezingBtn.myTitleLabel = label
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
    
    weak var delegate:  ProfileSubHeaderDelegate?
//    @IBOutlet var directBtn: ProfileBtn!
    
    @IBOutlet var freezingBtn: ProfileBtn!
    
    @IBAction func directPayAction(_ sender: ProfileBtn) {
        self.delegate?.profileSubHeaderAction(key: .directPay)
    }
    @IBAction func freezingAction(_ sender: ProfileBtn) {
        self.delegate?.profileSubHeaderAction(key: .freezing)
    }
//    @IBOutlet var rechArgeBtn: ProfileBtn!
    @IBAction func rechArgeAction(_ sender: ProfileBtn) {
        self.delegate?.profileSubHeaderAction(key: .recharge)
    }
    
    @IBOutlet var withDrawBtn: ProfileBtn!
    @IBAction func withdrawAction(_ sender: ProfileBtn) {
        self.delegate?.profileSubHeaderAction(key: .withDraw)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
