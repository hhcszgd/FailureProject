//
//  HomeShopItem.swift
//  Project
//
//  Created by WY on 2017/11/29.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
protocol HomeShopItemDataSource : NSObjectProtocol{
    var imageUlr : String{get set }
    var name : String {get set }
    var distance : String{get set }
    var grade : [String] {get set }//消费档次
    var labels : [String]{get set }//有无wifi,服务如何,等
}
//extension HomeShopItemDataSource{
//    var imageUlr : String {return "http://upload-images.jianshu.io/upload_images/1950387-40f8b7ee339813ac.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/658"}
//        var name : String  {return "this is shop name"}
//        var distance : String  {return"distance is 1000"}
//        var grade : [String]  {return ["4.5分" , "高档" , "人均200"]}
//        var labels : [String]  {return ["服务好" , "免费wifi" , "免费停车"]}
//}
class HomeShopItemModel : NSObject, HomeShopItemDataSource{
    var imageUlr : String = "http://ozstzd6mp.bkt.gdipper.com/Snip20171130_2.png"
    var name : String  = "this is shop name"
    var distance : String  = "distance is 1000"
    var grade : [String]  = ["4.5分" , "高档" , "人均200"]
    var labels : [String]  = ["服务好" , "免费wifi" , "免费停车"]
}
class HomeShopItem: UICollectionViewCell {
    let shopImage  = UIImageView()
    let shopName  = UILabel()
    let distance = UILabel()
    let container1 = UIView()
    let container2 = UIView()
    let bottomLine = UIImageView()
    var shopModel : DDNearbyShopModel = DDNearbyShopModel(){
        didSet{
           mylog(shopModel)
            shopName.text  = shopModel.name
            distance.text = "\(shopModel.dispatching)"
            //SDWebImageOptions
            if let url  = URL(string: shopModel.front_image) {
                shopImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }
            let labels = splitStr(str: shopModel.label ?? "", separator: ",")
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
            let grade = [shopModel.score,"\(shopModel.average_consume)", shopModel.type_name]
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
//        else{
//            shopName.text  = nil
//            distance.text = nil
//            shopImage.image = nil
//            container1.subviews.forEach({ (subview ) in
//            subview.removeFromSuperview()
//            })
//            container2.subviews.forEach({ (subview ) in
//            subview.removeFromSuperview()
//            })
//        }
    }
    func splitStr(str:String , separator : Character) -> [String]  {
        let result  = str.split(separator: separator, omittingEmptySubsequences: true )
        return result.flatMap { (substring ) -> String? in
            return String(substring)
        }
    }
    var model : HomeShopItemDataSource? = nil {
        didSet{
            if let model  = model  {
                shopName.text  = model.name
                distance.text = model.distance
                //SDWebImageOptions
                if let url  = URL(string: model.imageUlr) {
                    shopImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
                }
                if model.labels.count == self.container2.subviews.count && self.container2.subviews.count != 0  {
                    for (index , label ) in self.container2.subviews.enumerated(){
                        if let  label = label as? UILabel {
                            label.text = model.labels[index]
                        }
                    }
                }else{
                    container2.subviews.forEach({ (subview ) in
                        subview.removeFromSuperview()
                    })
                    for (index , text) in model.labels.enumerated(){
                        let label = UILabel()
                        label.text = text
                        label.textColor = UIColor.colorWithHexStringSwift("#e0e0e0")
                         label.textAlignment = NSTextAlignment.center
                        label.font = UIFont.systemFont(ofSize: 13)
                        container2.addSubview(label)
                    }
                }
                
                if model.grade.count == self.container1.subviews.count && self.container1.subviews.count != 0  {
                    for (index , label ) in self.container1.subviews.enumerated(){
                        if let  label = label as? UILabel {
                            label.text = model.grade[index]
                        }
                    }
                }else{
                    container1.subviews.forEach({ (subview ) in
                        subview.removeFromSuperview()
                    })
                    for (index , text) in model.grade.enumerated(){
                        let label = UILabel()
                        label.font = UIFont.systemFont(ofSize: 13)
                        label.textColor = UIColor.white
                        label.textAlignment = NSTextAlignment.center
                        label.text = text
                        container1.addSubview(label)
                    }
                }
            }else{
                shopName.text  = nil
                distance.text = nil
                shopImage.image = nil
                container1.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
                container2.subviews.forEach({ (subview ) in
                    subview.removeFromSuperview()
                })
            }
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(shopImage)
        self.contentView.addSubview(shopName)
        self.contentView.addSubview(distance)
        distance.font = UIFont.systemFont(ofSize: 13)
        distance.textColor = UIColor.white
        distance.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(container1)
        self.contentView.addSubview(container2)
        self.contentView.addSubview(bottomLine)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let toTop : CGFloat = 10
        let imageWH = self.bounds.height - toTop * 2
        shopImage.frame = CGRect(x: toTop, y: toTop, width: imageWH, height: imageWH)
        let labelH = imageWH * 0.25
        shopName.frame = CGRect(x: shopImage.frame.maxX + toTop, y: toTop, width: (self.contentView.bounds.width - shopImage.frame.maxX) - toTop * 2, height: labelH)
        
        container1.frame = CGRect(x: shopImage.frame.maxX + toTop, y: toTop + labelH, width: (self.contentView.bounds.width - shopImage.frame.maxX) - toTop * 2, height: labelH)
        distance.ddSizeToFit(contentInset:UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) )
        
        distance.center = CGPoint(x: (shopImage.frame.maxX + toTop) + distance.bounds.width * 0.5, y: container1.frame.maxY + labelH * 0.5)
        distance.backgroundColor = UIColor.colorWithHexStringSwift("#d8d8d8")
        distance.layer.cornerRadius = 3
        distance.layer.masksToBounds = true
        container2.frame = CGRect(x: shopImage.frame.maxX + toTop, y: toTop + labelH * 3, width: (self.contentView.bounds.width - shopImage.frame.maxX) - toTop * 2, height: labelH)
//        container2.backgroundColor = UIColor.randomColor()
        var priviousCenterX : CGFloat = 0
        var priviousW : CGFloat = 0
        let margin : CGFloat = 5
        setupLabels(view: self.container1)
        setupLabels(view: self.container2)
        
        self.bottomLine.backgroundColor = UIColor.red.withAlphaComponent(0.051)
        self.bottomLine.frame = CGRect(x: 0, y: self.contentView.bounds.height - 2, width: self.contentView.bounds.width, height: 2)
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
}
