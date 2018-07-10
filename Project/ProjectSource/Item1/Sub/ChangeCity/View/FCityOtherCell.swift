//
//  FCityOtherCell.swift
//  zuidilao
//
//  Created by wy on 2017/11/10.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
///正常形式的城市cell
class FCityOtherCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview()
        }
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(1)
        }
        self.contentView.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = font13
        self.contentView.addSubview(label)
        label.textColor = UIColor.colorWithHexStringSwift("4d4d4d")
        label.sizeToFit()
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    lazy var lineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = lineColor
        self.contentView.addSubview(view)
        return view
    }()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
