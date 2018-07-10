//
//  DDPublicNav.swift
//  Project
//
//  Created by 金曼立 on 2018/5/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit

protocol DDPublicNavDelegate : NSObjectProtocol {
    func performAction(actionType: DDPublicNav.PublicBarActionType)
}

class DDPublicNav: UIView {
    
    enum PublicBarActionType{
        // 发布
        case post
        // 搜索
        case search
    }
    
    weak var delegate  : DDPublicNavDelegate?

    let navBg = UIView()
    let titleLab = UILabel()
    let postBtn = UIButton()
    let searchBox = DDSearchBar.init(frame: CGRect.zero, placeholder: "搜索", fontPh: 15)
    let coverBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        self.backgroundColor = UIColor.DDThemeColor
        navBg.backgroundColor = UIColor.DDThemeColor
        
        titleLab.text = "公开约定"
        titleLab.font = UIFont.boldSystemFont(ofSize: 17)
        titleLab.textColor = UIColor.white
        postBtn.setTitle("发布", for: UIControlState.normal)
        postBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        postBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        postBtn.addTarget(self, action: #selector(postBtnClick), for: UIControlEvents.touchUpInside)
        coverBtn.addTarget(self, action: #selector(coverBtnClick), for: UIControlEvents.touchUpInside)
        searchBox.isUserInteractionEnabled = false
//        searchBox.placeholder = "搜索"
        self.addSubview(navBg)
        navBg.addSubview(titleLab)
        navBg.addSubview(postBtn)
        self.addSubview(searchBox)
        self.addSubview(coverBtn)
        
        navBg.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(DDNavigationBarHeight)
        }
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalTo((DDNavigationBarHeight - DDnavigationStateHeight) / 2 + DDnavigationStateHeight)
            make.centerX.equalToSuperview()
        }
        postBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.top.equalTo(titleLab)
        }
        searchBox.snp.makeConstraints { (make) in
            make.top.equalTo(navBg.snp.bottom)
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        coverBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(searchBox)
        }
    }
    
    @objc func postBtnClick() {
        self.delegate?.performAction(actionType: DDPublicNav.PublicBarActionType.post)
    }
    
    @objc func coverBtnClick() {
        self.delegate?.performAction(actionType: DDPublicNav.PublicBarActionType.search)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
