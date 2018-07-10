//
//  DDStageSingleCell.swift
//  Project
//
//  Created by 金曼立 on 2018/4/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDStageSingleCell: DDTableViewCell {
    
    let label = UILabel()
    let selectedImg = UIImageView()
    var isSelect = false
    var model: DDStageSingleModel? = DDStageSingleModel(){
        didSet{
            label.text = (model?.num ?? "") + "期"
            selectedImg.isHidden = false
            selectedImg.image = UIImage(named:"checkboxisnotselected")
            if model?.status == "0" || model?.status == "6" {
                selectedImg.isHidden = true
                self.selectionStyle = UITableViewCellSelectionStyle.none
                label.textColor = UIColor.colorWithRGB(red: 140, green: 140, blue: 140)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(label)
        self.addSubview(selectedImg)

        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        selectedImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(13)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
