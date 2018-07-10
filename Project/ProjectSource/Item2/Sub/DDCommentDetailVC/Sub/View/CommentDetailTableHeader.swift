//
//  CommentDetailTableHeader.swift
//  Project
//
//  Created by WY on 2017/12/24.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class CommentDetailTableHeader: UIView {
    
    let userImage = UIImageView()
    let userName = UILabel()
    let userLabelContainer = UIView()
    let comment = UILabel()
    let imageContainer = UIView()//[UIButton]
    let time = UILabel()
    let zan = UIButton()
    let leaveMessage = UIButton()
    let bottomLine = UIView()
    override init(frame: CGRect) {
        super.init(frame:frame)
//        self.backgroundColor = UIColor.randomColor()
        
        addsubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model1 = CommentMember(){
        didSet{
            if let url  = URL(string: model1.head_img) {
                userImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in}
            }
            setImags(model: model1)
            userName.text = model1.nickname
            comment.text = model1.content
            time.text = model1.create_at
            zan.setTitle(model1.good_number, for: UIControlState.normal)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
   
//    var model  = DDShopCommentModel(){
//        didSet{
//            if let url  = URL(string: model.head_img) {
//                userImage.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in}
//            }
//            setImags(model: model)
//            userName.text = model.nickname
//            comment.text = model.content
//            time.text = model.create_at
//            zan.setTitle(model.good_number, for: UIControlState.normal)
//        }
//    }
    func setImags(model:CommentMember) {
        func gettemomodel() ->DDCommentMedia{
            let model = DDCommentMedia.init()
            model.image_url = DDTestImageUrl?.absoluteString
            return model
        }
        model.images = [gettemomodel(),gettemomodel(),gettemomodel(),gettemomodel(),gettemomodel(),gettemomodel()]
        if let imgs  = model.images {
            if self.imageContainer.subviews.count == imgs.count && imgs.count != 0 {
                for (index ,model) in imgs.enumerated(){
                    if let btn   = self.imageContainer.subviews[index] as? UIButton{
                        if let url  = URL(string: model.image_url ?? "") {
                            btn.sd_setImage(with: url , for: UIControlState.normal, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed], completed: nil )
                        }
                    }
                }
            }else{
                self.imageContainer.subviews.forEach { (subview ) in
                    subview.removeFromSuperview()
                }
                for model in imgs{
                    let btn   = UIButton.init()
                    btn.backgroundColor = UIColor.randomColor()
                    if let url  = URL(string: model.image_url ?? "") {
                        btn.sd_setImage(with: url , for: UIControlState.normal, placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed], completed: nil )
                    }
                    btn.backgroundColor  = UIColor.colorWithHexStringSwift("#fff5f5")
                    self.imageContainer.addSubview(btn)
                }
            }
        }
        
    }
    
    
    func addsubviews()  {
        self.addSubview(userImage)
        self.addSubview(userName)
        userName.textColor = UIColor.colorWithHexStringSwift("#f17979")
        self.addSubview(userLabelContainer)
        self.addSubview(comment)
        comment.numberOfLines = 0
        comment.textColor = UIColor.DDSubTitleColor
        self.addSubview(imageContainer)
        //        imageContainer.backgroundColor = UIColor.blue
        self.addSubview(time)
        time.textAlignment = NSTextAlignment.center
        time.textColor = UIColor.colorWithHexStringSwift("#898989")
        self.addSubview(zan)
        zan.setTitleColor(UIColor.colorWithHexStringSwift("#c1c1c1"), for: UIControlState.normal)
        self.addSubview(leaveMessage)
        leaveMessage.setTitle("留言", for: UIControlState.normal)
        leaveMessage.setTitleColor(UIColor.colorWithHexStringSwift("#aaaaaa"), for: UIControlState.normal)
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor.colorWithHexStringSwift("#f2f2f2")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        _layoutsubviews()
    }
    func _layoutsubviews()  {
        let headerImgWH : CGFloat = 44
        let margin : CGFloat = 15
        var maxY : CGFloat = 0
        userImage.frame = CGRect(x: margin, y: margin, width: headerImgWH, height: headerImgWH)
        userImage.layer.cornerRadius = headerImgWH/2
        userImage.layer.masksToBounds = true
        userName.frame = CGRect(x: userImage.frame.maxX + margin/2, y: userImage.frame.minY, width: 250, height: userImage.bounds.height/2)
        maxY = userImage.frame.maxY
//        comment.text = "全集是一个相对的概念，只包含所研究问题中所涉及的所有元素，补集只相对于相应的全集而言。如：我们在整数范围内研究问题，则Z为全集，而当问题拓展到实数集时，则R为全集，补集也只是相对于此而言"
        if let size = comment.text?.sizeWith(font: comment.font, maxWidth: self.bounds.width - margin * 2){
            comment.frame = CGRect(x: margin, y: userImage.frame.maxY + margin , width: size.width, height: size.height)
            maxY = comment.frame.maxY
        }
        if let images  = model1.images , images.count > 0{
            imageContainer.isHidden = false
            let imgW = (self.bounds.width - margin * 4) / 3
            let imgH = imgW * 0.7
            for (index , imgBtn ) in imageContainer.subviews.enumerated(){
                let rowNum = Int(index / 3)
                let colNum =  index % 3
                let imgX = margin + (margin + imgW) * CGFloat(colNum)
                let imgY = margin + (margin + imgH) * CGFloat(rowNum)
                imgBtn.frame = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
                if index == images.count - 1{
                    imageContainer.frame = CGRect(x: 0, y: comment.frame.maxY , width: self.bounds.width, height: imgBtn.frame.maxY )
                    maxY = imageContainer.frame.maxY
                }
            }
        }else{imageContainer.frame = CGRect.zero;imageContainer.isHidden = true }
        leaveMessage.frame = CGRect(x: self.bounds.width - margin - 100, y: maxY + margin, width: 100, height: 40)
        time.ddSizeToFit()
        time.center = CGPoint(x:margin + time.bounds.width/2,y:leaveMessage.frame.midY)
        zan.frame = CGRect(x: time.frame.maxX + margin, y: leaveMessage.frame.minY, width: 88, height: 40)
        bottomLine.frame = CGRect(x: margin, y: zan.frame.maxY - 1 , width: self.bounds.width - margin * 2, height: 2)
        maxY = zan.frame.maxY
    }
    
    
    
    
    
    
    
    class func caculateCellHeight(model  : CommentMember) -> CGFloat  {
        let headerImgWH : CGFloat = 44
        let margin : CGFloat = 15
        var maxY : CGFloat = 0
        let label = UILabel()
        let userImageframe = CGRect(x: margin, y: margin, width: headerImgWH, height: headerImgWH)
        maxY = userImageframe.maxY
        label.text = model.content
//        label.text = "全集是一个相对的概念，只包含所研究问题中所涉及的所有元素，补集只相对于相应的全集而言。如：我们在整数范围内研究问题，则Z为全集，而当问题拓展到实数集时，则R为全集，补集也只是相对于此而言"//待注销
        if let size = label.text?.sizeWith(font: label.font, maxWidth: SCREENWIDTH - margin * 2){
            let commentframe = CGRect(x: margin, y: userImageframe.maxY + margin , width: size.width, height: size.height)
            maxY = commentframe.maxY
        }
        if let images  = model.images , images.count > 0{
            let imgW = (SCREENWIDTH - margin * 4) / 3
            let imgH = imgW * 0.7
            for (index , imgBtn ) in images.enumerated(){
                let rowNum = Int(index / 3)
                let colNum =  index % 3
                let imgX = margin + (margin + imgW) * CGFloat(colNum)
                let imgY = margin + (margin + imgH) * CGFloat(rowNum)
                let imgBtnframe = CGRect(x: imgX, y: imgY, width: imgW, height: imgH)
                if index == images.count - 1{
                    let imageContainerframe = CGRect(x: 0, y: maxY , width: SCREENWIDTH, height: imgBtnframe.maxY )
                    maxY = imageContainerframe.maxY
                }
            }
        }
        let leaveMessageframe = CGRect(x: SCREENWIDTH - margin - 100, y: maxY + margin, width: 100, height: 40)
        //        label.text = model.create_at
        //        label.ddSizeToFit()
        //        time.center = CGPoint(x:margin + time.bounds.width/2,y:leaveMessage.frame.minY)
        //        zan.frame = CGRect(x: time.frame.maxX + margin, y: time.frame.minY, width: 88, height: 40)
        maxY = leaveMessageframe.maxY
        return maxY
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
