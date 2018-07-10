//
//  ConventionMoreSimpleCell.swift
//  Project
//
//  Created by wy on 2018/1/6.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//
protocol ConventionMoreSimpleCellDelegate: NSObjectProtocol {
    ///跳转到设置金额页面
    func actionToConfigVC(userinfo: Any?)
    func actionToSmart()
    func moreSimplePay(userinfo: Any?, finished: (() -> ())?)
    
}

import UIKit
///多人一次约定。
class ConventionMoreSimpleCell: UICollectionViewCell, UITextFieldDelegate {
    ///约定名称。
    @IBOutlet var appointmentName: UITextField!
    @IBOutlet var changeBtn: UIButton!
    ///约定的人数
    @IBOutlet var perpleNumValue: UILabel!
    
    
    @IBOutlet var priceValue: UILabel!
    
    @IBOutlet var priceView: UIView!
    @IBOutlet var priceViewRightImage: UIView!
    @IBOutlet var totalMoney: UILabel!
    ///选择放款的方式。
    @IBOutlet var type: UIButton!
    ///选择平均付款的时候输入金额
    @IBOutlet var moneyTextfield: UITextField!
    @IBOutlet var selectTimeView: UIView!
    @IBOutlet var selectTimeBtn: UIButton!
    
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
            self.unitPrice = money
            self.configTotalPrice()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        self.moneyTextfield.delegate = self
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
        self.appointmentName.delegate = self
        // Initialization code
    }
    func configTotalPrice() {
        if self.salaryType == .average {
            if let price = Float(self.unitPrice) {
                let totalMoney = Float(self.peopleNum) * price
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
            self.totalMoney.text = String.init(format: "%0.2f", totalMonthy) + "元"
            
        }
        
        
        
        
    }
    @IBOutlet var backScroll: UIScrollView!
    
    
    var peopleNum: Int = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        self.perpleNumValue.text = "\(self.peopleNum)" + "人"
    }
    
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
    @IBOutlet var averageorCustomRightLabel: UILabel!
    
    ///约定名称
    var appointmentNameStr: String = ""
    ///约定总金额
    var appointmentTotalMoney: String = "0"
    ///放款方式1,手动放款，2自动放款，自动放款必须写时间。
    var lenderType: LenderType = LenderType.simple
 
    ///单价
    var unitPrice: String = ""
    ///放款时间
    var payTime: String = ""
    
    
    
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
    
    @IBAction func changeAction(_ sender: UIButton) {
        self.delegate?.actionToSmart()
    }
    
    
    @IBOutlet var averageOrCustomView: UIView!
    ///设置单价
    @objc func priceTapAction(tap: UITapGestureRecognizer)  {
        self.clickPriceView()
    }
    ///点击单价之后。
    func clickPriceView() {
        switch self.salaryType {
        case .average:
            mylog("平均")
        case .custom:
            self.delegate?.actionToConfigVC(userinfo: nil)
            mylog("自定义,去设置每个人金钱。")
            
        default:
            break
        }
    }
    weak var delegate: ConventionMoreSimpleCellDelegate?
    var users: [DDUserModel] = [DDUserModel]()
    
    
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
    
    
    
    var salaryType: SalaryType = SalaryType.average
    
    
    
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
    @IBAction func typeAction(_ sender: UIButton) {
        sender.isEnabled = false
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
            let num: Double = Double(self.peopleNum)
            let unitPrice: Double = Double(self.unitPrice)!
            let totalMoney = num * unitPrice
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
        
        paramete["type"] = "1"

        self.delegate?.moreSimplePay(userinfo: paramete as AnyObject, finished: {
            sender.isEnabled = true
        })
        
        
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
    
    
    ///金额。
    enum SalaryType {
        ///平均
        case average
        /// 自定义
        case custom
    }
    
    

}
