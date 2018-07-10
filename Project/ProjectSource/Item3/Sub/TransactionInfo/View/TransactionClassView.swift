//
//  TransactionClassView.swift
//  Project
//
//  Created by wy on 2018/7/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

enum TransactionType {
    case allClass
    case income
    case withDraw
    case recharge
    case appointment
    case directPay
    case refund
}


class TransactionClassView: UIView {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    
    @IBOutlet weak var income: UIButton!
    
    
    @IBOutlet weak var withDeaw: UIButton!
    @IBOutlet weak var recharge: UIButton!
    @IBOutlet weak var appointmentbtn: UIButton!
    @IBOutlet weak var directPay: UIButton!
    var finished: ((TransactionType) -> ())!
    var containerView: UIView!
    
    init(frame: CGRect, type: TransactionType) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("TransactionClassView", owner: self, options: nil)?.last as! UIView
        self.addSubview(self.containerView)
        let btnArr = [self.allBtn, self.income, self.withDeaw, self.recharge, self.appointmentbtn, self.directPay]
        btnArr.forEach { (btn) in
            btn?.layer.cornerRadius = 6
            btn?.layer.borderColor = UIColor.colorWithHexStringSwift("cccccc").cgColor
            btn?.layer.borderWidth = 1
            btn?.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
            switch type {
            case .allClass:
                if btn?.tag == 11 {
                    btn?.backgroundColor = UIColor.colorWithHexStringSwift("6491f9")
                    btn?.isSelected = true
                }
            case .income:
                if btn?.tag == 12 {
                    btn?.backgroundColor = UIColor.colorWithHexStringSwift("6491f9")
                    btn?.isSelected = true
                }
            case .directPay:
                if btn?.tag == 13 {
                    btn?.backgroundColor = UIColor.colorWithHexStringSwift("6491f9")
                    btn?.isSelected = true
                }
            case .appointment:
                if btn?.tag == 14 {
                    btn?.backgroundColor = UIColor.colorWithHexStringSwift("6491f9")
                    btn?.isSelected = true
                }
            case .recharge:
                if btn?.tag == 15 {
                    btn?.backgroundColor = UIColor.colorWithHexStringSwift("6491f9")
                    btn?.isSelected = true
                }
            case .withDraw:
                if btn?.tag == 16 {
                    btn?.backgroundColor = UIColor.colorWithHexStringSwift("6491f9")
                    btn?.isSelected = true
                    
                }
            default:
                break
            }
            
        }
        
        
        
    }
    @objc func clickBtn(sender: UIButton) {
        sender.isSelected = true
        var type: TransactionType = TransactionType.allClass
        switch sender {
        case self.allBtn:
            type = .allClass
        case self.income:
            type = .income
        case self.directPay:
            type = .directPay
        case self.appointmentbtn:
            type = .appointment
        case self.recharge:
            type = .recharge
        case self.withDeaw:
            type = .withDraw
        default:
            break
        }
        finished!(type)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
