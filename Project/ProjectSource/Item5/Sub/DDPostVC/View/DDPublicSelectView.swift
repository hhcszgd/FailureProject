//
//  DDPublicSelectView.swift
//  Project
//
//  Created by 金曼立 on 2018/4/12.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
class DDPublicSelectView: UIView {
    
    var btnCallBack:((_ type: PublicstartActionType) -> ())?
    
    enum PublicstartActionType{
        case anyTime
        case allPeople
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.white
        
        let arr = ["随时开始", "人满开始"]
        let H = frame.size.height / CGFloat(arr.count)
        
        for index in 0..<arr.count {
            let Y = CGFloat(index) * H
            let btn = UIButton.init(frame: CGRect(x: 0, y: Y, width: SCREENWIDTH , height: H))
            self.addSubview(btn)
            btn.setTitle(arr[index] as? String, for: UIControlState.normal)
            btn.setTitleColor(color11, for: UIControlState.normal)
            btn.tag = index
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: UIControlEvents.touchUpInside)
        }
        
    }
    
    @objc func btnClick(sender: UIButton){
        switch sender.tag  {
        case 0:
            btnCallBack?(PublicstartActionType.anyTime)
        case 1:
            btnCallBack?(PublicstartActionType.allPeople)
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
