//
//  DDPublicSearchTableView.swift
//  Project
//
//  Created by 金曼立 on 2018/4/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPublicSearchCell: DDTableViewCell {
    
    let introduce = UILabel()
    let requriet = UILabel()
    let requrietDetail = UILabel()
    let region = UILabel()
    let regionDetail = UILabel()
    let drawee = UILabel()
    let company = UILabel()
    var model: DDAppointShrotModel? = DDAppointShrotModel(){
        didSet{
            configData(text: model?.title ?? "", sender: introduce, color: UIColor.colorWithRGB(red: 51, green: 51, blue: 51))
            configData(text: "约定要求：", sender: requriet, color: UIColor.colorWithRGB(red: 51, green: 51, blue: 51))
            configData(text: model?.requirement ?? "", sender: requrietDetail, color: UIColor.colorWithRGB(red: 51, green: 51, blue: 51))
            configData(text: "工作区域：", sender: region, color: UIColor.colorWithRGB(red: 51, green: 51, blue: 51))
            configData(text: model?.range ?? "", sender: regionDetail, color: UIColor.colorWithRGB(red: 51, green: 51, blue: 51))
            configData(text: "付款人：", sender: drawee, color: UIColor.colorWithRGB(red: 51, green: 51, blue: 51))
            configData(text: model?.aName ?? "", sender: company, color: UIColor.colorWithRGB(red: 51, green: 51, blue: 51))
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
        contentView.addSubview(drawee)
        contentView.addSubview(company)
    }
    
    func configData(text: String, sender: UILabel, color: UIColor)  {
        sender.text = text
        sender.font = UIFont(name: "PingFang-SC-Regular", size: 14)
        sender.textColor = color
    }
    
    func _layoutsubviews()  {
        
        let margin = 15
        let minMargin = 10
        
        introduce.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(margin)
            make.left.equalTo(contentView).offset(margin)
            make.right.equalTo(contentView).offset(-margin)
            make.bottom.equalTo(requriet.snp.top).offset(-minMargin)
        }
        requriet.snp.makeConstraints { (make) in
            make.top.equalTo(introduce.snp.bottom).offset(minMargin)
            make.left.equalTo(introduce)
            make.width.equalTo(80)
            make.bottom.equalTo(region.snp.top).offset(-minMargin)
        }
        requrietDetail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(requriet)
            make.left.equalTo(requriet.snp.right).offset(minMargin)
            make.right.equalTo(introduce)
        }
        region.snp.makeConstraints { (make) in
            make.top.equalTo(requriet.snp.bottom).offset(minMargin)
            make.left.equalTo(introduce)
            make.right.equalTo(requriet)
            make.bottom.equalTo(drawee.snp.top).offset(-minMargin)
        }
        regionDetail.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(region)
            make.left.equalTo(requrietDetail)
            make.right.equalTo(introduce)
        }
        drawee.snp.makeConstraints { (make) in
            make.top.equalTo(region.snp.bottom).offset(minMargin)
            make.left.equalTo(introduce)
            make.right.equalTo(requriet)
            make.bottom.equalTo(contentView.snp.bottom).offset(-margin)
        }
        company.snp.makeConstraints { (make) in
            make.top.equalTo(drawee)
            make.left.equalTo(requrietDetail)
            make.right.equalTo(introduce)
            make.bottom.equalTo(contentView.snp.bottom).offset(-margin)
        }
    }
}

