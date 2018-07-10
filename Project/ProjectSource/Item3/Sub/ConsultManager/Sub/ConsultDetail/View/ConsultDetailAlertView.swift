//
//  ConsultDetailAlertView.swift
//  Project
//
//  Created by wy on 2018/5/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ConsultDetailAlertView: UIView {

    @IBOutlet var payPrice: UILabel!
    
    @IBOutlet var returnPrice: UILabel!
    
    @IBAction func cancleAction(_ sender: UIButton) {
        self.finished?(false)
    }
    @IBAction func sureAction(_ sender: UIButton) {
        self.finished?(true)
    }
    var finished: ((Bool) -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.containerView = Bundle.main.loadNibNamed("ConsultDetailAlertView", owner: self, options: nil)?.last as! UIView
        self.addSubview(self.containerView)
        self.containerView.layer.borderColor = UIColor.colorWithHexStringSwift("6a96fc").cgColor
        self.containerView.layer.borderWidth = 1
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = self.bounds
    }
    var containerView: UIView!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
