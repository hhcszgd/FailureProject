//
//  DDPublicCell.swift
//  Project
//
//  Created by JinManli on 2018/4/8.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPublicCell: DDTableViewCell {
    
    let introduce = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    let requriet = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "约定要求：")
    let requrietDetail = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    let region = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "工作区域：")
    let regionDetail = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    let money = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "报酬：")
    let number = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithRGB(red: 225, green: 29, blue:29), text: "")
    let drawee = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "付款人：")
    let company = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    var model: DDPublicAppointModel? = DDPublicAppointModel(){
        didSet{
            introduce.text = model?.title ?? ""
            requrietDetail.text = model?.requirement ?? ""
            regionDetail.text = model?.range ?? ""
            number.text = "￥" + (model?.price ?? "")
            company.text = model?.aname ?? ""
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        introduce.numberOfLines = 0
        addsubviews()
        _layoutsubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addsubviews()  {
        contentView.addSubview(introduce)
        contentView.addSubview(requriet)
        contentView.addSubview(requrietDetail)
        contentView.addSubview(region)
        contentView.addSubview(regionDetail)
        contentView.addSubview(money)
        contentView.addSubview(number)
        contentView.addSubview(drawee)
        contentView.addSubview(company)
    }

    func configData(text: String?, sender: UILabel, color: UIColor)  {
        sender.text = text
        sender.font = UIFont(name: "PingFang-SC-Regular", size: 14)
        sender.textColor = color
    }
    
    func _layoutsubviews()  {
        let margin = 0
        introduce.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        requriet.snp.makeConstraints { (make) in
            make.top.equalTo(introduce.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(80)
        }
        requrietDetail.snp.makeConstraints { (make) in
            make.top.equalTo(requriet)
            make.left.equalTo(requriet.snp.right).offset(margin)
            make.right.equalToSuperview().offset(-15)
        }
        region.snp.makeConstraints { (make) in
            make.top.equalTo(requriet.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
        }
        regionDetail.snp.makeConstraints { (make) in
            make.top.equalTo(region)
            make.left.equalTo(requriet.snp.right).offset(margin)
            make.right.equalToSuperview().offset(-15)
        }
        money.snp.makeConstraints { (make) in
            make.top.equalTo(region.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
        }
        number.snp.makeConstraints { (make) in
            make.top.equalTo(money)
            make.left.equalTo(requriet.snp.right).offset(margin)
            make.right.equalToSuperview().offset(-15)
        }
        drawee.snp.makeConstraints { (make) in
            make.top.equalTo(money.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(contentView).offset(-15)
        }
        company.snp.makeConstraints { (make) in
            make.top.equalTo(drawee)
            make.left.equalTo(requriet.snp.right).offset(margin)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(drawee)
        }
    }
}
