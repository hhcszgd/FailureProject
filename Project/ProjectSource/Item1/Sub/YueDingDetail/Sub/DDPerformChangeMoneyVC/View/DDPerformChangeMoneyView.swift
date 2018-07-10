//
//  DDPerformChangeMoneyView.swift
//  Project
//
//  Created by 金曼立 on 2018/5/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
class DDPerformChangeMoneyView: UIView {
    
    let tableHeaderV = UIView()
    let appointBg = UIView()
    let attentionBg = UIView()
    let attentionLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("ffffff"), text: "修改提示：建议在修改报酬前先与对方联系，双方协商一致后再填写报酬，双方若无法达成一致，则均无法得到原定报酬，可能会造成财产损失。")
    let appointName = UILabel.configlabel(font: UIFont.systemFont(ofSize: 16), textColor: UIColor.colorWithHexStringSwift("1a1a1a"), text: "约定名称")
//    let money = UILabel.configlabel(font: UIFont.systemFont(ofSize: 20), textColor: color11, text: "元")
//    let iconBgView = UIView()
//    let icon = UIImageView()
//    let name = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: color11, text: "姓名：")
    let tableView = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    var changeModel : DDMoneyChangeModel? = DDMoneyChangeModel() {
        didSet{
            appointName.text = changeModel?.full_name ?? ""
//            money.attributedText = self.attributedString(number: changeModel?.order_total ?? "", string: "")
//            if let url  = URL(string:changeModel?.head_images ?? "") {
//                icon.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
//            }else{
//                icon.image = DDPlaceholderImage
//            }
//            var nikeName : String = "姓名："
//            if let nameTxt = changeModel?.nickname {
//                nikeName = nikeName + nameTxt
//            }
//            if let phoneNum = changeModel?.mobile {
//                nikeName = nikeName + "(" + phoneNum + ")"
//            }
//            name.text = nikeName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        self.tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableHeaderV.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")

        configView()
    }
    
    func attentionLabelScroll() {
        UIView.animate(withDuration: 20, delay: 0, options: UIViewAnimationOptions.repeat, animations: {
            self.attentionLab.frame = CGRect(x: -SCREENWIDTH * 3, y: 0, width: SCREENWIDTH * 3, height: 30)
        }) { (success) in
            self.attentionLab.frame = CGRect(x: SCREENWIDTH, y: 0, width: SCREENWIDTH * 3, height: 30)
        }
    }

    func configView() {
        tableView.tableHeaderView = tableHeaderV
        tableHeaderV.addSubview(attentionBg)
        attentionBg.addSubview(attentionLab)
        tableHeaderV.addSubview(appointBg)
        appointBg.addSubview(appointName)
//        appointBg.addSubview(money)
//        tableHeaderV.addSubview(iconBgView)
//        iconBgView.addSubview(icon)
//        iconBgView.addSubview(name)
        self.addSubview(tableView)
        
        attentionBg.backgroundColor = UIColor.colorWithHexStringSwift("fc5d5d")
        attentionLab.backgroundColor = UIColor.clear
        appointBg.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
//        iconBgView.backgroundColor = UIColor.white
        appointName.textAlignment = NSTextAlignment.center
//        money.textAlignment = NSTextAlignment.center
//        name.textAlignment = NSTextAlignment.center
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableHeaderV.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(SCREENWIDTH)
            make.bottom.equalTo(appointBg.snp.bottom)
//            make.bottom.equalTo(iconBgView.snp.bottom)
        }
        attentionBg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        self.attentionLab.frame = CGRect(x: SCREENWIDTH, y: 0, width: SCREENWIDTH * 3, height: 30)
        appointBg.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.right.equalToSuperview()
//            make.bottom.equalTo(money).offset(15)
            make.bottom.equalTo(appointName).offset(15)
        }
        appointName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
//        money.snp.makeConstraints { (make) in
//            make.top.equalTo(appointName.snp.bottom).offset(14)
//            make.left.equalToSuperview().offset(15)
//            make.right.equalToSuperview().offset(-15)
//            make.bottom.equalToSuperview().offset(-15)
//        }
//        iconBgView.snp.makeConstraints { (make) in
//            make.top.equalTo(appointBg.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(name).offset(15)
//        }
//        icon.snp.makeConstraints { (make) in
//            make.width.height.equalTo(75)
//            make.top.equalToSuperview().offset(15)
//            make.centerX.equalToSuperview()
//        }
//        name.snp.makeConstraints { (make) in
//            make.top.equalTo(icon.snp.bottom).offset(10)
//            make.right.equalToSuperview().offset(-15)
//            make.left.equalToSuperview().offset(15)
//            make.bottom.equalToSuperview().offset(-15)
//        }
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func attributedString(number: String, string: String) -> NSMutableAttributedString {
        let peopleStr : NSMutableAttributedString = NSMutableAttributedString()
        let peopleStr1 = self.appendColorStrWithString(str: "\(number)", font: 20, color: UIColor.colorWithHexStringSwift("e60000"))
        let peopleStr2 = self.appendColorStrWithString(str: string, font: 15, color: color11)
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
}
