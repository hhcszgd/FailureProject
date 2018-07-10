//
//  HomeScrollSubItem.swift
//  Project
//
//  Created by WY on 2017/11/30.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import SDWebImage
class HomeScrollSubItem: UICollectionViewCell {
    let imageView = UIImageView()
    var model : DDHotRecom = DDHotRecom(){
        didSet{
            if let url  = URL(string:model.article_image) {
                imageView.sd_setImage(with: url , placeholderImage: DDPlaceholderImage , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        self.imageView.frame = self.bounds
//        if let url  = URL(string: "http://ozstzd6mp.bkt.gdipper.com/Snip20171130_2.png") {
//            self.imageView.sd_setImage(with: url , placeholderImage: nil , options: [SDWebImageOptions.cacheMemoryOnly, SDWebImageOptions.retryFailed])
//        }
        super.layoutSubviews()
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}
