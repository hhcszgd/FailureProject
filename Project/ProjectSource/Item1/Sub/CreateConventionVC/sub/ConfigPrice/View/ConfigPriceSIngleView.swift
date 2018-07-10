//
//  ConfigPriceSIngleView.swift
//  Project
//
//  Created by wy on 2018/4/17.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ConfigPriceSIngleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("ConfigPriceSIngleView", owner: self, options: nil)?.first as! UIView
        self.addSubview(self.containerView)
    }
    init(frame: CGRect, data: [DDUserModel]) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("ConfigPriceSIngleView", owner: self, options: nil)?.first as! UIView
        self.addSubview(self.containerView)
        if data.count == 1 {
            self.subTitleLabel.isHidden = true
            self.setLabel.isHidden = false
            self.nameLabel.text = data.first?.nickname
            self.nameLabel.isHidden = false
            self.rightLabel.isHidden = false
        }else {
            self.subTitleLabel.isHidden = false
            self.setLabel.isHidden = true
            self.nameLabel.isHidden = true
            self.rightLabel.isHidden = true
        }
        
        self.textfield.inputAccessoryView = self.addToolbar()
        
        
    }
    @objc func complete() {
        self.textfield.resignFirstResponder()
    }
    
    
    func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 35))
        toolbar.tintColor = UIColor.colorWithHexStringSwift("5585f1")
        toolbar.backgroundColor = UIColor.white
        let bar = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(complete))
        
        toolbar.items = [bar]
        return toolbar
    }
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var setLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    var containerView: UIView!
    
    @IBOutlet var textfield: UITextField!
    
    @IBOutlet var sureBtn: UIButton!
    @IBOutlet var cancleBtn: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
        
    }
    deinit {
        mylog("销毁++++++++")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
