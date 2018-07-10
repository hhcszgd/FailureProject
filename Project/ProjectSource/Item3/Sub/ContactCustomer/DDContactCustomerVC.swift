//
//  DDContactCustomerVC.swift
//  Project
//
//  Created by 金曼立 on 2018/6/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDContactCustomerVC: GDNormalVC {
    
    let view1 = DDSubView()
    let view2 = DDSubView()
    let view3 = DDSubView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "联系客服")
        self.view.backgroundColor = UIColor.colorWithHexStringSwift("f2f2f2")
        
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        self.view.addSubview(view3)
        
        view1.frame = CGRect(x: 15, y : DDNavigationBarHeight + 15, width: SCREENWIDTH - 30, height: 40)
        view2.frame = CGRect(x: 15, y : view1.frame.maxY + 1, width: SCREENWIDTH - 30, height: 40)
        view3.frame = CGRect(x: 15, y : view2.frame.maxY + 1, width: SCREENWIDTH - 30, height: 40)
        
        view1.title.text = "24小时服务热线"
        view2.title.text = "一把通官网"
        view3.title.text = "联系邮箱"
        view1.info.text = "58090191-7022"
        view2.info.text = "http://appointm.ybt186.com/"
        view3.info.text = "zhaoyaqiong16@126.com"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class DDSubView: UIView {
    
    let title = UILabel()
    let info = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(title)
        self.addSubview(info)
        
        title.frame = CGRect(x: 15, y : 10, width: (SCREENWIDTH - 60) / 2, height: 20)
        info.frame = CGRect(x: title.frame.maxX - 20, y : 10, width: (SCREENWIDTH - 60) / 2 + 20, height: 20)
        title.font = UIFont.boldSystemFont(ofSize: 14)
        info.font = UIFont.systemFont(ofSize: 12)
        info.textAlignment = NSTextAlignment.right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
