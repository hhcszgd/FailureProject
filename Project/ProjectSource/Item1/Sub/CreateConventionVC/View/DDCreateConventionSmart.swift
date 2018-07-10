//
//  DDCreateConventionSmart.swift
//  Project
//
//  Created by wy on 2018/1/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
///单人智能约定
protocol DDCreateConventionSmartDelegate: NSObjectProtocol {
    ///单人智能约定
    func conventionSmartPayAction(userinfo: AnyObject, finished: (() -> ())?)
    ///改变约定方式
    func changeConventionType()
}

class DDCreateConventionSmart: UICollectionViewCell, UITextFieldDelegate {

    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var changeTypeBtn: UIButton!
    @IBOutlet var cell2Title: UILabel!
    @IBOutlet var cell2Btn: UIButton!
    @IBOutlet var cell3Title: UILabel!
    
    @IBOutlet var cell3MoneyCount: UITextField!
    @IBOutlet var cell4Title: UILabel!
    @IBOutlet var cell4DayText: UITextField!
    
    @IBOutlet var cell4RightLabel: UILabel!
    @IBOutlet var cell5Title: UILabel!
    @IBOutlet var cell5Btn: UIButton!
    @IBOutlet var cell6Title: UILabel!
    @IBOutlet var cell6Btn: UIButton!
    @IBOutlet var cell6: UIView!
    @IBOutlet var totaloPrice: UILabel!
    

    @IBOutlet var backScroll: UIScrollView!
    let applicationNameLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "   约定名称")
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applicationNameLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        self.nameTextField.leftView = self.applicationNameLabel
        self.nameTextField.leftViewMode = .always
        self.backScroll.backgroundColor = BACKCOLOR
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(tap)
        self.cell3MoneyCount.inputAccessoryView = self.addToolbar()
        self.cell4DayText.inputAccessoryView = self.addToolbar()
        self.nameTextField.inputAccessoryView = self.addToolbar()
        self.cell6.isHidden = true
        self.contentView.backgroundColor = UIColor.white
        self.nameTextField.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.appointmentNameStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.cell3MoneyCount.rx.text.orEmpty.subscribe(onNext: { (title) in
 
            self.unitPrice = title
            self.configTotalPrice()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.cell4DayText.rx.text.orEmpty.subscribe(onNext: { (title) in

            self.num = title
            
            self.configTotalPrice()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.configwithLenderType()
        self.cell3MoneyCount.returnKeyType = .done
        self.cell4DayText.returnKeyType = .done
        self.nameTextField.returnKeyType = .done
        
        self.cell3MoneyCount.delegate = self
        self.cell4DayText.delegate = self
        self.nameTextField.delegate = self
        
        // Initialization code
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        configKeyboard(subView: textField, view: self.backScroll)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cell3MoneyCount {
            return textField.configMoneyTextfield(string: string)
        }
        return true
    }
    
    func configTotalPrice() {
        if let price = Float(self.unitPrice), let count = Float(self.num) {
            self.appointmentTotalMoney = String.init(format: "%0.2f元", price * count)
        }else {
            self.appointmentTotalMoney = "0元"
        }
        self.totaloPrice.text = self.appointmentTotalMoney
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        self.complete()
        
    }
    ///约定名称
    var appointmentNameStr: String = ""
    ///约定总金额
    var appointmentTotalMoney: String = "0"
    ///放款方式1,手动放款，2自动放款，自动放款必须写时间。
    var lenderType: LenderType = LenderType.simple
    ///放款期数量
    var num: String = ""
    
    ///单价
    var unitPrice: String = ""
    
    ///放款时间
    var payTime: String = ""
    
    
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
                GDAlertView.alert("时间不能为空", image: nil, time: 1, complateBlock: nil)
                sender.isEnabled = true
                return
            }else {
                paramete["payment_time"] = self.payTime
            }
            paramete["Lenders"] = "2"
            var partime: String = "1"
            switch self.settlementType {
            case .hourseSettlement:
                partime = "1"
            case .daySettlement:
                partime = "2"
            case .monthSettlement:
                partime = "3"
            case .yearSettlement:
                partime = "4"
            default:
                break
            }
            paramete["payment"] = partime

        }else {
            paramete["Lenders"] = "1"
        }
//        if self.appointmentTotalMoney.count == 0 {
//            GDAlertView.alert("金额不能为空", image: nil, time: 1, complateBlock: nil)
//            return
//        }
        if self.unitPrice.count == 0 {
            GDAlertView.alert("报酬不能为空", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        paramete["price_one"] = self.unitPrice
        if self.num.count == 0 {
            sender.isEnabled = true
            GDAlertView.alert("期数不能为空", image: nil, time: 1, complateBlock: nil)
            return
        }

        
        paramete["num"] = self.num
        let num: Double = Double(self.num)!
        let unitPrice: Double = Double(self.unitPrice)!
        
        let totalMoney = num * unitPrice
        paramete["price"] = String.init(format: "%0.2f", totalMoney)
        paramete["type"] = "2"
        self.delegate?.conventionSmartPayAction(userinfo: paramete as AnyObject, finished: {
            sender.isEnabled = true
        })
        
        
        
        
    }
    
    
    
    weak var delegate: DDCreateConventionSmartDelegate?
    
    ///改变约定方式
    @IBAction func chageTypeAction(_ sender: UIButton) {
        self.delegate?.changeConventionType()
    }
    ///结算方式
    var settlementType: SettlementMethod = SettlementMethod.daySettlement
    ///结算方式
    @IBAction func settlementTypeAction(_ sender: UIButton) {
        self.complete()
        let settlement = SettlementTypeView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
        settlement.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.window?.addSubview(settlement)
        settlement.sender.subscribe(onNext: { (value) in
            sender.setTitle(value.rawValue, for: .normal)
            self.settlementType = value
            ///修改
//            switch value {
//            case .daySettlement:
//                self.cell4RightLabel.text = "日"
//            case .hourseSettlement:
//                self.cell4RightLabel.text = "时"
//            case .monthSettlement:
//                self.cell4RightLabel.text = "月"
//            case .yearSettlement:
//                self.cell4RightLabel.text = "年"
//            default:
//                break
//            }
           
            
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        UIView.animate(withDuration: 0.3, animations: {
            settlement.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                settlement.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            })
        }
    }
    ///根据放款方式决定页面展示
    func configwithLenderType() {
        if self.lenderType == .simple {
            self.top.constant = 10
            self.contentView.layoutIfNeeded()
            self.cell6.isHidden = true
            self.settlementTypeView.isHidden = true
            
        }else {
            self.top.constant = 110
            self.contentView.layoutIfNeeded()
            self.cell6.isHidden = false
            self.settlementTypeView.isHidden = false
        }
    }
    
    ///结算方式
    @IBOutlet var settlementTypeView: UIView!
    ///放款方式
    @IBAction func lendersAction(_ sender: UIButton) {
        self.complete()
        sender.isUserInteractionEnabled = false
        let lender = LenderAlertView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
        lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.window?.addSubview(lender)
        lender.sender.subscribe(onNext: { [weak self](value) in
            self?.lenderType = value
            if self?.lenderType == LenderType.smart {
                sender.isSelected = true
                
            }else {
                sender.isSelected = false
            }
            
            self?.configwithLenderType()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        UIView.animate(withDuration: 0.3, animations: {
            lender.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            sender.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.2, animations: {
                lender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            })
        }
    }
    ///放款时间
    @IBAction func lenderTimeAction(_ sender: UIButton) {
        self.complete()
        sender.isEnabled = false
        let lender = HourView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT), type: self.settlementType)
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
        
        
//        if self.settlementType == .hourseSettlement {
//            
//        }else {
//            let lender = SelectTime.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
//            lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//            
//            self.window?.addSubview(lender)
//            lender.sender.subscribe(onNext: { [weak self](value) in
//                sender.setTitle(value, for: .normal)
//                self?.payTime = value
//                }, onError: nil, onCompleted: nil, onDisposed: nil)
//            UIView.animate(withDuration: 0.3, animations: {
//                lender.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
//            }) { (finished) in
//                sender.isEnabled = true
//                UIView.animate(withDuration: 0.2, animations: {
//                    lender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//                })
//            }
//        }
    }
    @objc func complete() {
        self.cell4DayText.resignFirstResponder()
        self.cell3MoneyCount.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        
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
