//
//  DDTradeResultCell.swift
//  Project
//
//  Created by WY on 2018/6/1.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDTradeResultCell: DDTableViewCell {
    let time = UILabel()
    let background = UIView()
    let title = UILabel()
    let money = UILabel()
    let bottomTitle = UILabel()
    let icon = UIImageView()
    var model : DDMessageContentModel?{
        didSet{
                self.setValueToUI()
                layoutIfNeeded()
                setNeedsLayout()
            
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(time)
        self.contentView.addSubview(background)
        self.background.addSubview(title)
        self.background.addSubview(money)
        self.contentView.addSubview(bottomTitle)
        self.contentView.addSubview(icon)
        time.textAlignment = .center
        time.textColor = UIColor.DDSubTitleColor
        title.textColor = UIColor.white
        money.textColor = UIColor.white
        bottomTitle.textColor = UIColor.DDSubTitleColor
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("E9EEF3")
        bottomTitle.backgroundColor = UIColor.white
//        title.font = UIFont.systemFont(ofSize: 19)
        money.font = UIFont.boldSystemFont(ofSize: 22)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.model?.rowHeight = caculaterRowH()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueToUI()  {
        
        if let model = model {
            
            self.money.text = ("¥" + (model.content ?? "")) + "元"
            self.time.text = model.create_at
            self.bottomTitle.text = "   直接付款"
            if model.con_status == "2"{//payOutLogo
                icon.image = UIImage(named:"payOutLogo")
                title.text  = "向对方直接付款"
                self.background.backgroundColor = UIColor.DDThemeColor
            }else if model.con_status == "23"{
                icon.image = UIImage(named:"reciveMoneyLogo")
                title.text  = "收到直接付款"
                self.background.backgroundColor = UIColor.colorWithHexStringSwift("E7A445")
            }
        }
        caculaterRowH()
    }
    @discardableResult
    func caculaterRowH() -> CGFloat {
        
        let leftMargin : CGFloat = 72
        let rightMargin : CGFloat = 72
        let containerWidth : CGFloat = SCREENWIDTH - leftMargin - rightMargin
        let containerHeight : CGFloat = 72//
        let timeToTopMargin : CGFloat = 10//
        let timeH : CGFloat = 22//
        let containerToTimeMargin : CGFloat = 10//
        let bottomH : CGFloat = 34//
        let labelToContainerBorderMargin : CGFloat = 15
//        self.money.text = model?.content
//        self.time.text = model?.create_at
        self.time.frame = CGRect(x: 0, y: timeToTopMargin, width: SCREENWIDTH, height: timeH)
        
//        self.contentLabel.frame = CGRect(x: leftMargin * 2, y: self.time.frame.maxY + containerToTimeMargin + labelToContainerBorderMargin, width: textContentSize.width, height: textContentSize.height)
        
        self.background.frame = CGRect(x: leftMargin , y: self.time.frame.maxY  + containerToTimeMargin, width: containerWidth, height: containerHeight )
        title.frame = CGRect(x: labelToContainerBorderMargin, y: 5, width: background.bounds.width - labelToContainerBorderMargin, height: background.bounds.height * 0.4)
        money.frame = CGRect(x: labelToContainerBorderMargin, y: background.bounds.height * 0.4, width: background.bounds.width - labelToContainerBorderMargin, height:  background.bounds.height * 0.6)
        
        bottomTitle.frame = CGRect(x: self.background.frame.minX, y: self.background.frame.maxY, width: containerWidth, height: bottomH)
        let iconBorder : CGFloat = 7
        let iconWH = bottomTitle.frame.height - iconBorder * 2
        icon.frame = CGRect(x: self.background.frame.maxX -  iconBorder - iconWH, y: self.background.frame.maxY + iconBorder, width:iconWH , height: iconWH)
        return self.bottomTitle.frame.maxY
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
