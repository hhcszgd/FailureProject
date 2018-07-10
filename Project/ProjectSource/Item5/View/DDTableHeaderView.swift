//
//  DDTableHeaderView.swift
//  Project
//
//  Created by 金曼立 on 2018/4/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
import SnapKit

class DDTableHeaderView: UIView {
    
    var pictureViewCallBack:((_ index: NSInteger) -> ())?
    var btnCallBack:((_ type: PublicHeaderViewActionType) -> ())?
    
    var models : [DDHomeBannerModel] = [DDHomeBannerModel](){
        didSet{
            self.pictureView.models = models
        }
    }
    let pictureView = DDLeftRightAutoScroll.init(frame: CGRect.zero)
    weak var delegate : BannerAutoScrollViewActionDelegate?
    
    let regionView = UIView()
    let lineView = UIView()
    let newAppoint = UIButton()
    let start = UIButton()
    let region = UIButton()
    var btnSelect : UIButton?
    
    enum PublicHeaderViewActionType{
        // 最新约定
        case newAppoint
        // 即将开始
        case start
        // 区域
        case region
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        newAppoint.isSelected = true
        btnSelect = newAppoint
        pictureView.delegate = self
        self.addSubview(pictureView)
        
        self.configView()
    }
    
    func configView() {
        newAppoint.setTitle("最新约定", for: UIControlState.normal)
        newAppoint.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        newAppoint.setTitleColor(UIColor.DDThemeColor, for: UIControlState.selected)
        newAppoint.setTitleColor(UIColor.black, for: UIControlState.normal)
        newAppoint.addTarget(self, action:#selector(btnClick(sender:)) , for: UIControlEvents.touchUpInside)
        start.setTitle("即将开始", for: UIControlState.normal)
        start.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        start.addTarget(self, action:#selector(btnClick(sender:)) , for: UIControlEvents.touchUpInside)
        start.setTitleColor(UIColor.DDThemeColor, for: UIControlState.selected)
        start.setTitleColor(UIColor.black, for: UIControlState.normal)
        region.setTitle("区域", for: UIControlState.normal)
        region.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        region.addTarget(self, action:#selector(btnClick(sender:)) , for: UIControlEvents.touchUpInside)
        region.setTitleColor(UIColor.DDThemeColor, for: UIControlState.highlighted)
        region.setTitleColor(UIColor.black, for: UIControlState.normal)
    }
    
    @objc func btnClick(sender : UIControl){
        switch sender  {
        case newAppoint:
            btnCallBack?(PublicHeaderViewActionType.newAppoint)
            btnSelect?.isSelected = false
            newAppoint.isSelected = true
            btnSelect = newAppoint
        case start:
            btnCallBack?(PublicHeaderViewActionType.start)
            btnSelect?.isSelected = false
            start.isSelected = true
            btnSelect = start
        case region:
            btnCallBack?(PublicHeaderViewActionType.region)
        default:
            break
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pictureView.frame = CGRect(x:0  , y: 0  , width : SCREENWIDTH , height : 175)
        regionView.backgroundColor = UIColor.white
        self.addSubview(regionView)
        lineView.backgroundColor = UIColor.lightGray
        
        regionView.addSubview(newAppoint)
        regionView.addSubview(start)
        regionView.addSubview(region)
        regionView.addSubview(lineView)
        
        regionView.snp.makeConstraints { (make) in
            make.top.equalTo(pictureView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        newAppoint.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
//            make.right.equalTo(start.snp.left).offset(-40)
            make.width.equalTo(80)
            make.bottom.equalToSuperview().offset(-15)
        }
//        start.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(15)
//            make.left.equalTo(newAppoint.snp.right).offset(40)
//            make.bottom.equalToSuperview().offset(-15)
//        }
        region.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DDTableHeaderView : BannerAutoScrollViewActionDelegate{
    
    func performBannerAction(indexPath : IndexPath) {
        self.pictureViewCallBack?(indexPath.row)
    }
}
