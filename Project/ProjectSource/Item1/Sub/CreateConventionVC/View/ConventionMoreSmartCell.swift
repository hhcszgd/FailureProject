//
//  ConventionMoreSmartCell.swift
//  Project
//
//  Created by wy on 2018/4/15.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

protocol ConventionMoreSmartCellDelegate: NSObjectProtocol {
    func actionToSimple()
    func actiontoSmartMoney(userinfo: AnyObject?)
    func payActionSmart(userinfo: AnyObject?, finished: (() -> ())?)
    
}

class ConventionMoreSmartCell: UICollectionViewCell, UITextFieldDelegate {

    ///约定名称。
    @IBOutlet var appointmentName: UITextField!
    @IBOutlet var changeBtn: UIButton!
    ///约定的人数
    
    @IBOutlet var peopleNumValue: UILabel!
    @IBOutlet var priceValue: UILabel!
    
    @IBOutlet var priceView: UIView!
    @IBOutlet var totalMoney: UILabel!
    ///选择放款的方式。
    @IBOutlet var type: UIButton!
    ///选择平均付款的时候输入金额
    @IBOutlet var moneyTextfield: UITextField!
    @IBOutlet var selectTimeView: UIView!
    @IBOutlet var selectTimeBtn: UIButton!
    ///结算方式
    @IBOutlet var settlementStyle: UIView!
    ///结算方式按钮
    @IBOutlet var settlementStyleBtn: UIButton!
    var users: [DDUserModel] = [DDUserModel]()
    
    @IBOutlet var count: UITextField!
    let rightLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("333333"), text: "元/人")
    let applicationNameLabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "   约定名称")
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applicationNameLabel.frame = CGRect.init(x: 0, y: 0, width: 100, height: 40)
        self.appointmentName.leftView = self.applicationNameLabel
        self.appointmentName.leftViewMode = .always
        self.contentView.backgroundColor = BACKCOLOR
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(tap)
        self.selectTimeView.isHidden = true
        self.moneyTextfield.inputAccessoryView = self.addToolbar()
        self.appointmentName.inputAccessoryView = self.addToolbar()
        self.moneyTextfield.rx.text.orEmpty.subscribe(onNext: { (money) in

            self.unitPrice = (money.count == 0) ? "0" : money
            self.configTotalPrice()
            
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        rightLabel.frame = CGRect.init(x: 0, y: 0, width: 40, height: 30)
        self.rightLabel.textAlignment = NSTextAlignment.right
        self.moneyTextfield.rightView = self.rightLabel
        self.moneyTextfield.rightViewMode = .always
        
        let priceTap = UITapGestureRecognizer.init(target: self, action: #selector(priceTapAction(tap:)))
        self.priceView.addGestureRecognizer(priceTap)
        let averageOrCustomViewTap = UITapGestureRecognizer.init(target: self, action: #selector(averageOrCustomTapAction(tap:)))
        
        self.averageOrCustomView.addGestureRecognizer(averageOrCustomViewTap)
        self.appointmentName.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.appointmentNameStr = title
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        self.count.rx.text.orEmpty.subscribe(onNext: { (title) in
            self.num = Int(title) ?? 0
            self.configTotalPrice()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.count.inputAccessoryView = self.addToolbar()
        
        self.configsalaryType()
        self.configWithLoanType()
        self.appointmentName.delegate = self
        self.moneyTextfield.delegate = self
        self.count.delegate = self
        
        
        // Initialization code
    }
    
    @IBOutlet var backScroll: UIScrollView!
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        configKeyboard(subView: textField, view: self.backScroll)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.moneyTextfield {
            return textField.configMoneyTextfield(string: string)
        }
        return true
    }
    var peopleNum: Int = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        self.peopleNumValue.text = "\(self.peopleNum)" + "人"
    }
    func configTotalPrice() {
        if self.salaryType == .average {
            if let price = Float(self.unitPrice) {
                let totalMoney = Float(self.peopleNum) * price * Float(self.num)
                self.totalMoney.text = String.init(format: "%0.2f", totalMoney) + "元"
            }else {
                self.totalMoney.text = "0元"
            }
        }else {
            var totalMonthy: Float = 0
            self.users.forEach({ (model) in
                if let price = model.unitPrice {
                    if let priceone = Float(price) {
                        totalMonthy += priceone
                    }
                }
            })
            
            self.totalMoney.text = String.init(format: "%0.2f", totalMonthy * Float(self.num)) + "元"
            
        }
    }
    
    
    
    func configWithLoanType() {
        switch self.loanType {
        case .simple:
            mylog("手动付款")
            self.selectTimeView.isHidden = true
            self.settlementStyle.isHidden = true
            self.countViewTop.constant = 10
            self.contentView.layoutIfNeeded()
        case .smart:
            mylog("自动付款")
            self.selectTimeView.isHidden = false
            self.settlementStyle.isHidden = false
            self.countViewTop.constant = 110
            self.contentView.layoutIfNeeded()
        default:
            break
        }
    }
    @IBAction func changeAction(_ sender: UIButton) {
        self.delegate?.actionToSimple()
    }
    weak var delegate: ConventionMoreSmartCellDelegate?
    
    @IBOutlet var averageorCustomRightLabel: UILabel!
    
    @IBOutlet var countView: UIView!
    
    @IBOutlet var countViewTop: NSLayoutConstraint!
    ///结算方式。
    @IBAction func settlementStyleBtnAction(_ sender: UIButton) {
        self.complete()
        sender.isEnabled = false
        let lender = LenderAlertView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
        lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        lender.dataArr = [LenderType.daySettlement, LenderType.hourseSettlement,  LenderType.monthSettlement, LenderType.yearSettlement]
        self.window?.addSubview(lender)
        lender.sender.subscribe(onNext: { [weak self](value) in
            self?.settlementStyleBtn.setTitle(value.rawValue, for: .normal)
            //选择完平均或者是自定义之后。单价的样式就要改变
            self?.settlementType = value
            
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
    ///结算间隔
    var settlementType: LenderType = LenderType.daySettlement
    
    
    
    @objc func averageOrCustomTapAction(tap: UITapGestureRecognizer) {
        self.complete()
        let lender = LenderAlertView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
        lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        lender.dataArr = [LenderType.average, LenderType.custom]
        self.window?.addSubview(lender)
        lender.sender.subscribe(onNext: { [weak self](value) in
            self?.averageorCustomRightLabel.text = value.rawValue
            //选择完平均或者是自定义之后。单价的样式就要改变
            if value == LenderType.average {
                self?.salaryType = SalaryType.average
            }
            if value == LenderType.custom {
                self?.salaryType = SalaryType.custom
            }
            self?.configsalaryType()
            self?.configTotalPrice()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        UIView.animate(withDuration: 0.3, animations: {
            lender.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                lender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            })
        }
        
        
    }
    
    
    
    @IBOutlet var averageOrCustomView: UIView!
    ///设置单价
    @objc func priceTapAction(tap: UITapGestureRecognizer)  {
        self.complete()
        self.clickPriceView()
    }
    ///点击单价之后。
    func clickPriceView() {
        switch self.salaryType {
        case .average:
            mylog("平均")
        case .custom:
            self.delegate?.actiontoSmartMoney(userinfo: nil)
            mylog("自定义,去设置每个人金钱。")
            
        default:
            break
        }
    }
    
    
    
    func configsalaryType() {
        switch self.salaryType {
        case .average:
            configPriceView(bo: true)
        case .custom:
            configPriceView(bo: false)
        default:
            break
        }
    }
    func configPriceView(bo: Bool) {
        self.priceValue.isHidden = bo
        self.moneyTextfield.isHidden = !bo
    }
    
    
    ///工资发放的方式，平均还是自定义。
    var salaryType: SalaryType = SalaryType.average
    
    
    
    @IBAction func selectTimeAction(_ sender: UIButton) {
        self.complete()
        sender.isEnabled = false
      
        let lender = HourView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT), type: .hourseSettlement)
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
//
//            let lender = SelectTime.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
//            lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
//
//            self.window?.addSubview(lender)
//            lender.sender.subscribe(onNext: { [weak self](value) in
//                self?.selectTimeBtn.setTitle(value, for: .normal)
//                self?.payTime = value
//                }, onError: nil, onCompleted: nil, onDisposed: nil)
//
//            UIView.animate(withDuration: 0.3, animations: {
//                lender.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
//            }) { (finished) in
//                sender.isEnabled = true
//                UIView.animate(withDuration: 0.2, animations: {
//                    lender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//                })
//            }
//
//
//        }
        
        
        
        
    }
    ///放款方式
    var loanType: LenderType = LenderType.simple
    @IBAction func typeAction(_ sender: UIButton) {
        self.complete()
        let lender = LenderAlertView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT, width: SCREENWIDTH, height: SCREENHEIGHT))
        lender.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        self.window?.addSubview(lender)
        lender.sender.subscribe(onNext: { [weak self](value) in
            self?.type.setTitle(value.rawValue, for: .normal)
            if value == LenderType.smart {
                self?.selectTimeView.isHidden = false
                self?.type.isSelected = true
                
            }else {
                self?.type.isSelected = false
                self?.selectTimeView.isHidden = true
            }
            self?.loanType = value
            self?.configWithLoanType()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        UIView.animate(withDuration: 0.3, animations: {
            lender.frame = CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                lender.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            })
        }
        
        
    }
    
    var appointmentNameStr: String = ""
    var payTime: String = ""
    var unitPrice: String = "0"
    var num: Int = 0
    
    @IBAction func payAction(_ sender: UIButton) {
        sender.isEnabled = false
        if !self.appointmentNameStr.appointmentNameLawful() {
            GDAlertView.alert("仅限中文英文数字", image: nil, time: 1, complateBlock: nil)
            sender.isEnabled = true
            return
        }
        var paramete = ["full_name": self.appointmentNameStr]
        if self.loanType == .smart {
            if self.payTime.count == 0 {
                GDAlertView.alert("时间不能为空", image: nil, time: 1, complateBlock: nil)
                sender.isEnabled = true
                return
            }else {
                paramete["payment_time"] = self.payTime
            }
            switch self.settlementType {
            case .daySettlement:
                paramete["payment"] = "2"
            case .hourseSettlement:
                paramete["payment"] = "1"
            case .monthSettlement:
                paramete["payment"] = "3"
            case .yearSettlement:
                paramete["payment"] = "4"
            default:
                break
                
            }
            paramete["Lenders"] = "2"
        }else {
            paramete["Lenders"] = "1"
        }
        if self.salaryType == .average {
            paramete["price_type"] = "1"
            if self.unitPrice.count == 0 {
                GDAlertView.alert("报酬不能为空", image: nil, time: 1, complateBlock: nil)
                sender.isEnabled = true
                return
            }
            paramete["price_one"] = self.unitPrice
            let num: Double = Double(self.num)
            let unitPrice: Double = Double(self.unitPrice)!
            let totalMoney = num * unitPrice * Double(self.peopleNum)
            paramete["price"] = String.init(format: "%0.2f", totalMoney)
            var arr: [[String: String?]] = [[String: String?]]()
            self.users.forEach({ (model) in
                var dict: [String: String?] = [String: String?]()
                dict["bid"] = model.id
                dict["bname"] = model.nickname
                dict["blogo"] = model.head_images
                dict["bphone"] = model.phone
                arr.append(dict)
            })
            let encode = JSONEncoder.init()
            do {
                let json = try encode.encode(arr)
                let str = String.init(data: json, encoding: String.Encoding.utf8) ?? ""
                paramete["friends_info"] = str
            }catch {
                
            }
            
        }else {
            paramete["price_type"] = "2"
            var totalMonthy: Double = 0
            
            self.users.forEach({ (model) in
                if let price = model.unitPrice {
                    let priceone = Double(price)!
                    totalMonthy += priceone
                }
            })
            totalMonthy = Double(self.num) * totalMonthy
            paramete["price"] = String.init(format: "%0.2f", totalMonthy)
            
            var arr: [[String: String?]] = [[String: String?]]()
            self.users.forEach({ (model) in
                var dict: [String: String?] = [String: String?]()
                dict["bid"] = model.id
                dict["bname"] = model.nickname
                dict["blogo"] = model.head_images
                dict["bphone"] = model.phone
                dict["price"] = model.unitPrice
                arr.append(dict)
            })
            let encode = JSONEncoder.init()
            do {
                let json = try encode.encode(arr)
                let str = String.init(data: json, encoding: String.Encoding.utf8) ?? ""
                paramete["friends_price"] = str
            }catch {
                
            }
            
            
            
        }
        
        
        paramete["num"] = String(self.num)
        paramete["type"] = "2"
        self.delegate?.payActionSmart(userinfo: paramete as AnyObject, finished: {
            sender.isEnabled = true
        })
    }
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        self.complete()
    }
    
    
    
    @objc func complete() {
        self.moneyTextfield.resignFirstResponder()
        self.appointmentName.resignFirstResponder()
        self.count.resignFirstResponder()
    }
    func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 35))
        toolbar.tintColor = UIColor.colorWithHexStringSwift("5585f1")
        toolbar.backgroundColor = UIColor.white
        let bar = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(complete))
        
        toolbar.items = [bar]
        return toolbar
    }
    
    
    ///金额。
    enum SalaryType {
        ///平均
        case average
        /// 自定义
        case custom
    }
    

}
