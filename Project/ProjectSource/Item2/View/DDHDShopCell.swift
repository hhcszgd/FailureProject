//
//  DDHDShopCell.swift
//  Project
//
//  Created by WY on 2017/12/22.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class DDHDShopCell: DDTableViewCell {
    let userIcon  = UIImageView()
    let discripLabel = UILabel()
    let createTime = UILabel()
    
    let shopImage  = UIImageView()
    let shopName  = UILabel()
    let distance = UILabel()
    let container1 = UIView()
    let container2 = UIView()
    let bottomLine = UIImageView()
    var model1  = DDRowMessageModel(){
        didSet{
            var type  = ""
            
            switch model1.data_type {
            case "4":
                type  = "关注了"
            case "10":
                type  = "发现了"
            case "15":
                type  = "入驻了"
            default:
                break
            }
            discripLabel.text = "用户\(model1.nickname) \(type):"
            shopName.text  = model1.shop_name
            distance.text = "\(model1.distance ?? 0)"
            createTime.text = "this is create time"
            if let url  = URL(string: model1.hand_image ?? "") {
                userIcon.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }
            //SDWebImageOptions
            if let url  = URL(string: model1.shop_logo_image ?? "") {
                shopImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }
            let labels = splitStr(str: model1.services ?? "", separator: ",")
            if labels.count == self.container2.subviews.count && self.container2.subviews.count != 0  {
                for (index , label ) in self.container2.subviews.enumerated(){
                    if let  label = label as? UILabel {
                        label.text = labels[index]
                    }
                }
            }else{
                container2.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
                for (index , text) in labels.enumerated(){
                    let label = UILabel()
                    label.text = text
                    label.textColor = UIColor.colorWithHexStringSwift("#e0e0e0")
                    label.textAlignment = NSTextAlignment.center
                    label.font = UIFont.systemFont(ofSize: 13)
                    container2.addSubview(label)
                }
            }
            let grade = [model1.shop_score,"\(String(describing: model1.average_consume))", model1.shop_classify_name]
            if grade.count == self.container1.subviews.count && self.container1.subviews.count != 0  {
                for (index , label ) in self.container1.subviews.enumerated(){
                    if let  label = label as? UILabel {
                        label.text = grade[index]
                    }
                }
            }else{
                container1.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
                for (index , text) in grade.enumerated(){
                    let label = UILabel()
                    label.font = UIFont.systemFont(ofSize: 13)
                    label.textColor = UIColor.white
                    label.textAlignment = NSTextAlignment.center
                    label.text = text
                    container1.addSubview(label)
                }
            }
        }
    }
    
    func splitStr(str:String , separator : Character) -> [String]  {
        let result  = str.split(separator: separator, omittingEmptySubsequences: true )
        return result.flatMap { (substring ) -> String? in
            return String(substring)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(userIcon)
        self.contentView.addSubview(discripLabel)
        discripLabel.textColor = UIColor.DDSubTitleColor
        self.contentView.addSubview(createTime)
        createTime.textColor = UIColor.DDSubTitleColor
        self.contentView.addSubview(shopImage)
        self.contentView.addSubview(shopName)
        shopName.textColor = UIColor.DDSubTitleColor
        self.contentView.addSubview(distance)
        distance.font = UIFont.systemFont(ofSize: 13)
        distance.textColor = UIColor.white
        distance.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(container1)
        self.contentView.addSubview(container2)
        self.contentView.addSubview(bottomLine)
//        self.backgroundColor = UIColor.randomColor()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        
        let userIconWH : CGFloat = 44
        let userIconToLeft  : CGFloat = 15
        let userIconToTop  : CGFloat = 10
        let userIconToRight  :CGFloat = 10
        let createTimeH : CGFloat = 36
        let bottomLineH : CGFloat = 10
        let shopLogoVirtalMargin : CGFloat = 10
        let labelsVircalMargin : CGFloat = 3
        userIcon.frame = CGRect(x: userIconToLeft, y: userIconToTop, width: userIconWH, height: userIconWH)
        userIcon.layer.cornerRadius = userIcon.bounds.width/2
        userIcon.layer.masksToBounds = true 
        discripLabel.frame = CGRect(x: userIcon.frame.maxX + userIconToRight, y: userIcon.frame.minY, width: self.bounds.width - userIcon.frame.maxX + userIconToRight, height: userIconWH * 0.3)
        
        let imageWH : CGFloat = 64
        
        shopImage.frame = CGRect(x: discripLabel.frame.minX, y: discripLabel.frame.maxY + shopLogoVirtalMargin, width: imageWH, height: imageWH)
        distance.ddSizeToFit(contentInset:UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) )
        let labelH = distance.bounds.height
        shopName.ddSizeToFit()
        shopName.frame = CGRect(x: shopImage.frame.maxX + margin, y: shopImage.frame.minY, width: (self.contentView.bounds.width - shopImage.frame.maxX) - margin * 2, height: shopName.bounds.height)
        
        container1.frame = CGRect(x: shopImage.frame.maxX + margin, y:shopName.frame.maxY + labelsVircalMargin, width: (self.contentView.bounds.width - shopImage.frame.maxX) - margin * 2, height: labelH)
        
        distance.center = CGPoint(x: (shopImage.frame.maxX + margin) + distance.bounds.width * 0.5, y: container1.frame.maxY + labelH * 0.5 + labelsVircalMargin)
        distance.backgroundColor = UIColor.colorWithHexStringSwift("#d8d8d8")
        distance.layer.cornerRadius = 3
        distance.layer.masksToBounds = true
        container2.frame = CGRect(x: shopImage.frame.maxX + margin, y:distance.frame.maxY + labelsVircalMargin, width: (self.contentView.bounds.width - shopImage.frame.maxX) - margin * 2, height: labelH)

        setupLabels(view: self.container1)
        setupLabels(view: self.container2)
        let currentMaxY = max(shopImage.frame.maxY, container2.frame.maxY)
        
        //layout create time
        createTime.ddSizeToFit()
        createTime.center = CGPoint(x: discripLabel.frame.minX + createTime.bounds.width/2, y: currentMaxY  + createTimeH/2)
        self.bottomLine.backgroundColor =  UIColor.colorWithHexStringSwift("#f2f2f2")
        self.bottomLine.frame = CGRect(x: 0, y: self.contentView.bounds.height - bottomLineH, width: self.contentView.bounds.width, height: bottomLineH)
        
    }
    
    func setupLabels(view:UIView)  {
        var priviousCenterX : CGFloat = 0
        var priviousW : CGFloat = 0
        let margin : CGFloat = 5
        for (index , subview) in view.subviews.enumerated() {
            //            subview.sizeToFit()
            subview.ddSizeToFit(contentInset:  UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
            //            let frame = subview.bounds
            //            subview.bounds = CGRect(x: 0, y: 0, width: frame.width + 10, height: frame.height )
            priviousCenterX = (priviousW * 0.5 + priviousCenterX ) + subview.bounds.width * 0.5
            //            subview.layer.cornerRadius = 5
            //            subview.layer.masksToBounds = true
            //            subview.backgroundColor = UIColor.randomColor()
            setUIStatus(containerView: view, subview: subview, index: index)
            subview.center = CGPoint(x: priviousCenterX  , y: container1.bounds.height * 0.5 )
            priviousW = subview.bounds.width
            priviousCenterX += margin
        }
    }
    
    func setUIStatus(containerView:UIView,subview:UIView ,index:Int ) {
        subview.layer.cornerRadius = 3
        subview.layer.masksToBounds = true
        if containerView == container1{
            switch index {
            case 0 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#fca8a8")
            case 1 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#f6c59d")
            case 2 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#f6a7ff")
            case 3 :
                subview.backgroundColor = UIColor.colorWithHexStringSwift("#fca8a8")
            default :
                break
            }
        }else if containerView == container2{
            
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.colorWithHexStringSwift("#e0e0e0").cgColor
            subview.backgroundColor = UIColor.white
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
     class func rowHeight(_ model:DDRowMessageModel) -> CGFloat {
        let tempCell = DDHDShopCell()
        tempCell.model1 = model
        let margin : CGFloat = 10
        let userIconWH : CGFloat = 40
        let userIconToLeft  : CGFloat = 10
        let userIconToTop  : CGFloat = 10
        let userIconToRight  :CGFloat = 10
        let createTimeH : CGFloat = 36
        let bottomLineH : CGFloat = 10
        let shopLogoVirtalMargin : CGFloat = 10
        let labelsVircalMargin : CGFloat = 3
        tempCell.userIcon.frame = CGRect(x: userIconToLeft, y: userIconToTop, width: userIconWH, height: userIconWH)
        tempCell.discripLabel.frame = CGRect(x: tempCell.userIcon.frame.maxX + userIconToRight, y: tempCell.userIcon.frame.minY, width: SCREENWIDTH - tempCell.userIcon.frame.maxX + userIconToRight, height: userIconWH * 0.3)
        
        let imageWH : CGFloat = 64
        
        tempCell.shopImage.frame = CGRect(x: tempCell.discripLabel.frame.minX, y: tempCell.discripLabel.frame.maxY + shopLogoVirtalMargin, width: imageWH, height: imageWH)
        tempCell.distance.ddSizeToFit(contentInset:UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) )
        let labelH = tempCell.distance.bounds.height
        tempCell.shopName.ddSizeToFit()
        tempCell.shopName.frame = CGRect(x: tempCell.shopImage.frame.maxX + margin, y: tempCell.shopImage.frame.minY, width: (SCREENWIDTH - tempCell.shopImage.frame.maxX) - margin * 2, height: tempCell.shopName.bounds.height)
        
        tempCell.container1.frame = CGRect(x: tempCell.shopImage.frame.maxX + margin, y:tempCell.shopName.frame.maxY + labelsVircalMargin, width: (SCREENWIDTH - tempCell.shopImage.frame.maxX) - margin * 2, height: labelH)
        
        tempCell.distance.center = CGPoint(x: (tempCell.shopImage.frame.maxX + margin) + tempCell.distance.bounds.width * 0.5, y: tempCell.container1.frame.maxY + labelH * 0.5 + labelsVircalMargin)
        tempCell.distance.backgroundColor = UIColor.colorWithHexStringSwift("#d8d8d8")
        tempCell.distance.layer.cornerRadius = 3
        tempCell.distance.layer.masksToBounds = true
        tempCell.container2.frame = CGRect(x: tempCell.shopImage.frame.maxX + margin, y:tempCell.distance.frame.maxY + labelsVircalMargin, width: (tempCell.contentView.bounds.width - tempCell.shopImage.frame.maxX) - margin * 2, height: labelH)
        
        tempCell.setupLabels(view: tempCell.container1)
        tempCell.setupLabels(view: tempCell.container2)
        let currentMaxY = max(tempCell.shopImage.frame.maxY, tempCell.container2.frame.maxY)
        
        //layout create time
        tempCell.createTime.ddSizeToFit()
        tempCell.createTime.center = CGPoint(x: tempCell.discripLabel.frame.minX + tempCell.createTime.bounds.width/2, y: currentMaxY  + createTimeH/2)
//        tempCell.bottomLine.backgroundColor = UIColor.lightGray
        tempCell.bottomLine.frame = CGRect(x: 0, y: tempCell.createTime.frame.maxY, width: SCREENWIDTH, height: bottomLineH)
        return tempCell.bottomLine.frame.maxY
    }
    
}
