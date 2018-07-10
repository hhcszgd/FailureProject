//
//  DDMoneyChangeDetailView.swift
//  Project
//
//  Created by 金曼立 on 2018/4/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDMoneyChangeDetailView: UIView {
    
    var leftBtnCallBack:((_ tag: String) -> ())?
    var rightBtnCallBack:((_ tag: String) -> ())?
    
    let scrollView = UIScrollView()
    let attentionLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "修改提示：建议在修改报酬前先与对方联系，双方协商一致后再填写报酬，双方若无法达成一致，则均无法得到原定报酬，可能会造成财产损失。")
    let moneyBg = UIView()
    let change = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "对方修改此次放款报酬：")
    let originMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "原定报酬(元):")
    let originNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
    let payMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "实际报酬(元):")
    let payNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
    let backMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "退回报酬(元):")
    let backNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "0")
    
    let refuseBg = UIView()
    let refuse = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: color11, text: "拒绝修改后报酬：")
    let refuseAtten = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "注：索要报酬数目不得大于本约定中约定报酬。")
    let refuseOriginMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "原定报酬(元):")
    let refuseOriginNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
    let refusePayMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "实际报酬(元):")
    let refusePayNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
    let refuseBackMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "退回报酬(元):")
    let refuseBackNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
    let stopAppoint = UIButton()
    let earner = UIButton()
    
    let payNumText = UITextField()
    let backNumText = UITextField()
    
    var detailModel : DDChangeDetailModel? = DDChangeDetailModel() {
        didSet{
            if detailModel?.tag ?? "" == "1" || detailModel?.tag ?? "" == "7" || detailModel?.tag ?? "" == "3" || detailModel?.tag ?? "" == "6" {
                
                originNum.text = detailModel?.info?.price ?? ""
                payNum.text = detailModel?.info?.pay_price ?? ""
                backNum.text = detailModel?.info?.rest_price ?? ""

                switch detailModel?.tag ?? "" {
                case "1":
                    // 甲方查看自己修改约定后的详情
                    change.text = "己方修改此次放款报酬："
                case "7":
                    // 甲方查看乙方同意修改后的详情
                    change.text = "己方修改此次放款报酬："
                    refuse.text = "对方已接受"
                    stopAppoint.isHidden = false
                    refuseBg.isHidden = false
                    refuseAtten.isHidden = true
                    refuseOriginMonay.isHidden = true
                    refuseOriginNum.isHidden = true
                    refusePayMonay.isHidden = true
                    payNumText.isHidden = true
                    refuseBackMonay.isHidden = true
                    backNumText.isHidden = true
                    stopAppoint.snp.remakeConstraints { (make) in
                        make.left.equalTo(moneyBg)
                        make.bottom.equalToSuperview()
                        make.height.equalTo(30)
                        make.width.equalTo(SCREENWIDTH - 30)
                    }
                    refuseBg.snp.remakeConstraints { (make) in
                        make.top.equalTo(moneyBg.snp.bottom).offset(1)
                        make.left.equalTo(self.snp.left).offset(15)
                        make.right.equalTo(self.snp.right).offset(-15)
                        make.bottom.equalTo(refuse).offset(15)
                    }
                    refuse.snp.remakeConstraints { (make) in
                        make.left.top.equalToSuperview().offset(15)
                        make.bottom.equalToSuperview().offset(-15)
                    }
                case "3":
                    // 乙方查看自己修改约定后的详情
                    earner.isHidden = false
                    stopAppoint.isHidden = false
                    earner.setTitle("拒绝", for: UIControlState.normal)
                    stopAppoint.setTitle("同意", for: UIControlState.normal)
                case "6":
                    // 乙方查看自己同意甲方修改后的详情
                    break
                default :
                    break
                }
            } else if detailModel?.tag ?? "" == "2" || detailModel?.tag ?? "" == "5" {
                
                originNum.text = detailModel?.own?.price ?? ""
                payNum.text = detailModel?.own?.pay_price ?? ""
                backNum.text = detailModel?.own?.rest_price ?? ""
                refuseOriginNum.text = detailModel?.other?.price ?? ""
                refusePayNum.text = detailModel?.other?.pay_price ?? ""
                refuseBackNum.text = detailModel?.other?.rest_price ?? ""

                change.text = "己方修改此次报酬："
                refuseBg.isHidden = false
                payNumText.isHidden = true
                backNumText.isHidden = true
                
                switch detailModel?.tag ?? "" {
                case "2":
                    //  甲方查看乙方拒绝后的详情
                    earner.setTitle("同意", for: UIControlState.normal)
                    earner.isHidden = false
                    stopAppoint.isHidden = false
                case "5":
                    //  甲方查看乙方拒绝，自己同意后的详情
                    earner.isHidden = true
                    stopAppoint.isHidden = true
                    refuse.text = "拒绝修改后报酬："
                default :
                    break
                }
            } else if detailModel?.tag ?? "" == "4" || detailModel?.tag ?? "" == "8" {
                
                refuseBg.isHidden = false
                earner.isHidden = true
                stopAppoint.isHidden = true
                payNumText.isHidden = true
                backNumText.isHidden = true
                
                originNum.text = detailModel?.other?.price ?? ""
                payNum.text = detailModel?.other?.pay_price ?? ""
                backNum.text = detailModel?.other?.rest_price ?? ""
                refuseOriginNum.text = detailModel?.own?.price ?? ""
                refusePayNum.text = detailModel?.own?.pay_price ?? ""
                refuseBackNum.text = detailModel?.own?.rest_price ?? ""
                
                switch detailModel?.tag ?? "" {
                case "4":
                    // 乙方查看自己拒绝甲方修改后的详情
                    stopAppoint.isHidden = false
                    stopAppoint.snp.remakeConstraints { (make) in
                        make.left.equalTo(moneyBg)
                        make.bottom.equalToSuperview()
                        make.height.equalTo(30)
                        make.width.equalTo(SCREENWIDTH - 30)
                    }
                case "8":
                    // 乙方查看自己拒绝甲方修改，甲方同意后的详情
                    break
                default :
                    break
                }
            }
        }
    }
    
    func setOriginMoney() {
        refuseOriginNum.text = detailModel?.info?.price ?? ""
    }
    
    func earnerUpdateLayout() {
        refuseBg.isHidden = false
        refuse.text = "拒绝修改"
        earner.setTitle("提交", for: UIControlState.normal)
        refusePayNum.isHidden = true
        refuseBackNum.isHidden = true
        payNumText.isHidden = false
        backNumText.isHidden = false
        earner.isHidden = false
        stopAppoint.isHidden = true
        refuseBg.snp.remakeConstraints { (make) in
            make.top.equalTo(moneyBg.snp.bottom).offset(1)
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
            make.bottom.equalTo(backNumText).offset(15)
        }
        earner.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
        }
    }
    
    @objc func rightBtnClick() {
        rightBtnCallBack?(detailModel?.tag ?? "")
    }
    @objc func leftBtnClick() {
        leftBtnCallBack?(detailModel?.tag ?? "")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        scrollView.contentSize = CGSize(width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight)
        
        if DDDevice.type == .iPhone5 {
            scrollView.contentSize = CGSize(width: SCREENWIDTH, height: SCREENHEIGHT + 170)
        } else if DDDevice.type == .iPhone4 {
            scrollView.contentSize = CGSize(width: SCREENWIDTH, height: SCREENHEIGHT + 170)
        }
        refuseBg.isHidden = true
        earner.isHidden = true
        stopAppoint.isHidden = true
        
        addSubViews()
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleW = 100
        
        self.scrollView.frame = self.bounds
        attentionLab.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.width.equalTo(SCREENWIDTH - 30)
        }
        moneyBg.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(attentionLab.snp.bottom).offset(15)
            make.width.equalTo(SCREENWIDTH - 30)
            make.bottom.equalTo(backNum).offset(15)
        }
        change.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
        }
        originMonay.snp.makeConstraints { (make) in
            make.left.equalTo(change).offset(10)
            make.top.equalTo(change.snp.bottom).offset(15)
            make.width.equalTo(titleW)
        }
        payMonay.snp.makeConstraints { (make) in
            make.left.right.equalTo(originMonay)
            make.top.equalTo(originMonay.snp.bottom).offset(15)
        }
        backMonay.snp.makeConstraints { (make) in
            make.left.right.equalTo(payMonay)
            make.top.equalTo(payMonay.snp.bottom).offset(15)
        }
        originNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(originMonay)
            make.left.equalTo(originMonay.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        payNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(payMonay)
            make.left.equalTo(payMonay.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        backNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(backMonay)
            make.left.equalTo(backMonay.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        refuseBg.snp.makeConstraints { (make) in
            make.top.equalTo(moneyBg.snp.bottom).offset(1)
            make.left.equalTo(self.snp.left).offset(15)
            make.right.equalTo(self.snp.right).offset(-15)
            make.bottom.equalTo(refuseBackNum).offset(15)
        }
        refuse.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(13)
        }
        refuseAtten.snp.makeConstraints { (make) in
            make.left.equalTo(refuse).offset(10)
            make.top.equalTo(refuse.snp.bottom).offset(15)
        }
        refuseOriginMonay.snp.makeConstraints { (make) in
            make.left.right.equalTo(originMonay)
            make.top.equalTo(refuseAtten.snp.bottom).offset(15)
        }
        refusePayMonay.snp.makeConstraints { (make) in
            make.left.right.equalTo(refuseOriginMonay)
            make.top.equalTo(refuseOriginMonay.snp.bottom).offset(15)
        }
        refuseBackMonay.snp.makeConstraints { (make) in
            make.left.right.equalTo(refusePayMonay)
            make.top.equalTo(refusePayMonay.snp.bottom).offset(15)
        }
        refuseOriginNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(refuseOriginMonay)
            make.left.equalTo(refuseOriginMonay.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        refusePayNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(refusePayMonay)
            make.left.equalTo(refusePayMonay.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        refuseBackNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(refuseBackMonay)
            make.left.equalTo(refuseBackMonay.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        payNumText.snp.makeConstraints { (make) in
            make.centerY.equalTo(refusePayMonay)
            make.left.equalTo(refusePayMonay.snp.right).offset(10)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-15)
        }
        backNumText.snp.makeConstraints { (make) in
            make.centerY.equalTo(refuseBackMonay)
            make.left.equalTo(refuseBackMonay.snp.right).offset(10)
            make.height.right.equalTo(payNumText)
        }
        earner.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.right.equalTo(stopAppoint.snp.left).offset(-20)
            make.height.equalTo(30)
            make.width.equalTo(stopAppoint)
        }
        stopAppoint.snp.makeConstraints { (make) in
            make.right.equalTo(refuseBg)
            make.bottom.top.equalTo(earner)
            make.left.equalTo(earner.snp.right).offset(20)
            make.width.equalTo(earner)
        }
    }
    
    func addSubViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(attentionLab)
        scrollView.addSubview(moneyBg)
        moneyBg.addSubview(change)
        moneyBg.addSubview(originMonay)
        moneyBg.addSubview(originNum)
        moneyBg.addSubview(payMonay)
        moneyBg.addSubview(payNum)
        moneyBg.addSubview(backMonay)
        moneyBg.addSubview(backNum)
        scrollView.addSubview(refuseBg)
        refuseBg.addSubview(refuse)
        refuseBg.addSubview(refuseAtten)
        refuseBg.addSubview(refuseOriginMonay)
        refuseBg.addSubview(refuseOriginNum)
        refuseBg.addSubview(refusePayMonay)
        refuseBg.addSubview(refusePayNum)
        refuseBg.addSubview(refuseBackMonay)
        refuseBg.addSubview(refuseBackNum)
        refuseBg.addSubview(payNumText)
        refuseBg.addSubview(backNumText)
        self.addSubview(earner)
        self.addSubview(stopAppoint)
    }
    
    func configView() {
        moneyBg.backgroundColor = UIColor.white
        refuseBg.backgroundColor = UIColor.white
        attentionLab.numberOfLines = 0
        stopAppoint.setTitle("终止约定", for: UIControlState.normal)
        stopAppoint.addTarget(self, action: #selector(rightBtnClick), for: UIControlEvents.touchUpInside)
        stopAppoint.backgroundColor = UIColor.DDThemeColor
        earner.setTitle("同意", for: UIControlState.normal)
        earner.addTarget(self, action: #selector(leftBtnClick), for: UIControlEvents.touchUpInside)
        earner.backgroundColor = UIColor.DDThemeColor
        payNumText.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        backNumText.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        payNumText.textColor = UIColor.colorWithHexStringSwift("1a1a1a")
        payNumText.font = UIFont.systemFont(ofSize: 14)
        payNumText.borderStyle = UITextBorderStyle.roundedRect
        backNumText.textColor = UIColor.colorWithHexStringSwift("1a1a1a")
        backNumText.font = UIFont.systemFont(ofSize: 14)
        backNumText.borderStyle = UITextBorderStyle.roundedRect
    }
}
