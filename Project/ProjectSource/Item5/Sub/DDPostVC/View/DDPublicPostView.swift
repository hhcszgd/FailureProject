//
//  DDPublicPostView.swift
//  Project
//
//  Created by 金曼立 on 2018/5/10.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import SnapKit
class DDPublicPostView: UIView {
    
    enum PublicPostActionType{
        case region
        case start
        case valid
        case pay
    }
    
    var btnCallBack:((_ actionType: PublicPostActionType) -> ())?
    
    let margin = 15
    let cellW = SCREENWIDTH - 30
    let cellH = 40
    
    let scrollBg = UIScrollView()
    let appointNameBg = DDPostTextFieldView.init(frame: CGRect.zero, title: "公开任务名称", detail: "约定名称")
    var requtietBg = DDPostTextView.init(frame: CGRect.zero)
    var moneyBg = DDPostTextFieldView.init(frame: CGRect.zero, title: "报酬", detail: "", menu: "元/人")
    var regionBg = DDPostWithIndicatorView.init(frame: CGRect.zero, title: "工作区域", detail: "请设置")
    var peopleNumBg = DDPostTextFieldView.init(frame: CGRect.zero, title: "需求人数", detail: "", menu: "人")
    var startBg = DDPostWithIndicatorView.init(frame: CGRect.zero, title: "何时开始", detail: "人满开始")
    var earnerBg = DDPostWithIndicatorView.init(frame: CGRect.zero, title: "方式", detail: "手动")
    var numberBg = DDPostTextFieldView.init(frame: CGRect.zero, title: "数量", detail: "", menu: "期")
    var validNumBg = DDPostWithIndicatorView.init(frame: CGRect.zero, title: "公开约定有效期", detail: "30天")
    var amountBg = DDPostAmountView.init(frame: CGRect.zero)
    var payButton : UIButton = UIButton()
    
    var postDelegate : UIViewController? {
        didSet{
            scrollBg.delegate = postDelegate as? UIScrollViewDelegate
            appointNameBg.detailField.delegate = postDelegate as? UITextFieldDelegate
            requtietBg.textView.delegate = postDelegate as? UITextViewDelegate
            moneyBg.detailField.delegate = postDelegate as? UITextFieldDelegate
            peopleNumBg.detailField.delegate = postDelegate as? UITextFieldDelegate
            numberBg.detailField.delegate = postDelegate as? UITextFieldDelegate
            
            moneyBg.detailField.keyboardType = UIKeyboardType.decimalPad
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        scrollBg.contentSize = CGSize(width: SCREENWIDTH, height: SCREENHEIGHT)
        if DDDevice.type == .iPhone5 {
            scrollBg.contentSize = CGSize(width: SCREENWIDTH, height: SCREENHEIGHT + 120)
        } else if DDDevice.type == .iPhone4 {
            scrollBg.contentSize = CGSize(width: SCREENWIDTH, height: SCREENHEIGHT * 1.5)
        }
        regionBg.coverBtn.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        startBg.detailLab.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
        startBg.coverBtn.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        earnerBg.detailLab.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
        validNumBg.coverBtn.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        validNumBg.detailLab.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
        payButton.backgroundColor = UIColor.DDThemeColor
        payButton.setTitle("创建", for: UIControlState.normal)
        payButton.addTarget(self, action: #selector(buttonClick(sender:)), for: UIControlEvents.touchUpInside)
        
        configLayout()
    }
    
    @objc func buttonClick(sender: UIButton) {
        
        switch sender {
        case regionBg.coverBtn:
            btnCallBack?(DDPublicPostView.PublicPostActionType.region)
        case startBg.coverBtn:
            btnCallBack?(DDPublicPostView.PublicPostActionType.start)
        case validNumBg.coverBtn:
            btnCallBack?(DDPublicPostView.PublicPostActionType.valid)
        case payButton:
            btnCallBack?(DDPublicPostView.PublicPostActionType.pay)
        default:
            break
        }
    }
    
    func configLayout() {
        
        self.addSubview(scrollBg)
        scrollBg.addSubview(appointNameBg)
        scrollBg.addSubview(requtietBg)
        scrollBg.addSubview(moneyBg)
        scrollBg.addSubview(regionBg)
        scrollBg.addSubview(peopleNumBg)
        scrollBg.addSubview(startBg)
        scrollBg.addSubview(earnerBg)
        scrollBg.addSubview(numberBg)
        scrollBg.addSubview(validNumBg)
        scrollBg.addSubview(amountBg)
        scrollBg.addSubview(payButton)
        
        scrollBg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        appointNameBg.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.width.equalTo(SCREENWIDTH - 30)
            make.height.equalTo(40)
        }
        requtietBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(appointNameBg.snp.bottom).offset(1)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(156)
        }
        moneyBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(requtietBg.snp.bottom).offset(1)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        regionBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(moneyBg.snp.bottom).offset(1)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        peopleNumBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(regionBg.snp.bottom).offset(1)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        startBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(peopleNumBg.snp.bottom).offset(1)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        earnerBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(startBg.snp.bottom).offset(1)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        numberBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(earnerBg.snp.bottom).offset(1)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        validNumBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(numberBg.snp.bottom).offset(10)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        amountBg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(validNumBg.snp.bottom).offset(10)
            make.width.equalTo(appointNameBg)
            make.height.equalTo(40)
        }
        payButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(amountBg.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.width.equalTo(200)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DDPostTextFieldView: UIView {
    
    let titleLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    let detailField = UITextField()
    let menuLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    
    init(frame: CGRect, title: String?, detail: String?, menu: String?) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(titleLab)
        self.addSubview(detailField)
        self.addSubview(menuLab)
        
        self.frame = frame
        titleLab.text = title ?? ""
        detailField.placeholder = detail ?? ""
        detailField.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
        detailField.font = UIFont.systemFont(ofSize: 14)
        detailField.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
        detailField.setValue(UIColor.colorWithRGB(red: 204, green: 204, blue: 204), forKeyPath: "_placeholderLabel.textColor")
        detailField.textAlignment = NSTextAlignment.right
        detailField.keyboardType = UIKeyboardType.numberPad
        menuLab.text = menu ?? ""
        menuLab.textAlignment = NSTextAlignment.right
        
        let titleMaxW = (SCREENWIDTH - 60) / 2
        let titleSize = title?.sizeWith(font: UIFont.systemFont(ofSize: 15), maxWidth: titleMaxW)
        let titleW = (titleSize?.width ?? titleMaxW) + 10
        
        let menuMaxW : CGFloat = 30.0
        let menuSize = menu?.sizeWith(font: UIFont.systemFont(ofSize: 14), maxWidth: menuMaxW)
        let menuW = (menuSize?.width ?? menuMaxW) + 15
        
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(titleW)
        }
        detailField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLab.snp.right).offset(10)
            make.right.equalTo(menuLab.snp.left).offset(-10)
        }
        menuLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(menuW)
        }
    }
    
    init(frame: CGRect, title: String?, detail: String?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(titleLab)
        self.addSubview(detailField)
        
        titleLab.text = title ?? ""
        detailField.placeholder = detail ?? ""
        detailField.font = UIFont.systemFont(ofSize: 14)
        detailField.textColor = UIColor.colorWithRGB(red: 51, green: 51, blue: 51)
        detailField.textAlignment = NSTextAlignment.right
        detailField.setValue(UIFont.systemFont(ofSize: 14), forKeyPath: "_placeholderLabel.font")
        detailField.setValue(UIColor.colorWithRGB(red: 204, green: 204, blue: 204), forKeyPath: "_placeholderLabel.textColor")
        
        let titleMaxW = (SCREENWIDTH - 60) / 2
        let titleSize = title?.sizeWith(font: UIFont.systemFont(ofSize: 15), maxWidth: titleMaxW)
        let titleW = (titleSize?.width ?? titleMaxW) + 10
        
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(titleW)
        }
        detailField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLab.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DDPostWithIndicatorView: UIView {
    
    let titleLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    let detailLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "")
    let indicatorImg = UIImageView()
    let coverBtn = UIButton()
    
    init(frame: CGRect, title: String?, detail: String?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(titleLab)
        self.addSubview(detailLab)
        self.addSubview(indicatorImg)
        self.addSubview(coverBtn)
        
        self.frame = frame
        titleLab.text = title ?? ""
        detailLab.text = detail ?? ""
        detailLab.textAlignment = NSTextAlignment.right
        detailLab.textColor = UIColor.colorWithRGB(red: 204, green: 204, blue: 204)
        indicatorImg.image = UIImage(named:"enterthearrow")
        
        let titleMaxW = (SCREENWIDTH - 60) / 2
        let titleSize = title?.sizeWith(font: UIFont.systemFont(ofSize: 15), maxWidth: titleMaxW)
        let titleW = (titleSize?.width ?? titleMaxW) + 10
        
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(titleW)
        }
        indicatorImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(8.5)
            make.height.equalTo(15)
        }
        detailLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(indicatorImg.snp.left).offset(-10)
            make.left.equalTo(titleLab.snp.right).offset(10)
        }
        coverBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DDPostTextView: UIView {
    
    let titleLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "公开任务约定要求")
    let textView = UITextView()
    let placeHolderLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "请简要叙述您发布的工作任务的招工要求")
    let wordNumLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "0/200")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLab)
        self.addSubview(textView)
        self.addSubview(placeHolderLab)
        self.addSubview(wordNumLab)

        self.backgroundColor = UIColor.white
        textView.backgroundColor = UIColor.colorWithRGB(red: 245, green: 245, blue: 245)
        placeHolderLab.textColor = UIColor.colorWithRGB(red: 153, green: 153, blue: 153)
        wordNumLab.textColor = UIColor.colorWithRGB(red: 153, green: 153, blue: 153)
        
        titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
        placeHolderLab.snp.makeConstraints { (make) in
            make.left.equalTo(textView).offset(4)
            make.top.equalTo(textView).offset(8)
        }
        wordNumLab.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(textView).offset(-2)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DDPostAmountView: UIView {
    
    let titleLab = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 51, green: 51, blue: 51), text: "合计：")
    let amountNum = UILabel.configlabel(font: UIFont.systemFont(ofSize: 15), textColor: UIColor.colorWithRGB(red: 228, green: 10, blue: 10), text: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLab)
        self.addSubview(amountNum)
        
        self.backgroundColor = UIColor.clear
        
        let titleMaxW = (SCREENWIDTH - 60) / 2
        let titleSize = titleLab.text?.sizeWith(font: UIFont.systemFont(ofSize: 15), maxWidth: titleMaxW)
        let titleW = (titleSize?.width ?? titleMaxW) + 10
        
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(titleW)
        }
        amountNum.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(titleLab.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
