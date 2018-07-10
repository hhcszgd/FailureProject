//
//  HomeClassifyItem.swift
//  Project
//
//  Created by WY on 2017/11/29.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage

protocol HomeClassifyItemDelegate : NSObjectProtocol {
    func performSearch(keyword:String)
    func commentClick(id:String)
}
class HomeClassifyItem: UICollectionViewCell , GDAutoScrollViewActionDelegate{
    let backImage = UIImageView()
    let collectionContainer : UIView = UIView()
    let nearbyImg = UIImageView()
    weak var delegate : HomeClassifyItemDelegate?
    let messages : DDUpDownAutoScroll = DDUpDownAutoScroll()
    let labelsContainer : UIView = UIView()
//    var nearbyComments = [DDHotComment](){
//        didSet{
//            messages.models  = nearbyComments
//            self.layoutIfNeeded()
//        }
//    }
    var hudong  = [DDHomeMsgModel](){
        didSet{
            
            messages.models  = hudong
            self.layoutIfNeeded()
        }
    }
    
    var channels = [DDChannelMenuModel](){
        didSet{
//            mylog(channels)
            for (index , channel ) in channels.enumerated() {
                if index >= 0 && index < 8{
                    if let imgTxt =  labelsContainer.subviews[index] as? HomeChannelView{
                        imgTxt.model = channel
                    }
                }
            }
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(backImage)
        self.contentView.addSubview(collectionContainer)
        collectionContainer.addSubview(nearbyImg)
        nearbyImg.image = UIImage(named:"nearby")
        nearbyImg.contentMode  = UIViewContentMode.scaleAspectFill
        collectionContainer.addSubview(messages)
        messages.delegate = self
        self.contentView.addSubview(labelsContainer)
//        labelsContainer.backgroundColor = UIColor.purple
        for index  in 0..<8 {
            let label = HomeChannelView( margin: 5)
            label.addTarget(self , action: #selector(channelClick(sender:)), for: UIControlEvents.touchUpInside)
            label.label.text = "标题"
//            label.imageView.image = UIImage(named:"Help_icon")
            label.imageView.layer.cornerRadius = 12
            label.imageView.layer.masksToBounds = true
            labelsContainer.addSubview(label)
        }
        collectionContainer.backgroundColor = UIColor.white
        backImage.image = UIImage(named:"background")
    }
    @objc func channelClick(sender:HomeChannelView)  {
        self.delegate?.performSearch(keyword: sender.model.name)
    }
    func performAction(model : DDHotComment){
//        mylog(model.id)
        self.delegate?.commentClick(id: "\(model.id)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let messageViewH : CGFloat = 40
        self.collectionContainer.frame = CGRect(x: 40, y: bounds.height - messageViewH , width: bounds.width - 80, height: messageViewH)
        let nearbyToBorderMargin : CGFloat = 10
        nearbyImg.bounds = CGRect(x: 0, y: 0, width: nearbyImg.image?.size.width ?? 40, height: nearbyImg.image?.size.height ?? 40)
        nearbyImg.center = CGPoint(x: nearbyImg.bounds.width/2 + nearbyToBorderMargin, y: messageViewH/2)
//        nearbyImg.frame = CGRect(x: 10, y: 0, width: messageViewH , height: messageViewH)
        messages.frame = CGRect(x: nearbyImg.frame.maxX + 10 , y: 0, width: (collectionContainer.bounds.width - nearbyImg.frame.maxX) - 20  , height: messageViewH)
        
        self.collectionContainer.layer.masksToBounds = true
        self.collectionContainer.layer.cornerRadius = messageViewH * 0.5
        self.collectionContainer.layer.borderColor = UIColor.colorWithHexStringSwift("#eeeeee").cgColor
        self.collectionContainer.layer.borderWidth = 1
        self.backImage.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - messageViewH * 0.5)
        
        let labelsContainerH = self.bounds.height * 0.4
        let labelsContainerW = self.bounds.width
        let labelsContainerToMessageMargin : CGFloat = 20
        labelsContainer.frame = CGRect(x: 0, y: ((self.bounds.height - messageViewH) - labelsContainerToMessageMargin) - labelsContainerH, width: labelsContainerW, height: labelsContainerH)
        let toBorderMargin : CGFloat = 10
        let vircalMargin : CGFloat = 10
        let horenzantalMargin : CGFloat = 10
        let labelW = (( labelsContainerW - horenzantalMargin * 3 )  - toBorderMargin  * 2) / 4
        let labelH = ( labelsContainerH - vircalMargin ) / 2
        
        for (index , view) in labelsContainer.subviews.enumerated() {
            let x = toBorderMargin + ((labelW + horenzantalMargin) * CGFloat((index ) % 4 ))
            let y = CGFloat(Int( (index ) / 4)) * (vircalMargin + labelH)
            view.frame = CGRect(x: x , y: y, width: labelW, height: labelH)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





import UIKit

class HomeChannelView: UIControl {
    
    /*
     lazy var titleLabel = UILabel()//底部标题
     lazy var subTitleLabel = UILabel()//头部数量标题
     lazy var imageView = UIImageView()//图片视图
     lazy var additionalLabel = UILabel()//额外的文字标题(bedge数量)
     */
    let imageView = UIImageView()
    let label = UILabel()
    var imgToLblMargin : CGFloat = 0
    var model = DDChannelMenuModel(){
        didSet{
            label.text = model.name
            if let url  = URL(string:model.image_url) {
                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }else{
                imageView.image = DDPlaceholderImage
            }
        }
    }
    //    let container = UIView()
    
    //    var model  = ProfileSubModel(dict:nil) {
    //        didSet{
    //            //当图片为网络图片链接时
    //            //当图片不是网络链接时
    //            if model.localImgName != nil {
    //                if let imgName = model.localImgName {
    //                    self.imageView.image = UIImage(named: imgName)
    //                }
    //            }else{
    ////                self.imageView.sd_setImage(with: imgStrConvertToUrl("服务器图片地址"))//
    //            }
    //            //            self.topTitleLabel.text = "\(model.number)"
    //            self.subTitleLabel.text = model.name
    //            //            self.setNeedsLayout()
    //            //            self.layoutIfNeeded()
    //        }
    //
    //    }
    
    convenience init(frame : CGRect = CGRect.zero , margin : CGFloat = 5.0) {//imgToLblMargin
        self.init(frame: frame)
        self.imgToLblMargin = margin
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        self.label.font = GDFont.systemFont(ofSize: 14)//默认14号字体
        self.label.textColor = UIColor.white
        self.label.textAlignment = NSTextAlignment.center
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let  selfW = self.bounds.size.width
        let  selfH = self.bounds.size.height
        let leftH = (selfH - imgToLblMargin ) - label.font.lineHeight
        let bottomTitleW =  selfW
        let bottomTitleH = self.label.font.lineHeight
        let bottomTitleX : CGFloat = 0.0 ;
        let bottomTitleY = selfH - bottomTitleH
        
        var imgW : CGFloat = 0.0
        var  imgH : CGFloat = 0.0
        if selfW < leftH {
            imgW = selfW
            imgH = imgW
        }else {
            imgH = leftH
            imgW = imgH
        }
        self.imageView.bounds = CGRect(x: 0, y: 0, width: imgW, height: imgH)
        self.imageView.center = CGPoint(x: selfW/2, y: imgH/2)
        self.label.bounds = CGRect(x: 0, y: 0, width: bottomTitleW, height: bottomTitleH)
        self.label.center = CGPoint(x: selfW/2, y: bottomTitleY + bottomTitleH/2)
        
    }
}
