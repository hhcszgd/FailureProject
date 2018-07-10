//
//  DDStageMoreCell.swift
//  Project
//
//  Created by 金曼立 on 2018/4/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDStageMoreCell: DDTableViewCell {
    
    let label = UILabel()
    let numLabel = UILabel()
    
    var count : Int?  // 总人数
    var model: DDStageEarnerNumModel? = DDStageEarnerNumModel(){
        didSet{
            label.text = "\(model?.term ?? 0)" + "期"
            if let count = self.count {
                numLabel.text = "\(model?.num ?? 0)" + "/" + "\(count)"
            }
            if (model?.num ?? 0) == count {
//                self.isUserInteractionEnabled = false
                self.label.textColor = UIColor.colorWithRGB(red: 140, green: 140, blue: 140)
                self.numLabel.textColor = UIColor.colorWithRGB(red: 140, green: 140, blue: 140)
            } else if model?.num ?? 0 > self.count ?? 0 {
                model?.num = self.count
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(label)
        self.addSubview(numLabel)
        
        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        numLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }  
}
