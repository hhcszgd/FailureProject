//
//  ConsultCell.swift
//  Project
//
//  Created by wy on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ConsultCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        topLineView.backgroundColor = UIColor.colorWithHexStringSwift("e6e6e6")
        myImageView.image = UIImage.init(named: "sswaqae")
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.topLineView)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.configOrder)
        self.contentView.addSubview(self.configOrderValue)
        self.contentView.addSubview(self.appointmentName)
        self.contentView.addSubview(self.appointmentNameValue)
        self.contentView.addSubview(self.appointmentOrdre)
        self.contentView.addSubview(self.appointmentOrdreValue)
        self.contentView.addSubview(self.myImageView)
        self.contentView.addSubview(self.status)
        self.contentView.addSubview(self.checkDetail)
        self.topLineView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(10)
        }
        self.configOrder.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.topLineView.snp.bottom).offset(15)
            make.width.equalTo(80)
        }
        self.configOrderValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.configOrder.snp.right).offset(0)
                make.top.equalTo(self.configOrder.snp.top).offset(0)
            make.right.equalToSuperview().offset(-15)
            
        }
        self.appointmentOrdre.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.configOrder.snp.bottom).offset(10)
            make.width.equalTo(80)
        }
        self.appointmentOrdreValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.appointmentOrdre.snp.right)
            make.top.equalTo(self.appointmentOrdre.snp.top)
            make.right.equalToSuperview().offset(-15)
        }
        
        self.appointmentName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(self.appointmentOrdre.snp.bottom).offset(10)
            make.width.equalTo(80)
        }
        self.appointmentNameValue.snp.makeConstraints { (make) in
            make.left.equalTo(self.appointmentOrdre.snp.right)
            make.top.equalTo(self.appointmentName.snp.top)
            make.right.equalToSuperview().offset(-15)
        }
        self.lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appointmentName.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(1)
        }
        self.myImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.bottom.equalToSuperview().offset(-7)
        }
        self.status.sizeToFit()
        self.status.snp.makeConstraints { (make) in
            make.left.equalTo(self.myImageView.snp.right).offset(10)
            make.centerY.equalTo(self.myImageView.snp.centerY)
        }
        self.checkDetail.textAlignment = NSTextAlignment.center
        self.checkDetail.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(self.myImageView)
            make.width.equalTo(80)
            make.height.equalTo(25)
            
        }
        
        
        
    }
    ///0,处理中，1已同意。2，已拒绝.
    var model: ConsultModel? {
        didSet{
            self.configOrderValue.text = model?.id
            self.appointmentOrdreValue.text = model?.order_id
            self.appointmentNameValue.text = model?.full_name
            if model?.status == "0" {
                self.status.text = "处理中"
            }else {
                self.status.text = "已同意"
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 协商title
    let configOrder: UILabel = UILabel.configlabel(font: UIFont.boldSystemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("333333"), text: "协商编号:")
    ///协商编号
    let configOrderValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "")
    ///约定号
    let appointmentOrdre: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "约定号:")
    
    let appointmentOrdreValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "")

    let appointmentName: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "约定名称:")
    
    let appointmentNameValue: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("666666"), text: "")
    
    let status: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("6a96fc"), text: "")
    let checkDetail: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexStringSwift("6a96fc"), text: "查看详情")
    let lineView = UIView.init()
    let topLineView = UIView.init()
    let myImageView = UIImageView.init()
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
