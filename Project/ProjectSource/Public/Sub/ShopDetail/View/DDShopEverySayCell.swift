//
//  DDShopEverySayCell.swift
//  Project
//
//  Created by WY on 2017/12/20.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDShopEverySayCell: DDTableViewCell {
    var models  = [DDShopBindingModel](){
        didSet{
            
            if self.contentView.subviews.count == models.count && models.count != 0 {
                for (index ,model) in models.enumerated(){
                    if let label  = self.contentView.subviews[index] as? UILabel{
                        label.text = model.value
                        label.ddSizeToFit()
                    }
                }
            }else{
                self.contentView.subviews.forEach { (subview ) in
                    subview.removeFromSuperview()
                }
                for model in models{
                    let label  = UILabel.init()
                    label.text = model.value
                    label.ddSizeToFit()
                    label.backgroundColor  = UIColor.colorWithHexStringSwift("#fff5f5")
                    label.textColor = UIColor.colorWithHexStringSwift("#aaaaaa")
                    label.textAlignment = NSTextAlignment.center
                    self.contentView.addSubview(label)
                }
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let leftRightPaddingMargin : CGFloat = 10
        let verticalMargin  :CGFloat = 10
        let labelMargin : CGFloat = 10
        let toTopMargin : CGFloat = 10
        var maxX : CGFloat = leftRightPaddingMargin
        var maxY : CGFloat = verticalMargin + toTopMargin
        var leftWidth : CGFloat = self.bounds.width - leftRightPaddingMargin * 2
        for label in self.contentView.subviews {
            label.ddSizeToFit(contentInset: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
            if leftWidth < label.bounds.width{
                maxX = leftRightPaddingMargin
                maxY += (label.bounds.height + verticalMargin)
                leftWidth = self.bounds.width - leftRightPaddingMargin * 2
                let labelH = label.bounds.height + 5
                var labelW = label.bounds.width
                if labelW >= leftWidth{labelW = leftWidth }
                mylog(self.bounds.width)
                mylog(leftRightPaddingMargin * 2 )
                mylog(leftWidth)
                mylog(self.bounds.width - leftRightPaddingMargin * 2)
                mylog(labelW)
                label.bounds = CGRect(x: 0, y: 0, width: labelW, height: labelH)
            }
            label.layer.cornerRadius = label.bounds.height/2
            label.layer.masksToBounds = true
            label.center = CGPoint(x: maxX + label.bounds.width/2, y: maxY)
            maxX += (labelMargin + label.bounds.width)
            leftWidth = (self.bounds.width - leftRightPaddingMargin) - maxX
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func caculateHeight(models:[DDShopBindingModel]) -> CGFloat{
        let leftRightPaddingMargin : CGFloat = 10
        let verticalMargin  :CGFloat = 10
        let labelMargin : CGFloat = 10
        let toTopMargin : CGFloat = 10
        var maxX : CGFloat = leftRightPaddingMargin
        var maxY : CGFloat = verticalMargin + toTopMargin
        var leftWidth : CGFloat = SCREENWIDTH - leftRightPaddingMargin * 2
        let label = UILabel()
        for (index,model) in models.enumerated(){
            label.text = model.value
            label.ddSizeToFit(contentInset: UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7))
            if leftWidth < label.bounds.width{
                maxX = leftRightPaddingMargin
                maxY += (label.bounds.height + verticalMargin)
                leftWidth = SCREENWIDTH - leftRightPaddingMargin * 2
                let labelH = label.bounds.height
                var labelW = label.bounds.width
                if labelW >= leftWidth{labelW = leftWidth }
                label.bounds = CGRect(x: 0, y: 0, width: labelW, height: labelH)
            }
            label.center = CGPoint(x: maxX + label.bounds.width/2, y: maxY)
            maxX += (labelMargin + label.bounds.width)
            leftWidth = (SCREENWIDTH - leftRightPaddingMargin) - maxX
            if index == models.count - 1{
                maxY += (label.bounds.height/2 + toTopMargin)
            }
        }
        return maxY
    }

}
