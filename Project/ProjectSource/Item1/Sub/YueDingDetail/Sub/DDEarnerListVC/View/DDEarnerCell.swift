//
//  DDEarnerCell.swift
//  Project
//
//  Created by 金曼立 on 2018/4/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDEarnerCell: DDTableViewCell {
    
    let icon = UIImageView()
    let name = UILabel()
    let phoneNum = UILabel()
    let state = UILabel()
    let monayNum = UILabel()
    let selectBtn = UIButton()
    
    var model: DDEarnerModel? = DDEarnerModel(){
        didSet{
            selectBtn.isUserInteractionEnabled = true
            var stateStr = ""
            if model?.status == "4" || model?.status == "2" || model?.status == "3" {
                stateStr = "报酬有修改"
                selectBtn.isUserInteractionEnabled = false
                selectBtn.isSelected = false
            } else if model?.status == "5" || model?.status == "6" {
                selectBtn.isUserInteractionEnabled = false
                selectBtn.isSelected = false
            } else {
               selectBtn.isSelected = true
            }
            icon.setImageUrl(url: model?.head_images)
            configData(text: model?.nickname, sender: name, color: color11, fontSize: 15)
            configData(text: model?.name, sender: phoneNum, color: color11, fontSize: 14)
            configData(text: stateStr, sender: state, color: UIColor.colorWithHexStringSwift("e60000"), fontSize: 16)
            configData(text: (model?.payment_price ?? "") + "元", sender: monayNum, color: color11, fontSize: 15)
            selectBtn.setImage(UIImage(named:"checkboxisnotselected"), for: UIControlState.normal)
            selectBtn.setImage(UIImage(named:"selected_btn_icon"), for: UIControlState.selected)
            selectBtn.addTarget(self, action: #selector(selectBtnClick), for: UIControlEvents.touchUpInside)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.isSelected = true
        self.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        addsubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectBtnClick() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DDEarnerCellClick"), object: self,
                                        userInfo: ["selectNum": !selectBtn.isSelected, "priceNum": model?.payment_price ?? "", "id" : model?.id ?? ""])
        selectBtn.isSelected = !selectBtn.isSelected
    }
    
    func addsubviews()  {
        self.contentView.addSubview(icon)
        self.contentView.addSubview(name)
        self.contentView.addSubview(phoneNum)
        self.contentView.addSubview(state)
        self.contentView.addSubview(monayNum)
        self.contentView.addSubview(selectBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _layoutsubviews()
    }
    
    func configData(text: String?, sender: UILabel, color: UIColor, fontSize: CGFloat)  {
        sender.text = text
        sender.font = UIFont.systemFont(ofSize: fontSize)
        sender.textColor = color
    }
    
    func _layoutsubviews()  {
        icon.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
        }
        name.snp.makeConstraints { (make) in
            make.top.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(16)
            make.right.equalTo(state.snp.left).offset(-10)
        }
        phoneNum.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(13)
            make.left.equalTo(name)
        }
        state.snp.makeConstraints { (make) in
            make.bottom.equalTo(name)
            make.left.equalTo(name.snp.right).offset(10)
        }
        monayNum.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(selectBtn.snp.left).offset(-7)
        }
        selectBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(13)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
    }
}
