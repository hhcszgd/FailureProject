//
//  DDShopSectionHeaderView.swift
//  Project
//
//  Created by WY on 2017/12/19.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
protocol DDShopSectionHeaderViewDelegate : NSObjectProtocol {
    func shopSectionHeaderAction(headerView:DDShopSectionHeaderView,actionType:Int?)
}
class DDShopSectionHeaderView: UITableViewHeaderFooterView {
    private let titleLabel = UILabel()
    var model : (title : NSAttributedString? , subTitle : NSAttributedString? , actionType : Int?) = (nil , nil , nil){
        didSet{
            titleLabel.attributedText = model.title
            subTitleLabel.attributedText = model.subTitle
            self.layoutIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    weak var delegate :DDShopSectionHeaderViewDelegate?
    private let subTitleLabel : UILabel = UILabel.init()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        titleLabel.textColor = UIColor.colorWithHexStringSwift("#6a6a6a")
        self.addSubview(subTitleLabel)
        subTitleLabel.textColor = UIColor.DDSubTitleColor
        subTitleLabel.textAlignment = NSTextAlignment.right
        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self , action: #selector(tap(gesture:)))
        subTitleLabel.addGestureRecognizer(tap)
        subTitleLabel.isUserInteractionEnabled = true 
        self.contentView.backgroundColor = .white
    }
    @objc func tap(gesture : UITapGestureRecognizer) {
        mylog(gesture)
        self.delegate?.shopSectionHeaderAction(headerView: self , actionType: model.actionType)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: self.bounds.width/2 - 15, height: self.bounds.height)
        subTitleLabel.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: titleLabel.bounds.width, height: self.bounds.height)
    }
    required init?(coder aDecoder: NSCoder) {
//        let label = aDecoder.decodeObject(forKey: "titleLabel")
        fatalError("init(coder:) has not been implemented")
    }
}


//    class DDShopSectionHeaderAssistantView: UIControl {
//        private let label  = UILabel()
//        private let image = UIImageView()
//        var model : (String? , String?) = (nil ,nil){
//            didSet {
//                label.text = model.0
//                if let imageName = model.1{
//                    image.image = UIImage(named: imageName)
//                }
//                self.layoutIfNeeded()
//                self.setNeedsLayout()
//            }
//        }
//
//        override init(frame: CGRect) {
//            super.init(frame:frame)
//            self.addSubview(label)
//            label.textAlignment = NSTextAlignment.right
//            self.addSubview(image)
//        }
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            if image.image != nil {
//                image.isHidden = false
//                image.frame = CGRect(x: self.bounds.width - self.bounds.height, y: 0, width: self.bounds.height, height: self.bounds.height)
//                if label.text != nil {
//                    label.isHidden = false
//                    label.frame = CGRect(x: self.bounds.width - self.bounds.height * 2, y: 0, width: self.bounds.width , height: self.bounds.height)
//                }else{
//                    label.isHidden = true
//                }
//            }else{
//                image.isHidden = true
//                if label.text != nil {
//                    label.isHidden = false
//                    label.frame = CGRect(x: self.bounds.width - self.bounds.height, y: 0, width: self.bounds.width - self.bounds.height, height: self.bounds.height)
//                }else{
//                    label.isHidden = true
//                }
//            }
//        }
//
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//    }
