//
//  UIImageView+extestion.swift
//  Project
//
//  Created by WY on 2018/4/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
extension  UIImageView {
    func setImageUrl(url:String?) {
        if let urlStr = url , let urlInstence = URL(string: urlStr){
            self.sd_setImage(with: urlInstence, placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.retryFailed,SDWebImageOptions.cacheMemoryOnly])
        }else{
            self.image = DDPlaceholderImage
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension  UIButton {
    func setImageUrl(url:String? , status : UIControlState = .normal) {
        if let urlStr = url , let urlInstence = URL(string: urlStr){
            self.sd_setImage(with: urlInstence, for: status, placeholderImage: DDPlaceholderImage, options: [SDWebImageOptions.retryFailed,SDWebImageOptions.cacheMemoryOnly])
        }else{
            self.setImage(DDPlaceholderImage, for: status)
        }
    }
}
