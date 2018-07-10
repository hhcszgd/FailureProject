//
//  SearchView.swift
//  wenyouhui
//
//  Created by wy on 2017/6/18.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit

class SearchView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    var rightImage: UIImage? {
        didSet{
            layoutSubviews()
        }
    }
    lazy var rightImageView = UIImageView.init()
    lazy var lineView: UIView = {
        let view = UIView.init()
        view.backgroundColor = color3
        return view
    }()
    var lineColor: UIColor = UIColor.init() {
        didSet{
            self.lineView.backgroundColor = lineColor
        }
    }
    var lineHeight: CGFloat = CGFloat(1.0) {
        didSet{
            layoutSubviews()
        }
    }
    var isShowVerfication: Bool = false {
        didSet{
            layoutSubviews()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in self.subviews {
            view.removeFromSuperview()
        }
        if let rightimage = self.rightImage {
            self.addSubview(self.rightImageView)
            let width = rightimage.size.width
            let height = rightimage.size.height
            self.rightImageView.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(12)
                make.centerY.equalToSuperview()
                make.width.equalTo(width)
                make.height.equalTo(height)
            })
           
            self.rightImageView.image = rightimage
            if isShowVerfication {
                self.addSubview(self.verification)
                self.addSubview(self.textField)
                
                let width = self.frame.size.width - self.verification.bounds.size.width - 10
                self.textField.frame = CGRect.init(x: 0, y: 0, width: width, height: self.frame.size.height - self.lineHeight)
                self.verification.snp.makeConstraints({ (make) in
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview()
                    make.width.equalTo(90 * SCALE)
                    make.height.equalTo(30 * SCALE)
                })
                self.textField.snp.makeConstraints({ (make) in
                    make.left.equalTo(self.rightImageView.snp.right).offset(12)
                    make.top.bottom.equalToSuperview()
                    make.right.equalTo(self.verification.snp.left).offset(-5)
                })
                
                
            }else {
                self.addSubview(self.textField)
                self.textField.snp.makeConstraints({ (make) in
                    make.left.equalTo(self.rightImageView.snp.right).offset(12)
                    make.top.bottom.equalToSuperview()
                    make.right.equalToSuperview().offset(-12)
                })
                
            }
            
        }
        
        
        self.addSubview(self.lineView)
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.lineHeight)
        }
        
        
    }
    lazy var verification: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("获取验证码", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setTitleColor(color1, for: UIControlState.selected)
        if let image = UIImage.ImageWithColor(color: color10, frame: CGRect.init(x: 0, y: 0, width: 90 * SCALE, height: 30 * SCALE)){
            btn.setBackgroundImage(image, for: UIControlState.normal)
        }
        if let image = UIImage.ImageWithColor(color: color9, frame: CGRect.init(x: 0, y: 0, width: 90 * SCALE, height: 30 * SCALE)){
            btn.setBackgroundImage(image, for: UIControlState.selected)
        }
        btn.adjustsImageWhenHighlighted = false
        btn.titleLabel?.font = font13
        btn.layer.cornerRadius = CGFloat(12)
        btn.layer.masksToBounds = true
        
        btn.addTarget(self, action: #selector(getVerification(btn:)), for: UIControlEvents.touchUpInside)
        return btn
    }()
    @objc func getVerification(btn: UIButton) {
        if phone != nil {
            //接口获取验证码
            //接口获取验证码
            let paramete: [String: AnyObject] = ["mobile": phone! as AnyObject, "type": Int(1) as AnyObject, "url": "getCode" as AnyObject]
            btn.isSelected = true
            btn.isUserInteractionEnabled = false
            
            
            
        }else {
            GDAlertView.alert("电话号码为空", image: nil, time: 1, complateBlock: nil)
        }
    }
    var phone: String?
    
    
    
    
    lazy var textField: UITextField = {
        let field = UITextField.init(frame: CGRect.zero)
        field.textAlignment = NSTextAlignment.left
        field.font =  font13
        field.textColor = color7
        
        return field
    }()
    var placeholderColor: UIColor = UIColor.black {
        didSet{
            self.textField.setValue(placeholderColor, forKey: "_placeholderLabel.textColor")
        }
    }
    var placeholderFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet{
            self.textField.setValue(placeholderFont, forKey: "_placeholderLabel.font")
        }
    }
    var textFieldFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet{
            self.textField.font = textFieldFont
        }
    }
    var placeholder: String = String() {
        didSet{
            self.textField.placeholder = placeholder
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
