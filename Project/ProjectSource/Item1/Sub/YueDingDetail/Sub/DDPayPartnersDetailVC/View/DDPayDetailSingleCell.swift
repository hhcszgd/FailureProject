//
//  DDPayDetailSingleCell.swift
//  Project
//
//  Created by 金曼立 on 2018/5/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPayDetailSingleCell: DDTableViewCell {
    
    var btnCallBack:(() -> ())?
    
    let stage = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "放款期数：")
    let stageNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let time = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "放款时间：")
    let timeNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let originMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "实际报酬：")
    let originMoneyNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let backMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "退款报酬：")
    let backMoneyNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let payMoney = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "实际报酬：")
    let payMoneyNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "")
    let isEarnerBtn = UIButton()
    
    var payDetailModel : DDPayDetailInfoModel? = DDPayDetailInfoModel() {
        didSet{
            timeNum.text = payDetailModel?.grant_time
            originMoneyNum.text = payDetailModel?.payment_prive
            backMoneyNum.text = payDetailModel?.rest_price
            payMoneyNum.text = payDetailModel?.payment_prive
            payMoney.isHidden = true
            payMoneyNum.isHidden = true
            backMoney.isHidden = true
            backMoneyNum.isHidden = true
            originMoney.snp.remakeConstraints { (make) in
                make.left.right.equalTo(time)
                make.top.equalTo(time.snp.bottom).offset(15)
                make.bottom.equalTo(contentView).offset(-15)
            }
            
            // 0 正常 1 待发放  2 纠纷   3 终止  4 纠纷完成  5 终止完成  6 已发放
            switch payDetailModel?.status {
            case "0"?:
                isEarnerBtn.setTitle("未放款", for: UIControlState.normal)
            case "1"?:
                isEarnerBtn.setTitle("未放款", for: UIControlState.normal)
            case "2"?:
                isEarnerBtn.setTitle("未放款", for: UIControlState.normal)
            case "3"?:
                isEarnerBtn.setTitle("未放款", for: UIControlState.normal)
            case "4"?:
                isEarnerBtn.setTitle("未放款", for: UIControlState.normal)
                originMoney.text = "原定报酬"
                originMoneyNum.text = payDetailModel?.price
                updateLayout()
            case "5"?:
                isEarnerBtn.setTitle("终止约定", for: UIControlState.normal)
            case "6"?:
                isEarnerBtn.setTitle("已放款", for: UIControlState.normal)
            default:
                break
            }
        }
    }
    
    var stageStr : String? {
        didSet{
            stageNum.text = (payDetailModel?.num ?? "") + "/" + (stageStr ?? "")
            if stageNum.text == "1/1" {
                stage.isHidden = true
                stageNum.isHidden = true
                time.snp.remakeConstraints { (make) in
                    make.top.left.equalToSuperview().offset(15)
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isEarnerBtn.backgroundColor = UIColor.colorWithRGB(red: 179, green: 179, blue: 179)
        isEarnerBtn.isUserInteractionEnabled = false
        isEarnerBtn.setTitle("已放款", for: UIControlState.normal)
        isEarnerBtn.addTarget(self, action: #selector(isEarnerBtnClick(_:)), for: UIControlEvents.touchUpInside)
        configView()
    }
    
    @objc func isEarnerBtnClick(_ sender: UIButton) {
        btnCallBack?()
    }
    
    func updateLayout() {
        payMoney.isHidden = false
        payMoneyNum.isHidden = false
        backMoney.isHidden = false
        backMoneyNum.isHidden = false
        originMoney.snp.remakeConstraints { (make) in
            make.left.right.equalTo(time)
            make.top.equalTo(time.snp.bottom).offset(15)
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        stage.frame = CGRect(x: 15, y: 15, width: 100, height: 20)
//        time.frame = CGRect(x: stage.frame.minX, y: stage.frame.maxY + 15, width: stage.width, height: stage.height)
//        originMoney.frame = CGRect(x: stage.frame.minX, y: time.frame.maxY + 15, width: stage.width, height: stage.height)
//        backMoney.frame = CGRect(x: stage.frame.minX, y: originMoney.frame.maxY + 15, width: stage.width, height: stage.height)
//        payMoney.frame = CGRect(x: stage.frame.minX, y: backMoney.frame.maxY + 15, width: stage.width, height: stage.height)
//        stageNum.frame = CGRect(x: stage.frame.maxX, y: stage.frame.minY, width: SCREENWIDTH - stage.width - 30, height: stage.height)
//        timeNum.frame = CGRect(x: time.frame.maxX, y: time.frame.minY, width: stageNum.width, height: stage.height)
//        originMoneyNum.frame = CGRect(x: originMoney.frame.maxX, y: originMoney.frame.minY, width: stageNum.width, height: stage.height)
//        backMoneyNum.frame = CGRect(x: backMoney.frame.maxX, y: backMoney.frame.minY, width: stageNum.width, height: stage.height)
//        payMoneyNum.frame = CGRect(x: payMoney.frame.maxX, y: payMoney.frame.minY, width: stageNum.width, height: stage.height)
//        isEarnerBtn.frame = CGRect(x: self.frame.width - 15 - 75, y: self.frame.height - 15 - 30, width: 75, height: 30)
//    }
    
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
        contentView.addSubview(isEarnerBtn)

        stage.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
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
            make.left.right.equalTo(time)
            make.top.equalTo(time.snp.bottom).offset(15)
            make.bottom.equalTo(contentView).offset(-15)
        }
        originMoneyNum.snp.makeConstraints { (make) in
            make.centerY.equalTo(originMoney)
            make.left.equalTo(originMoney.snp.right)
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
        isEarnerBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(contentView).offset(-15)
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
