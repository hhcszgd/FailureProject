//
//  DDPerformChangeMoneyCell.swift
//  Project
//
//  Created by 金曼立 on 2018/5/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPerformChangeMoneyCell: DDTableViewCell {
    
    var btnCallBack:(() -> ())?
    
    let stage = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "放款期数：")
    let stageNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let time = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "放款时间：")
    let timeNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let originMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "原定报酬：")
    let originMoneyNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let backMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "退回报酬：")
    let backMoneyNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let payMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "实际报酬：")
    let payMoneyNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let moneyChange = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("fe0000"), text: "报酬有修改")
    let statusBtn = UIButton()
    let payButton = UIButton()
    // 注意：在赋值model之前，赋值 period_tag 和 user_tag
    var user_tag : String?
    var period_tag : String?
    var periodsModel : DDPeriodsListModel = DDPeriodsListModel() {
        didSet{
            moneyChange.isHidden = true
            statusBtn.isUserInteractionEnabled = true
            statusBtn.backgroundColor = UIColor.DDThemeColor
            if period_tag == "1" {
                configSingleStageData()
            } else if period_tag == "2" {
                configMoreStageData()
            }
        }
    }
    
    func configSingleStageData() {
        // 单期
        switch periodsModel.status ?? "" {
        case "1":
            stage.text = "放款报酬："
            stageNum.text = periodsModel.pay_price
            stage.snp.remakeConstraints { (make) in
                make.top.left.equalTo(contentView).offset(15)
                make.bottom.equalTo(contentView).offset(-15)
            }
            statusBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(contentView).offset(-15)
                make.centerY.equalTo(contentView)
                make.width.equalTo(75)
                make.height.equalTo(30)
            }
            if user_tag == "1" {
                // 甲方
                statusBtn.setTitle("修改", for: UIControlState.normal)
            } else if user_tag == "2" {
                // 乙方
                statusBtn.setTitle("未放款", for: UIControlState.normal)
                statusBtn.isUserInteractionEnabled = false
                statusBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
            }
        case "2":
            stage.text = "放款报酬："
            stageNum.text = periodsModel.pay_price
            statusBtn.setTitle("详情", for: UIControlState.normal)
            moneyChange.isHidden = false
            stage.snp.remakeConstraints { (make) in
                make.top.left.equalTo(contentView).offset(15)
                make.bottom.equalTo(contentView).offset(-15)
            }
            moneyChange.snp.remakeConstraints { (make) in
                make.centerY.equalTo(stage)
                make.left.equalTo(stageNum.snp.right).offset(20)
            }
            statusBtn.snp.remakeConstraints { (make) in
                make.right.equalTo(contentView).offset(-15)
                make.centerY.equalTo(stage)
                make.width.equalTo(75)
                make.height.equalTo(30)
            }
        case "4":
            originMoney.snp.remakeConstraints { (make) in
                make.top.left.equalTo(contentView).offset(15)
            }
            originMoneyNum.text = periodsModel.price
            backMoneyNum.text = periodsModel.rest_price
            payMoneyNum.text = periodsModel.pay_price
            statusBtn.setTitle("详情", for: UIControlState.normal)
            moneyChange.isHidden = false
            stage.isHidden = true
            time.isHidden = true
        case "5":
//            originMoney.snp.remakeConstraints { (make) in
//                make.top.left.equalTo(contentView).offset(15)
//            }
//            originMoneyNum.text = periodsModel.price
//            backMoneyNum.text = periodsModel.rest_price
//            payMoneyNum.text = periodsModel.pay_price
//            stage.isHidden = true
//            time.isHidden = true
//            statusBtn.setTitle("已放款", for: UIControlState.normal)
//            statusBtn.isUserInteractionEnabled = false
//            statusBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
            originMoney.text = "原定报酬："
            originMoneyNum.text = periodsModel.price
            backMoneyNum.text = periodsModel.rest_price
            payMoneyNum.text = periodsModel.pay_price
            statusBtn.setTitle("详情", for: UIControlState.normal)
            originMoney.snp.remakeConstraints { (make) in
                make.left.right.equalTo(stage)
                make.top.equalTo(time.snp.bottom).offset(15)
            }
            moneyChange.isHidden = false
            backMoney.isHidden = false
            backMoneyNum.isHidden = false
            payMoney.isHidden = false
            payMoneyNum.isHidden = false
            payButton.isHidden = false
        case "6":
            // 1  修改  0 未修改
            if periodsModel.mod_tag == "1" {
                originMoney.text = "原定报酬："
                originMoneyNum.text = periodsModel.price
                backMoneyNum.text = periodsModel.rest_price
                payMoneyNum.text = periodsModel.pay_price
                statusBtn.setTitle("详情", for: UIControlState.normal)
                originMoney.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(stage)
                    make.top.equalTo(time.snp.bottom).offset(15)
                }
                moneyChange.isHidden = false
                backMoney.isHidden = false
                backMoneyNum.isHidden = false
                payMoney.isHidden = false
                payMoneyNum.isHidden = false
                payButton.isHidden = false
            } else if periodsModel.mod_tag == "0" {
                originMoney.text = "实际报酬："
                originMoney.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(stage)
                    make.top.equalTo(time.snp.bottom).offset(15)
                    make.bottom.equalTo(contentView).offset(-15)
                }
                statusBtn.setTitle("已放款", for: UIControlState.normal)
                statusBtn.isUserInteractionEnabled = false
                statusBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
            }
//            originMoney.snp.remakeConstraints { (make) in
//                make.top.left.equalTo(contentView).offset(15)
//            }
//            originMoneyNum.text = periodsModel.price
//            backMoneyNum.text = periodsModel.rest_price
//            payMoneyNum.text = periodsModel.pay_price
//            stage.isHidden = true
//            time.isHidden = true
//            statusBtn.setTitle("已放款", for: UIControlState.normal)
//            statusBtn.isUserInteractionEnabled = false
//            statusBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
        default :
            break
        }
    }
    
    func configMoreStageData() {
        // 多期
        stageNum.text = periodsModel.num
        timeNum.text = periodsModel.grant_time
        originMoneyNum.text = periodsModel.pay_price
        backMoney.isHidden = true
        backMoneyNum.isHidden = true
        payMoney.isHidden = true
        payMoneyNum.isHidden = true
        switch periodsModel.status ?? "" {
        case "1":
            originMoney.text = "实际报酬："
            originMoney.snp.remakeConstraints { (make) in
                make.left.right.equalTo(stage)
                make.top.equalTo(time.snp.bottom).offset(15)
                make.bottom.equalTo(contentView).offset(-15)
            }
            if user_tag == "1" {
                // 甲方
                statusBtn.setTitle("修改", for: UIControlState.normal)
            } else if user_tag == "2" {
                // 乙方
                statusBtn.setTitle("未放款", for: UIControlState.normal)
                statusBtn.isUserInteractionEnabled = false
                statusBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
            }
        case "2":
            originMoney.text = "实际报酬："
            originMoney.snp.remakeConstraints { (make) in
                make.left.right.equalTo(stage)
                make.top.equalTo(time.snp.bottom).offset(15)
                make.bottom.equalTo(contentView).offset(-15)
            }
            statusBtn.setTitle("详情", for: UIControlState.normal)
            moneyChange.isHidden = false
        case "4":
            originMoney.text = "原定报酬："
            originMoneyNum.text = periodsModel.price
            backMoneyNum.text = periodsModel.rest_price
            payMoneyNum.text = periodsModel.pay_price
            statusBtn.setTitle("详情", for: UIControlState.normal)
            originMoney.snp.remakeConstraints { (make) in
                make.left.right.equalTo(stage)
                make.top.equalTo(time.snp.bottom).offset(15)
            }
            moneyChange.isHidden = false
            backMoney.isHidden = false
            backMoneyNum.isHidden = false
            payMoney.isHidden = false
            payMoneyNum.isHidden = false
        case "5":
//            originMoney.text = "实际报酬："
//            originMoney.snp.remakeConstraints { (make) in
//                make.left.right.equalTo(stage)
//                make.top.equalTo(time.snp.bottom).offset(15)
//                make.bottom.equalTo(contentView).offset(-15)
//            }
//            statusBtn.setTitle("已放款", for: UIControlState.normal)
//            statusBtn.isUserInteractionEnabled = false
//            statusBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
            originMoney.text = "原定报酬："
            originMoneyNum.text = periodsModel.price
            backMoneyNum.text = periodsModel.rest_price
            payMoneyNum.text = periodsModel.pay_price
            statusBtn.setTitle("详情", for: UIControlState.normal)
            originMoney.snp.remakeConstraints { (make) in
                make.left.right.equalTo(stage)
                make.top.equalTo(time.snp.bottom).offset(15)
            }
            moneyChange.isHidden = false
            backMoney.isHidden = false
            backMoneyNum.isHidden = false
            payMoney.isHidden = false
            payMoneyNum.isHidden = false
            payButton.isHidden = false
        case "6":
            // 1  修改  0 未修改
            if periodsModel.mod_tag == "1" {
                originMoney.text = "原定报酬："
                originMoneyNum.text = periodsModel.price
                backMoneyNum.text = periodsModel.rest_price
                payMoneyNum.text = periodsModel.pay_price
                statusBtn.setTitle("详情", for: UIControlState.normal)
                originMoney.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(stage)
                    make.top.equalTo(time.snp.bottom).offset(15)
                }
                moneyChange.isHidden = false
                backMoney.isHidden = false
                backMoneyNum.isHidden = false
                payMoney.isHidden = false
                payMoneyNum.isHidden = false
                payButton.isHidden = false
            } else if periodsModel.mod_tag == "0" {
                originMoney.text = "实际报酬："
                originMoney.snp.remakeConstraints { (make) in
                    make.left.right.equalTo(stage)
                    make.top.equalTo(time.snp.bottom).offset(15)
                    make.bottom.equalTo(contentView).offset(-15)
                }
                statusBtn.setTitle("已放款", for: UIControlState.normal)
                statusBtn.isUserInteractionEnabled = false
                statusBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
            }
            
        default :
            break
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        statusBtn.addTarget(self, action: #selector(statusBtnClick(_:)), for: UIControlEvents.touchUpInside)
        payButton.setTitle("已放款", for: UIControlState.normal)
        payButton.isUserInteractionEnabled = false
        payButton.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
        payButton.isHidden = true
//        moneyChange.layer.borderColor = UIColor.colorWithHexStringSwift("e60000").cgColor
//        moneyChange.layer.borderWidth = 1
        configView()
        configLayout() 
    }
    
    @objc func statusBtnClick(_ sender: UIButton) {
        btnCallBack?()
    }
    
    func configView() {
        contentView.addSubview(stage)
        contentView.addSubview(stageNum)
        contentView.addSubview(time)
        contentView.addSubview(timeNum)
        contentView.addSubview(originMoney)
        contentView.addSubview(originMoneyNum)
        contentView.addSubview(backMoney)
        contentView.addSubview(backMoneyNum)
        contentView.addSubview(payMoney)
        contentView.addSubview(payMoneyNum)
        contentView.addSubview(moneyChange)
        contentView.addSubview(statusBtn)
        contentView.addSubview(payButton)
    }
    
    func configLayout() {
        stage.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(15)
        }
        stageNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(stage)
            make.left.equalTo(stage.snp.right)
        }
        time.snp.makeConstraints { (make) in
            make.left.right.equalTo(stage)
            make.top.equalTo(stage.snp.bottom).offset(15)
        }
        timeNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(time)
            make.left.equalTo(time.snp.right)
        }
        originMoney.snp.makeConstraints { (make) in
            make.left.right.equalTo(stage)
            make.top.equalTo(time.snp.bottom).offset(15)
        }
        originMoneyNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(originMoney)
            make.left.equalTo(originMoney.snp.right)
        }
        moneyChange.snp.makeConstraints { (make) in
            make.centerY.equalTo(originMoney)
            make.left.equalTo(originMoneyNum.snp.right).offset(20)
        }
        backMoney.snp.makeConstraints { (make) in
            make.left.right.equalTo(originMoney)
            make.top.equalTo(originMoney.snp.bottom).offset(15)
        }
        backMoneyNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(backMoney)
            make.left.equalTo(backMoney.snp.right)
        }
        payMoney.snp.makeConstraints { (make) in
            make.left.right.equalTo(backMoney)
            make.top.equalTo(backMoney.snp.bottom).offset(15)
            make.bottom.equalTo(contentView).offset(-15)
        }
        payMoneyNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(payMoney)
            make.left.equalTo(payMoney.snp.right)
        }
        statusBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(contentView).offset(-15)
            make.width.equalTo(75)
            make.height.equalTo(30)
        }
        payButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(statusBtn.snp.top).offset(-15)
            make.width.equalTo(75)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
