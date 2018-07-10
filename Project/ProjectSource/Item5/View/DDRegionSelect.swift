//
//  DDRegionSelect.swift
//  Project
//
//  Created by 金曼立 on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import SnapKit
class DDRegionSelect:UIView {
    
    let closeBtn = UIButton()
    var callBack:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let bgView = UIView()
        let regionLal = UILabel()
        let lineView = UIView()
        
        lineView.backgroundColor = UIColor.colorWithHexStringSwift("#f2f2f2")
        regionLal.text = "区域"
        closeBtn.setImage(UIImage.init(named:"shut_down_icon"), for: UIControlState.normal)
        closeBtn.addTarget(self, action:#selector(tapClick(sender:)) , for: UIControlEvents.touchUpInside)
        
        self.addSubview(bgView)
        bgView.addSubview(regionLal)
        bgView.addSubview(closeBtn)
        bgView.addSubview(lineView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        regionLal.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(regionLal)
            make.width.height.equalTo(20)
            make.right.equalToSuperview().offset(-8)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(closeBtn.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc func tapClick(sender : UIControl){
        callBack?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
