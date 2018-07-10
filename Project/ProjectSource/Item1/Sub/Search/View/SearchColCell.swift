//
//  SearchColCell.swift
//  wenyouhui
//
//  Created by wy on 2017/6/6.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit

class SearchColCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        self.titleLabel.textColor = color1
        self.titleLabel.font = font13
        self.titleLabel.layer.borderColor = color1.cgColor
        self.titleLabel.layer.borderWidth = 1
        self.contentView.backgroundColor = UIColor.clear
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.layer.masksToBounds = true
        self.titleLabel.layer.cornerRadius = 6
        
    }
    var model: SearchModel = SearchModel.init() {
        didSet{
            if let title = model.title {
                self.titleLabel.text = title
            }
            
        }
    }
    var title: String = String() {
        didSet{
            self.titleLabel.text = title
            
        }
    }
    /**商品介绍*/
    lazy var titleLabel = UILabel.init()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
