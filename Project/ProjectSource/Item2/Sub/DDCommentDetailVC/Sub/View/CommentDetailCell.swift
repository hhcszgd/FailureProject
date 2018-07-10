//
//  CommentDetailCell.swift
//  Project
//
//  Created by WY on 2017/12/24.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class CommentDetailCell: DDTableViewCell {
    let backColorView  = UIView()
    
    let label = UILabel()
    var model  = ReplyModel(){
        didSet{
            let memberName = model.member_name + " : "
            let attribteString = [memberName,model.content].setColor(colors: [UIColor.orange,UIColor.gray])
            label.attributedText = attribteString
//            label.text = model.member_name + model.content
//            label.text = "str = model.member_name"
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(backColorView)
        backColorView.backgroundColor = UIColor.colorWithHexStringSwift("#f7f7f7")
        self.contentView.addSubview(label)
        self.label.textColor = UIColor.DDSubTitleColor
        label.numberOfLines = 0
//        label.textAlignment = NSTextAlignment.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin : CGFloat = 10
//        let toTop : CGFloat = 5
        let padding : CGFloat = 10
        let userIconWH : CGFloat = 44
        if let size = label.text?.sizeWith(font: label.font, maxWidth: SCREENWIDTH - userIconWH -  margin * 3 + padding * 2){
            label.frame = CGRect(x:  margin * 2 + userIconWH + padding, y: padding, width: self.bounds.width  - userIconWH - padding * 2 - margin * 3, height: size.height)
            backColorView.frame = CGRect(x: label.frame.minX - padding, y: label.frame.minY - padding, width: self.bounds.width  - userIconWH - margin * 3, height: label.frame.height + padding * 2)
        }
    }
    class func rowHeight(model : ReplyModel) -> CGFloat{
        let margin : CGFloat = 10
//        let toTop : CGFloat = 5
        let padding : CGFloat = 10
        let userIconWH : CGFloat = 44
        let tempLabel = UILabel()
        var  str = model.member_name + model.content
//        str = "str = model.member_name"
        let size = str.sizeWith(font: tempLabel.font, maxWidth: SCREENWIDTH   - userIconWH -  margin * 3 + padding * 2 )
        let labelframe = CGRect(x:  margin * 2 + userIconWH, y: padding, width: SCREENWIDTH - userIconWH - padding * 2   - margin * 3, height: size.height)
        let backColorViewframe = CGRect(x: labelframe.minX - padding, y: labelframe.minY - padding, width: SCREENWIDTH  - userIconWH  - margin * 3, height: labelframe.height + padding * 2)
        return backColorViewframe.maxY
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
