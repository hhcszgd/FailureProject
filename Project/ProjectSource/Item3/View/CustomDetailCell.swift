//
//  CustomDetailCell.swift
//  zuidilao
//
//  Created by wy on 2017/10/28.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
let arrowW: CGFloat = 6
class CustomDetailCell: UIControl {
    var subTitleColor: UIColor? {
        didSet{
            self.leftTitleSubLabel.textColor = subTitleColor
        }
    }
    var leftImage: UIImage? {
        didSet{
            self.leftImageView.image = leftImage
        }
    }
    var leftTitle: String? {
        didSet{
            self.leftTitleLabel.text = leftTitle
        }
    }
    var leftTitleColor: UIColor?{
        didSet{
            self.leftTitleLabel.textColor = leftTitleColor
        }
    }
    var rightDetailTitle: String? {
        didSet{
            self.rightDetailTitleLabel.text = rightDetailTitle
        }
    }
    var rightImage: UIImage? {
        didSet{
            self.rightImageView.image = rightImage
        }
    }
    var leftTitleFont: UIFont? {
        didSet{
            self.leftTitleLabel.font = leftTitleFont
        }
    }
    var rightDetailTitleFont: UIFont? {
        didSet{
            self.rightDetailTitleLabel.font = rightDetailTitleFont
        }
    }
    var rightDetailTitleColor: UIColor? {
        didSet{
            self.rightDetailTitleLabel.textColor = rightDetailTitleColor
        }
    }
    
    var switchHidden: Bool? {
        didSet {
            self.rightSwitch.isHidden = switchHidden ?? true
        }
    }
    
    var lineHidden: Bool? {
        didSet{
            self.bottomLine.isHidden = lineHidden ?? false
        }
    }
    var leftSubTitle: String? {
        didSet{
            self.leftTitleSubLabel.text = leftSubTitle
        }
    }
    var arrowHidden: Bool = true
    let textToImgMargin: CGFloat = 12
    
    
    
    
   
    func configmentView(model: CustomDetailModel) {
        Actionkey(rawValue: "")
    }
    
    
    
    func setUI() {
        
        self.leftImageView.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        self.leftTitleLabel.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        self.leftTitleSubLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self.leftTitleLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        self.arrowToRight.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        self.rightImageView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        self.rightDetailTitleLabel.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
        self.rightSwitch.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(53)
            make.height.equalTo(33)
        }
        
        self.rightSwitch.onImage = UIImage.init(named: "slide_on")
        self.rightSwitch.offImage = UIImage.init(named: "slide_off")
        self.rightSwitch.onTintColor = UIColor.red
        self.rightSwitch.tintColor = UIColor.yellow
        self.bottomLine.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(left)
            make.right.equalToSuperview().offset(-left)
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var model: CustomDetailModel? {
        didSet{
            self.leftImage = model?.leftImage
            self.leftTitle = model?.leftTitle
            self.leftTitleColor = model?.leftTitleColor
            self.rightDetailTitle = model?.rightDetailTitle
            self.rightImage = model?.rightImage
            self.leftTitleFont = model?.leftTitleFont
            self.rightDetailTitleFont = model?.rightDetailTitleFont
            self.rightDetailTitleColor = model?.rightDetailTitleColor
            self.arrowHidden = (model?.arrowHidden)!
            self.lineHidden = (model?.lineHidden)!
            self.switchHidden = model?.switchHiden
            self.leftSubTitle = model?.leftSubTitle
            self.subTitleColor = model?.subTitleColor
            self.left = model?.left ?? 27
            self.updateUI()
        }
    }
    
    var left: CGFloat = 27
    func updateUI() {
        self.bottomLine.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(left)
            make.right.equalToSuperview().offset(-left)
        }
        //布局左边
        if let title: String = self.leftTitle, let image = self.leftImage, title.characters.count > 0 {
            let imgW = image.size.width
            let imgH = image.size.height
            self.leftImageView.snp.updateConstraints({ (make) in
                make.left.equalToSuperview().offset(left)
                make.centerY.equalToSuperview()
                make.width.equalTo(imgW)
                make.height.equalTo(imgH)
            })
            self.leftTitleLabel.snp.updateConstraints({ (make) in
                make.left.equalToSuperview().offset(textToImgMargin + left + imgW)
                make.centerY.equalToSuperview()
            })
            
            self.leftImageView.isHidden = false
            self.leftTitleLabel.isHidden = false
        }else if let image = self.leftImage {
            let imgW = image.size.width
            let imgH = image.size.height
            self.leftImageView.snp.updateConstraints({ (make) in
                make.left.equalToSuperview().offset(left)
                make.centerY.equalToSuperview()
                make.width.equalTo(imgW)
                make.height.equalTo(imgH)
            })
           
            self.leftImageView.isHidden = false
            self.leftTitleLabel.isHidden = true
            self.leftTitleSubLabel.isHidden = true
        }else if let title: String = self.leftTitle, title.characters.count > 0, let subTitle = self.leftSubTitle, subTitle.characters.count > 0{
            self.leftTitleLabel.snp.updateConstraints({ (make) in
                make.left.equalToSuperview().offset(left)
                make.centerY.equalToSuperview()
            })
            
            self.leftTitleLabel.isHidden = false
            self.leftTitleSubLabel.isHidden = false
            self.leftImageView.isHidden = true
        }else if let title: String = self.leftTitle, title.characters.count > 0{
            self.leftTitleLabel.snp.updateConstraints({ (make) in
                make.left.equalToSuperview().offset(left)
                make.centerY.equalToSuperview()
            })
            self.leftTitleLabel.isHidden = false
            self.leftImageView.isHidden = true
        }
        
        
        //右侧布局
        if arrowHidden {
            //箭头隐藏
            self.arrowToRight.isHidden = true
            if let image = self.rightImage {
                let imgW = image.size.width
                let ImgH = image.size.height
              
                self.rightImageView.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(-12)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(imgW)
                    make.height.equalTo(ImgH)
                })
                self.rightImageView.isHidden = false
                self.rightDetailTitleLabel.isHidden = true
            }else if let title = self.rightDetailTitle {
                
                self.rightDetailTitleLabel.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(-12)
                    make.centerY.equalToSuperview()
                })
                self.rightDetailTitleLabel.text = title
                self.rightImageView.isHidden = true
                self.rightDetailTitleLabel.isHidden = false
            }
            
        }else {
            self.arrowToRight.isHidden = false
            if let image = self.rightImage {
                let imgW = image.size.width
                let ImgH = image.size.height
                self.rightImageView.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(-12 - arrowW - textToImgMargin)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(imgW)
                    make.height.equalTo(ImgH)
                })
                
                self.rightImageView.isHidden = false
                self.rightDetailTitleLabel.isHidden = true
                
            }else if let title = self.rightDetailTitle {
                self.rightDetailTitleLabel.snp.updateConstraints({ (make) in
                    make.right.equalToSuperview().offset(-12 - arrowW - textToImgMargin)
                    make.centerY.equalToSuperview()
                })
                
                self.rightImageView.isHidden = true
                self.rightDetailTitleLabel.isHidden = false
            }
            
            
        }
    }
    
    
    @objc func switchAction(btn: UISwitch) {
        if btn.isOn {
            btn.isOn = true
        }else {
            btn.isOn = false
        }
    }
    
    
    
    
    
    lazy var customBackgroundImageView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(view)
        return view
    }()
    
    lazy var leftImageView: UIImageView = {
        let view = UIImageView.init()
        view.contentMode = UIViewContentMode.scaleToFill
        self.addSubview(view)
        return view
    }()
    lazy var leftTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.colorWithHexStringSwift("3a3a3a")
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()
    lazy var leftTitleSubLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.left
        label.font = font13
        label.textColor = color3
        label.sizeToFit()
        self.addSubview(label)
        return label
    }()
    lazy var rightDetailTitleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.colorWithHexStringSwift("e6e6e6")
        self.addSubview(label)
        return label
    }()
    lazy var rightImageView: UIImageView = {
        let view = UIImageView.init()
        self.addSubview(view)
        return view
    }()
    lazy var arrowToRight: UIImageView = {
        let image = UIImageView.init()
        image.image = UIImage.init(named: "enterthearrow")
        self.addSubview(image)
        return image
    }()
    lazy var bottomLine: UIView = {
       let view = UIView.init()
        view.backgroundColor = UIColor.colorWithHexStringSwift("e2e2e2")
        self.addSubview(view)
        return view
    }()
    lazy var rightSwitch: UISwitch = {
        let cc = UISwitch.init()
        self.addSubview(cc)
        cc.addTarget(self, action: #selector(switchAction(btn:)), for: .touchUpInside)
        return cc
    }()
    
    
    
    
    
}




