//
//  DDPublicSearchNav.swift
//  Project
//
//  Created by 金曼立 on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import SnapKit
protocol DDPublicSearchNavDelegate : NSObjectProtocol {
    func performAction(actionType : DDPublicSearchNav.PublicSearchBarActionType)
}

class DDPublicSearchNav: UIView {
    
    enum PublicSearchBarActionType{
        // 返回
        case back
        // 搜索
        case search
        // 确定
        case certain
    }
    weak var delegate  : DDPublicSearchNavDelegate?
    
    let margin: CGFloat = 10
    let searchContainer = UIView()
    let searchBox = DDSearchBox.init(frame: CGRect.zero, placeholder: "搜索公开约定", fontPh: 15)
    let backIcon = UIButton()
    let certainIcon = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        searchContainer.backgroundColor = UIColor.clear
        searchBox.delegate =  self
        self.addSubview(searchContainer)
        searchContainer.addSubview(backIcon)
        searchContainer.addSubview(certainIcon)
        searchContainer.addSubview(searchBox)
        
        backIcon.setImage(UIImage(named:"back_icon"), for: UIControlState.normal)
        backIcon.setImage(UIImage(named:"back_icon"), for: UIControlState.highlighted)
        backIcon.addTarget(self, action: #selector(actionClick(sender:)), for: UIControlEvents.touchUpInside)
        certainIcon.setTitle("确定", for: UIControlState.normal)
        certainIcon.addTarget(self, action: #selector(actionClick(sender:)), for: UIControlEvents.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchContainer.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(DDNavigationBarHeight)
        }
        backIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(margin)
            make.width.height.equalTo(30)
            make.centerY.equalTo(DDnavigationStateHeight + (DDNavigationBarHeight - DDnavigationStateHeight) / 2)
        }
        certainIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-margin)
            make.height.equalTo(30)
            make.width.equalTo(40)
            make.centerY.equalTo(backIcon)
        }
        searchBox.snp.makeConstraints { (make) in
            make.left.equalTo(backIcon.snp.right).offset(8)
            make.right.equalTo(certainIcon.snp.left).offset(-8)
            make.height.equalTo(30)
            make.centerY.equalTo(backIcon)
        }
    }
}

extension DDPublicSearchNav : UITextFieldDelegate  {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        if textField.text?.count == 0 {
            GDAlertView.alert("搜索内容不能为空", image: nil, time: 2, complateBlock: nil)
            return false
        }
        self.delegate?.performAction(actionType: DDPublicSearchNav.PublicSearchBarActionType.certain)
        return true
    }
}

extension DDPublicSearchNav {
    
    @objc func actionClick(sender : UIControl){
        switch sender  {
        case backIcon:
            self.delegate?.performAction(actionType: DDPublicSearchNav.PublicSearchBarActionType.back)
        case searchBox:
            self.delegate?.performAction(actionType: DDPublicSearchNav.PublicSearchBarActionType.search)
        case certainIcon:
            self.delegate?.performAction(actionType: DDPublicSearchNav.PublicSearchBarActionType.certain)
        default:
            break
        }
    }
    
}
