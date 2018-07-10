//
//  CityColCell.swift
//  zuidilao
//
//  Created by wy on 2017/11/11.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit

class CityColCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 6
    }
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(label)
        return label
    }()
    var model: CityModel? {
        didSet{
            self.titleLabel.text = model?.cityName
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
