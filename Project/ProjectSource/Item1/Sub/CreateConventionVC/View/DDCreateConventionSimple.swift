//
//  DDCreateConventionSimple.swift
//  Project
//
//  Created by wy on 2018/1/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
let priceLimit: Int = 99999999
let priceSmallLimit: Int = 1


///手续费
let POUNDAGE: Float = 1.006
protocol DDCreateConventionSimpleDelegate: NSObjectProtocol {
    func payAction(userInfo: AnyObject?, finished: (() -> ())?)
    func changeConventionTypeToSmart()
}
class DDCreateConventionSimple: UICollectionViewCell, UITextFieldDelegate {
    @IBOutlet var appointmentName: UITextField!
    
    @IBOutlet var changeBtn: UIButton!
    
    @IBOutlet var moneyTextfield: UITextField!
    
    @IBOutlet var type: UIButton!
    
    @IBOutlet var totalTop: NSLayoutConstraint!
    @IBOutlet var selectTimeView: UIView!
    @IBOutlet var selectTimeBtn: UIButton!
    
    @IBAction func selectTimeAction(_ sender: UIButton) {
        self.complete()
        sender.isEnabled = false
        
        
        let lender = HourView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
        lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        self.window?.addSubview(lender)
        lender.sender.subscribe(onNext: { [weak self](value) in
            sender.setTitle(value, for: .normal)
            self?.payTime = value
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        UIView.animate(withDuration: 0.3, animations: {
            lender.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            sender.isEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                lender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            })
        }
        
        
        
    }
    
    @IBOutlet var totalMoney: UILabel!

    @IBOutlet var secondTotalMoney: UILabel!
    @IBAction func typeAction(_ sender: UIButton) {
        self.complete()
        sender.isEnabled = false
        let lender = LenderAlertView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
        lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        self.window?.addSubview(lender)
        lender.sender.subscribe(onNext: { [weak self](value) in
            self?.type.setTitle(value.rawValue, for: .normal)
            if value == LenderType.smart {
                self?.selectTimeView.isHidden = false
                self?.totalTop.constant = 65
                self?.layoutIfNeeded()
                self?.type.isSelected = true
            }else {
                self?.totalTop.constant = 25
                self?.layoutIfNeeded()
                self?.type.isSelected = false
                self?.selectTimeView.isHidden = true
            }
            self?.lenderType = value
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        UIView.animate(withDuration: 0.3, animations: {
            lender.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            sender.isEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                lender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            })
        }
    
        
    }
    
    ///约定名称
    var appointmentNameStr: String = ""
    ///约定总金额
    var appointmentTotalMoney: String = "0"
    ///放款方式1,手动放款，2自动放款，自动放款必须写时间。
    var lenderType: LenderType = LenderType.simple
    ///约定类型。
    
    
    ///参加约定的人。
    var memberID: String = ""
    ///放款时间
    var payTime: String = ""
    weak var delegate: DDCreateConventionSimpleDelegate?
    @IBAction func payAction(_ sender: UIButton) {
        sender.isEnabled = false
    
         if !self.appointmentNameStr.appointmentNameLawful() {
            GDAlertView.alert("仅限中文英文数字", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        var paramete = ["full_name": self.appointmentNameStr]
        if self.lenderType == .smart {
            if self.payTime.count == 0 {
                GDAlertView.alert("放款时间不能为空", image: nil, time: 1, complateBlock: nil)
                sender.isEnabled = true
                return
            }else {
                paramete["payment_time"] = self.payTime
            }
            paramete["Lenders"] = "2"
        }else {
            paramete["Lenders"] = "1"
        }
        if self.appointmentTotalMoney.count == 0 {
            GDAlertView.alert("报酬不能为空", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        paramete["price"] = self.appointmentTotalMoney
        paramete["type"] = "1"
        
        
        
        self.delegate?.payAction(userInfo: paramete as AnyObject, finished: {
            sender.isEnabled = true
        })
        
        
    }
    
    weak var viewController: UIViewController?
    let applicationNameLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "   约定名称")
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applicationNameLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        self.appointmentName.leftView = self.applicationNameLabel
        self.appointmentName.leftViewMode = .always
        
        self.totalTop.constant = 25
        self.layoutIfNeeded()
        self.contentView.backgroundColor = BACKCOLOR
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(tap)
        self.contentView.backgroundColor = BACKCOLOR
        self.selectTimeView.isHidden = true
        self.moneyTextfield.inputAccessoryView = self.addToolbar()
        self.appointmentName.inputAccessoryView = self.addToolbar()
        self.moneyTextfield.rx.text.orEmpty.subscribe(onNext: { (money) in
            self.totalMoney.text = money + "元"
            var moneystr = NSString.init(string: money)
            let moneynum = moneystr.floatValue
            
            let totalMoney = moneynum
            
                moneystr = NSString.init(format: "%.2f", totalMoney)
            self.secondTotalMoney.text = moneystr as! String
            self.appointmentTotalMoney = money
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        
        self.appointmentName.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.appointmentNameStr = title
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.moneyTextfield.returnKeyType = UIReturnKeyType.done
        self.appointmentName.returnKeyType = .done
        self.appointmentName.delegate = self
        self.moneyTextfield.delegate = self
        
        
    }
    @IBOutlet var backScroll: UIScrollView!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        configKeyboard(subView: textField, view: self.backScroll)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.moneyTextfield {
            return textField.configMoneyTextfield(string: string)
        }
        
        return true
    }
    
    
    
    @IBAction func changeBtnAction(_ sender: UIButton) {
        self.delegate?.changeConventionTypeToSmart()
    }
    
    
    
    
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        self.complete()
    }
    
    
    
    @objc func complete() {
        self.moneyTextfield.resignFirstResponder()
        self.appointmentName.resignFirstResponder()
    }
    func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 35))
        toolbar.tintColor = UIColor.colorWithHexStringSwift("5585f1")
        toolbar.backgroundColor = UIColor.white
        let bar = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(complete))
        
        toolbar.items = [bar]
        return toolbar
    }
}

class InstallBtn: UIButton {
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let image = self.currentImage else {
            return CGRect.zero
        }
        guard let title = self.currentTitle else { return CGRect.zero }
        let width = image.size.width
        let size = title.sizeSingleLine(font: UIFont.systemFont(ofSize: 14))
        
        let x: CGFloat = contentRect.size.width - image.size.width - 10 - size.width
        let y: CGFloat = (contentRect.size.height - size.height) / 2.0
        
        
        
        return CGRect.init(x: x, y: y, width: size.width, height: size.height)
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        guard let image = self.currentImage else { return CGRect.zero }
        let width: CGFloat = image.size.width
        let height: CGFloat = image.size.height
        
        let x: CGFloat = (contentRect.size.width - width)
        let y: CGFloat = (contentRect.size.height - height) / 2.0
        
        return CGRect.init(x: x, y: y, width: width, height: height)
    }
    
    
}


