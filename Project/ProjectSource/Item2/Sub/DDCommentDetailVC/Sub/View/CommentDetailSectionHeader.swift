//
//  CommentDetailSectionHeader.swift
//  Project
//
//  Created by WY on 2017/12/24.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class CommentDetailSectionHeader: UITableViewHeaderFooterView {
    let userIcon = UIImageView()
    let userName = UILabel()
    var model = ReplyMember()
    {
        didSet{
            userName.text = model.member_name + model.content
//            userName.text = "model.member_name + model.contenta;[okp;ilkufdfflglk;ijfdgfghlgjgkhfgkuyfhjhgfjhgfjhgfldfjac;lskdjf;alskdfjamodel.member_name + model.contljk;uiliujo;iulkj;lkj;lkj;lkj;ent"
            if let url  = URL(string: model.member_avatar) {
                userIcon.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly , SDWebImageOptions.retryFailed]) { (image , error , imageCacheType, url) in}
            }else{
                userIcon.image = DDPlaceholderImage
            }
        }
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
//        self.backgroundColor = UIColor.randomColor()
        self.contentView.addSubview(userIcon)
        self.contentView.addSubview(userName)
        userName.textColor = UIColor.DDSubTitleColor
        userName.numberOfLines = 0
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
        let userIconWH : CGFloat = 44
        userIcon.frame = CGRect(x: margin, y: margin, width: userIconWH, height: userIconWH)
        userIcon.layer.cornerRadius = self.userIcon.bounds.width/2
        userIcon.layer.masksToBounds = true 
        if let size = userName.text?.sizeWith(font: userName.font, maxWidth: SCREENWIDTH - userIcon.frame.maxX - margin * 2){
            userName.frame = CGRect(x: userIcon.frame.maxX + margin, y: userIcon.frame.midY - userName.font.lineHeight/2, width: self.bounds.width - userIcon.frame.maxX - margin * 2, height: size.height)
            
        }
    }
    class func heightForHeader(model : ReplyMember) -> CGFloat{
        let tempLabel = UILabel()
        let margin : CGFloat = 10
        let userIconWH : CGFloat = 44
        let iconToTop : CGFloat = 10
        let iconToLeft : CGFloat = 10
        let  str = model.member_name + model.content
//        str = "model.member_name + model.contenta;[okp;ilkufdfflglk;ijfdgfghlgjgkhfgkuyfhjhgfjhgfjhgfldfjac;lskdjf;alskdfjamodel.member_name + model.contljk;uiliujo;iulkj;lkj;lkj;lkj;ent"
        let userIconframe = CGRect(x: iconToLeft, y: iconToTop, width: userIconWH, height: userIconWH)
        
         let size = str.sizeWith(font: tempLabel.font, maxWidth: SCREENWIDTH - userIconframe.maxX - margin * 2)
        let userNameframe = CGRect(x: userIconframe.maxX + margin, y: userIconframe.midY  - tempLabel.font.lineHeight/2, width: SCREENWIDTH - userIconframe.maxX - margin * 2, height: size.height)
        return max(userNameframe.maxY, userIconframe.maxY) + margin
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
