//
//  DDEarnerResultVC.swift
//  Project
//
//  Created by 金曼立 on 2018/4/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDEarnerResultVC: DDNormalVC {

    var result : Bool = true
    let imageView = UIImageView()
    let label = UILabel()
    let buttonBg = UIButton()
    var dict : [String : String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dict = self.userInfo as? [String : String]
        
        self.view.addSubview(imageView)
        self.view.addSubview(label)
        self.view.addSubview(buttonBg)
        label.textAlignment = .center
        label.textColor = UIColor.DDTitleColor
        label.isUserInteractionEnabled = true
        buttonBg.backgroundColor = UIColor.clear
        buttonBg.addTarget(self, action: #selector(buttonBgClick), for: UIControlEvents.touchUpInside)
        
        if result {
            successLayout()
        }
    }
    
    @objc func buttonBgClick(_ sender: UIButton) {
        let para  = ["lenders" : dict?["lenders"] ?? "",
                     "orderid" : dict?["orderid"] ?? "",
                     "num" : dict?["num"] ?? "",
                     "yue_type" : dict?["yue_type"] ?? "",
                     "bid" : dict?["bid"] ?? ""]
        self.navigationController?.pushVC(vcIdentifier: "DDPayPartnersDetailVC", userInfo: self.dict)
    }
    
    func successLayout() {
        self.title = "付款成功"
        
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let str1 : NSAttributedString = NSAttributedString(string: "本次放款成功！可点击查看", attributes: [NSAttributedStringKey.foregroundColor : color11, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        let str2 : NSAttributedString = NSAttributedString(string: "报酬详情", attributes: [NSAttributedStringKey.underlineStyle : 1, NSAttributedStringKey.foregroundColor : color11, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        attributedStrM.append(str1)
        attributedStrM.append(str2)
        label.attributedText = attributedStrM
        
        imageView.image = UIImage(named:"successicon")
        let iamgeViewWH : CGFloat = 160
        imageView.frame = CGRect(x: (self.view.bounds.width - iamgeViewWH ) / 2, y: 200, width: iamgeViewWH, height: iamgeViewWH)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        buttonBg.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(label)
            make.width.equalTo(70)
        }
        label.frame = CGRect(x: 0, y:imageView.frame.maxY + 20 , width: self.view.bounds.width, height: 40)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
