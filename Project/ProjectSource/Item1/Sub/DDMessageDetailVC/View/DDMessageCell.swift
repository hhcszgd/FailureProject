
//
//  DDMessageCell.swift
//  Project
//
//  Created by WY on 2018/4/24.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDMessageCell: DDTableViewCell {
    let contentContainer = UIView()
    let contentLabel = UILabel()
    let time = UILabel()
    var model : DDMessageContentModel?{
        didSet{
            self.setValueToUI()
            layoutIfNeeded()
            setNeedsLayout()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = .clear
//        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(time)
        self.contentView.addSubview(contentContainer)
        self.contentView.addSubview(contentLabel)
        contentLabel.numberOfLines = 0
        time.textAlignment = .center
        time.textColor = UIColor.DDSubTitleColor
        contentLabel.textColor = UIColor.colorWithHexStringSwift("#ce7160")
        contentContainer.backgroundColor = UIColor.colorWithHexStringSwift("#ffd8c3")
        self.contentView.backgroundColor = UIColor.colorWithHexStringSwift("E9EEF3")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.model?.rowHeight = caculaterRowH()
    }
    
    @discardableResult
    func caculaterRowH() -> CGFloat {
        
        let leftMargin : CGFloat = 20
        let rightMargin : CGFloat = 20
        let containerMaxWidth : CGFloat = SCREENWIDTH - leftMargin - rightMargin
        let contentMaxWidth : CGFloat = containerMaxWidth - leftMargin * 2
        let timeToTopMargin : CGFloat = 10
        let containerToTimeMargin : CGFloat = 10
        let labelToContainerBorderMargin : CGFloat = 10
        let timeH :CGFloat = 22
        let textContentSize = (model?.content ?? "").sizeWith(font: self.contentLabel.font, maxWidth: contentMaxWidth)
        self.contentLabel.text = model?.content
        self.time.text = model?.create_at
        self.time.frame = CGRect(x: 0, y: timeToTopMargin, width: SCREENWIDTH, height: timeH)
        
        self.contentLabel.frame = CGRect(x: leftMargin * 2, y: self.time.frame.maxY + containerToTimeMargin + labelToContainerBorderMargin, width: textContentSize.width, height: textContentSize.height)
        
        self.contentContainer.frame = CGRect(x: leftMargin , y: self.time.frame.maxY  + containerToTimeMargin, width: containerMaxWidth, height: textContentSize.height + labelToContainerBorderMargin * 2)
        self.contentContainer.layer.cornerRadius = 8
        self.contentContainer.layer.masksToBounds = true
        
        return self.contentContainer.frame.maxY
    }
    
    func setValueToUI()  {
//        let leftMargin : CGFloat = 20
//        let rightMargin : CGFloat = 20
//        let containerMaxWidth : CGFloat = self.bounds.width - leftMargin - rightMargin
//        let contentMaxWidth : CGFloat = containerMaxWidth - leftMargin * 2
//        if model?.content == nil {
//            model?.content = "asldkjf;alsjefoiawejf;olijsldkjf;laskjdfiej;asjdf;lkasjd;flkjasdlfkja;ljflaksjdflkj"
//        }
//        let textContentSize = (model?.content ?? "").sizeWith(font: self.contentLabel.font, maxWidth: contentMaxWidth)
        self.contentLabel.text = model?.content
        self.time.text = model?.create_at
        caculaterRowH()
//        self.time.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 22)
//
//        self.contentLabel.frame = CGRect(x: leftMargin * 2, y: self.time.frame.maxY + 10, width: textContentSize.width, height: textContentSize.height)
//        self.contentContainer.frame = CGRect(x: leftMargin , y: self.time.frame.maxY  + 10, width: containerMaxWidth, height: textContentSize.height + 30)
//        self.contentContainer.layer.cornerRadius = 8
//        self.contentContainer.layer.masksToBounds = true
    }

}
