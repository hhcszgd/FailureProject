//
//  TransactionCell.swift
//  Project
//
//  Created by wy on 2018/4/5.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.backView)
        self.backView.backgroundColor = UIColor.white
        self.backView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-1)
            make.top.equalToSuperview().offset(0)
        }
        self.contentView.addSubview(self.zTitleLabel)
        self.zTitleLabel.numberOfLines = 0
        self.zTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(self.backView.snp.left).offset(15)
            make.width.equalTo(self.backView.snp.width).multipliedBy(0.6)
            
        }
        self.contentView.addSubview(self.zSubtitleLabel)
        self.zSubtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.zTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(self.backView.snp.left).offset(15)
            make.width.equalTo(self.backView.snp.width).multipliedBy(0.6)
            make.bottom.equalToSuperview().offset(-1)
        }
        
        self.contentView.addSubview(self.zPriceLabel)
        self.zPriceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.backView.snp.right).offset(-11)
            make.width.equalTo(self.backView.snp.width).multipliedBy(0.3)
        }
        self.zPriceLabel.textAlignment = .right
        self.zDesc.textAlignment = .right
        self.contentView.addSubview(self.zDesc)
        self.zDesc.snp.makeConstraints { (make) in
            make.top.equalTo(self.zPriceLabel.snp.bottom).offset(2)
            make.right.equalTo(self.zPriceLabel.snp.right).offset(0)
            make.width.equalTo(self.zPriceLabel.snp.width)
        }
        
        
        
        
        
        
        
    }
    var model: TransactionModel? {
        didSet{
            self.zTitleLabel.text = model?.pay_note
            self.zSubtitleLabel.text = model?.create_at
            var price = ""
            if let str = model?.symbol {
                price += str
            }
            if let p = model?.price {
                price.append(String(p))
            }
            self.zPriceLabel.text = price
            if model?.status == "1" {
                self.zDesc.text = "交易成功"
            }
            if model?.status == "3" {
                self.zDesc.text = "交易失败"
            }
            if model?.status == "0" {
                self.zDesc.text = "未交易"
            }
        }
    }
    
    
    let zTitleLabel: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("333333"), text: "")
    let zSubtitleLabel: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("b3b3b3"), text: "")
    let zPriceLabel: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithHexStringSwift("e60000"), text: "")
    let zDesc: UILabel = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexStringSwift("97b1f5"), text: "")
    let blueColor: UIColor = UIColor.colorWithHexStringSwift("97b1f5")
    let redColor: UIColor = UIColor.colorWithHexStringSwift("e60000")
    let backView: UIView = UIView.init()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
