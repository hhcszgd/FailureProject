//
//  DDEarnerBottomView.swift
//  Project
//
//  Created by 金曼立 on 2018/4/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDEarnerBottomView: UIView {
    
    var bottomViewCallBack:(() -> ())?
    
    let peopleLab = UILabel()
    let peopleNumLab = UILabel()
    let priceLab = UILabel()
    let priceNumLab = UILabel()
    let earnerBtn = UIButton()
    
    var peopleNum : Int? {
        didSet{
            peopleNumLab.attributedText = self.attributedString(number: "\(peopleNum ?? 0)", string: "人")
        }
    }
    var priceNum : CGFloat? {
        didSet{
            let str = String(format: "%.2f", priceNum ?? 0.00)
            priceNumLab.attributedText = self.attributedString(number: str, string: "元")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        self.addSubview(peopleLab)
        self.addSubview(peopleNumLab)
        self.addSubview(priceLab)
        self.addSubview(priceNumLab)
        self.addSubview(earnerBtn)
        
        configView()
    }
    
    func configView() {
        peopleLab.text = "支出人数："
        peopleLab.font = UIFont.systemFont(ofSize: 15)
        priceLab.text = "本次应付报酬："
        priceLab.font = UIFont.systemFont(ofSize: 15)
        earnerBtn.addTarget(self, action: #selector(earnerBtnClick), for: UIControlEvents.touchUpInside)
        earnerBtn.setTitle("确定放款", for: UIControlState.normal)
        earnerBtn.backgroundColor = UIColor.DDThemeColor
    }
    
    @objc func earnerBtnClick() {
        bottomViewCallBack?()
    }
    
    func attributedString(number: String, string: String) -> NSMutableAttributedString {
        let peopleStr : NSMutableAttributedString = NSMutableAttributedString()
        let peopleStr1 = self.appendColorStrWithString(str: "\(number)", font: 15, color: UIColor.colorWithHexStringSwift("e60000"))
        let peopleStr2 = self.appendColorStrWithString(str: string, font: 15, color: color11)
        peopleStr.append(peopleStr1)
        peopleStr.append(peopleStr2)
        return peopleStr
    }
    func appendColorStrWithString(str: String, font: CGFloat, color: UIColor) -> NSAttributedString {
        let attStr = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: font),NSAttributedStringKey.foregroundColor:color])
        return attStr
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        peopleLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(17)
        }
        peopleNumLab.snp.makeConstraints { (make) in
            make.top.equalTo(peopleLab)
            make.left.equalTo(peopleLab.snp.right).offset(8)
        }
        priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(peopleLab.snp.bottom).offset(14)
            make.left.equalTo(peopleLab)
        }
        priceNumLab.snp.makeConstraints { (make) in
            make.top.equalTo(priceLab)
            make.left.equalTo(priceLab.snp.right).offset(8)
        }
        earnerBtn.snp.makeConstraints { (make) in
            make.width.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
