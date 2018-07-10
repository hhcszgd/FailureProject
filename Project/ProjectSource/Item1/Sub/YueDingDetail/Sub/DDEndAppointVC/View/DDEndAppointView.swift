//
//  DDEndAppointView.swift
//  Project
//
//  Created by 金曼立 on 2018/4/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDEndAppointView: UIView {
    
    let scrollView = UIScrollView()
    let proceed = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.DDThemeColor, text: "进行中")
    let appointBg = UIView()
    let appoint = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: color11, text: "约定名称")
    let appointName = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "约定名称")
    let endBg = UIView()
    let endAppoint = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: color11, text: "终止约定")
    let attention = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "注：索要报酬数目不得大于本约定中约定报酬。")
    let originMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "原定报酬(元):")
    let originNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
//    let originYuan = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "元")
    let payMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "实际报酬(元):")
    let payNum = UITextField()
//    let payYuan = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "元")
    let backMonay = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "退回报酬(元):")
    let backNum = UITextField()
//    let backYuan = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "元")
    let stop = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: color11, text: "终止原因")
    let placeHolder = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "请简要叙述终止约定的原因")
    let stopDeti = UITextView()
    let wordNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithHexStringSwift("999999"), text: "0/200")
    let submitBtn = UIButton()
    
    var originNumber : String? {
        didSet{
            let origin = NSString(string: originNumber ?? "").floatValue
            originNum.text = String(format: "%.2f", origin)
            payNum.text = String(format: "%.2f", origin)
            backNum.text = "0.00"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)        
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.contentSize = CGSize(width: SCREENWIDTH, height: SCREENHEIGHT + 200)
        self.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        payNum.keyboardType = UIKeyboardType.decimalPad
        backNum.keyboardType = UIKeyboardType.decimalPad

        addSubViews()
        configView()
    }
    
    func addSubViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(proceed)
        scrollView.addSubview(appointBg)
        appointBg.addSubview(appoint)
        appointBg.addSubview(appointName)
        scrollView.addSubview(endBg)
        endBg.addSubview(endAppoint)
        endBg.addSubview(attention)
        endBg.addSubview(originMonay)
        endBg.addSubview(originNum)
//        endBg.addSubview(originYuan)
        endBg.addSubview(payMonay)
        endBg.addSubview(payNum)
//        endBg.addSubview(payYuan)
        endBg.addSubview(backMonay)
        endBg.addSubview(backNum)
//        endBg.addSubview(backYuan)
        endBg.addSubview(stop)
        endBg.addSubview(stopDeti)
        endBg.addSubview(placeHolder)
        endBg.addSubview(wordNum)
        scrollView.addSubview(submitBtn)
    }
    
    func configView() {
        appointBg.backgroundColor = UIColor.white
        endBg.backgroundColor = UIColor.white
        stopDeti.backgroundColor = UIColor.colorWithHexStringSwift("f5f5f5")
        payNum.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        backNum.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        payNum.textColor = UIColor.colorWithHexStringSwift("1a1a1a")
        payNum.font = UIFont.systemFont(ofSize: 14)
        payNum.borderStyle = UITextBorderStyle.roundedRect
        backNum.textColor = UIColor.colorWithHexStringSwift("1a1a1a")
        backNum.font = UIFont.systemFont(ofSize: 14)
        backNum.borderStyle = UITextBorderStyle.roundedRect
//        originNum.textAlignment = NSTextAlignment.right
//        payNum.textAlignment = NSTextAlignment.right
//        backNum.textAlignment = NSTextAlignment.right
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.backgroundColor = UIColor.DDThemeColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        proceed.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
        }
        appointBg.snp.makeConstraints { (make) in
            make.top.equalTo(proceed.snp.bottom).offset(15)
            make.left.equalTo(proceed)
            make.right.equalTo(self).offset(-15)
            make.height.equalTo(40)
        }
        appoint.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
        appointName.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(appoint.snp.right)
            make.right.equalToSuperview()
        }
        endBg.snp.makeConstraints { (make) in
            make.top.equalTo(appointBg.snp.bottom).offset(1)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(stopDeti).offset(15)
        }
        endAppoint.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.right.equalTo(appoint)
        }
        attention.snp.makeConstraints { (make) in
            make.left.equalTo(endAppoint).offset(10)
            make.top.equalTo(endAppoint.snp.bottom).offset(15)
        }
        originMonay.snp.makeConstraints { (make) in
            make.left.equalTo(attention)
            make.top.equalTo(attention.snp.bottom).offset(15)
        }
        payMonay.snp.makeConstraints { (make) in
            make.left.equalTo(originMonay)
            make.top.equalTo(originMonay.snp.bottom).offset(15)
        }
        backMonay.snp.makeConstraints { (make) in
            make.left.equalTo(payMonay)
            make.top.equalTo(payMonay.snp.bottom).offset(15)
        }
        originNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(originMonay)
            make.left.equalTo(originMonay.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
        }
//        originYuan.snp.makeConstraints { (make) in
//            make.centerY.equalTo(originMonay)
//            make.left.equalTo(originNum.snp.right).offset(1)
//            make.right.equalToSuperview().offset(-15)
//        }
        payNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(payMonay)
            make.left.equalTo(payMonay.snp.right).offset(10)
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-15)
//            make.centerY.equalTo(payMonay)
//            make.left.right.equalTo(originNum)
//            make.height.equalTo(20)
//            make.width.equalTo(100)
        }
//        payYuan.snp.makeConstraints { (make) in
//            make.centerY.equalTo(payMonay)
//            make.left.right.equalTo(originYuan)
//        }
        backNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(backMonay)
            make.left.equalTo(backMonay.snp.right).offset(10)
            make.height.right.equalTo(payNum)
//            make.centerY.equalTo(backMonay)
//            make.left.right.equalTo(originNum)
//            make.width.height.equalTo(payNum)
        }
//        backYuan.snp.makeConstraints { (make) in
//            make.centerY.equalTo(backMonay)
//            make.left.right.equalTo(originYuan)
//        }
        stop.snp.makeConstraints { (make) in
            make.top.equalTo(backMonay.snp.bottom).offset(15)
            make.left.equalTo(endAppoint)
        }
        stopDeti.snp.makeConstraints { (make) in
            make.top.equalTo(stop.snp.bottom).offset(10)
            make.left.equalTo(stop)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(153)
        }
        placeHolder.snp.makeConstraints { (make) in
            make.left.top.equalTo(stopDeti).offset(5)
        }
        wordNum.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(stopDeti).offset(-5)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(endBg.snp.bottom).offset(40)
            make.right.left.equalTo(endBg)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
