//
//  DDPayDetailCell.swift
//  Project
//
//  Created by 金曼立 on 2018/5/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPayDetailCell: DDTableViewCell {
    
    var type : String? // 1 单人  2 多人
    
    let icon = UIImageView()
    let name = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: color11, text: "")
    let date = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let money = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
//    let stateBtn = UIButton()
    let moneyChange = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "报酬有修改")
    
    var payDetailModel : DDPayDetailInfoModel? = DDPayDetailInfoModel() {
        didSet{
//            if type == "1" {
//                stateBtn.isHidden = false
//                money.snp.remakeConstraints { (make) in
//                    make.centerY.equalToSuperview()
//                    make.right.equalTo(stateBtn.snp.left).offset(-5)
//                }
//                if payDetailModel?.status == "6" {
//                    stateBtn.setTitle("已放款", for: UIControlState.normal)
//                    stateBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
//                } else if payDetailModel?.status == "5" {
//                    stateBtn.setTitle("终止约定", for: UIControlState.normal)
//                    stateBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
//                } else {
//                    stateBtn.setTitle("未放款", for: UIControlState.normal)
//                    stateBtn.backgroundColor = UIColor.lightGray
//                }
//            }
            
            icon.setImageUrl(url: payDetailModel?.blogo)
            let nameStr = payDetailModel?.bname ?? ""
            let bphoneStr = payDetailModel?.bphone ?? ""
//            name.text = nameStr + "(" + bphoneStr + ")"
            let phone = "(" + bphoneStr + ")"
            name.attributedText = self.attributedString(number: nameStr, string: phone)
            date.text = payDetailModel?.grant_time
            money.text = payDetailModel?.payment_prive
            
            switch payDetailModel?.status ?? "" {
            case "6": // 已完成
                // 1 有修改  0 未修改
                if payDetailModel?.mod_tag ?? "" == "0" {
                    moneyChange.isHidden = true
                    money.textColor = color11
                    money.font = UIFont.systemFont(ofSize: 15)
                    money.snp.remakeConstraints { (make) in
                        make.centerY.equalToSuperview()
                        make.right.equalToSuperview().offset(-15)
                    }
                } else {
                    moneyChange.isHidden = false
                    moneyChange.text = "报酬有修改"
                    money.font = UIFont.systemFont(ofSize: 12)
                    money.textColor = UIColor.colorWithHexStringSwift("e60000")
                    money.snp.remakeConstraints { (make) in
                        make.bottom.equalToSuperview().offset(-15)
                        make.right.equalToSuperview().offset(-15)
                    }
                    moneyChange.snp.remakeConstraints { (make) in
                        make.top.equalToSuperview().offset(15)
                        make.right.equalToSuperview().offset(-15)
                    }
                }
            case "5":
                moneyChange.isHidden = false
                moneyChange.text = "终止约定"
                money.font = UIFont.systemFont(ofSize: 12)
                money.textColor = UIColor.colorWithHexStringSwift("e60000")
                money.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-15)
                    make.right.equalToSuperview().offset(-15)
                }
                moneyChange.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().offset(15)
                    make.right.equalToSuperview().offset(-15)
                }
            default:
                moneyChange.isHidden = true
                money.textColor = UIColor.colorWithHexStringSwift("e60000")
                money.font = UIFont.systemFont(ofSize: 15)
                money.text = "未放款"
                money.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalToSuperview().offset(-15)
                }
            }
            
//            if payDetailModel?.status == "6" {
//                // 已完成
//                moneyChange.isHidden = true
//                money.textColor = color11
//                money.font = UIFont.systemFont(ofSize: 15)
//                money.snp.remakeConstraints { (make) in
//                    make.centerY.equalToSuperview()
//                    make.right.equalToSuperview().offset(-15)
//                }
//            } else if payDetailModel?.status == "5" {
//                moneyChange.isHidden = false
//                moneyChange.text = "终止约定"
//                money.font = UIFont.systemFont(ofSize: 12)
//                money.textColor = UIColor.colorWithHexStringSwift("e60000")
//                money.snp.remakeConstraints { (make) in
//                    make.bottom.equalToSuperview().offset(-15)
//                    make.right.equalToSuperview().offset(-15)
//                }
//                moneyChange.snp.remakeConstraints { (make) in
//                    make.top.equalToSuperview().offset(15)
//                    make.right.equalToSuperview().offset(-15)
//                }
//            } else {
//                moneyChange.isHidden = true
//                money.textColor = UIColor.colorWithHexStringSwift("e60000")
//                money.font = UIFont.systemFont(ofSize: 15)
//                money.text = "未放款"
//                money.snp.remakeConstraints { (make) in
//                    make.centerY.equalToSuperview()
//                    make.right.equalToSuperview().offset(-15)
//                }
//            }
        
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        stateBtn.isUserInteractionEnabled = false
//        stateBtn.isHidden = true
        
        contentView.addSubview(icon)
        contentView.addSubview(name)
        contentView.addSubview(date)
        contentView.addSubview(money)
//        contentView.addSubview(stateBtn)
        contentView.addSubview(moneyChange)

        icon.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
            make.bottom.equalTo(contentView).offset(-15)
        }
        name.snp.makeConstraints { (make) in
            make.top.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(15)
        }
        date.snp.makeConstraints { (make) in
            make.bottom.equalTo(icon)
            make.left.equalTo(name)
        }
        money.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalToSuperview().offset(-15)
        }
//        stateBtn.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-15)
//            make.width.equalTo(75)
//            make.height.equalTo(30)
//        }
        moneyChange.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    func attributedString(number: String, string: String) -> NSMutableAttributedString {
        let peopleStr : NSMutableAttributedString = NSMutableAttributedString()
        let peopleStr1 = self.appendColorStrWithString(str: number, font: 15, color: color11)
        let peopleStr2 = self.appendColorStrWithString(str: string, font: 12, color: color11)
        peopleStr.append(peopleStr1)
        peopleStr.append(peopleStr2)
        return peopleStr
    }
    
    func appendColorStrWithString(str: String, font: CGFloat, color: UIColor) -> NSAttributedString {
        let attStr = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: font),NSAttributedStringKey.foregroundColor:color])
        return attStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
