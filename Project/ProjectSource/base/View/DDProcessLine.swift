//
//  DDProcessLine.swift
//  Project
//
//  Created by WY on 2018/3/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDProcessLine: UIView {
    /// 0 ~ 1
    var progress : CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.height/2
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        path.lineWidth = self.bounds.height
        UIColor.orange.setStroke()
        path.lineCapStyle = .round
        if progress > 0  {
            path.move(to: CGPoint(x:self.bounds.height / 2 , y: self.bounds.height / 2   ))
            path.addLine(to: CGPoint(x: (self.bounds.width -  self.bounds.height/2 ) * self.progress, y: self.bounds.height / 2))
            
        }
//        path.close()
//        UIColor.orange.setFill()
        path.fill()
        path.stroke()
    }
//    override func draw(_ layer: CALayer, in ctx: CGContext) {
//
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
