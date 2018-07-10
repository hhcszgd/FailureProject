//
//  CustomDetailModel.swift
//  zuidilao
//
//  Created by wy on 2017/10/29.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit

class CustomDetailModel: GDModel {
    var arrowHidden: Bool = false
    var leftImage: UIImage?
    var leftTitle: String?
    var leftTitleColor: UIColor = UIColor.red
    var rightDetailTitle: String?
    var rightImage: UIImage?
    var leftTitleFont: UIFont?
    var rightDetailTitleFont: UIFont?
    var rightDetailTitleColor: UIColor = UIColor.red
    var lineHidden: Bool = true
    var switchHiden: Bool = true
    var action: String?
    var leftSubTitle: String?
    var left: CGFloat?
    var isOn: Bool = false
    var subTitleColor: UIColor = ashColor
    
//    class func configModel(action: String?, leftImage: UIImage?, leftTitle: String?, rightDetailTitle: String?, rightImage: UIImage?, arrowHidden: Bool, lineHidden: Bool, switchHidden: Bool) -> CustomDetailModel {
//        let model = CustomDetailModel.init()
//        model.arrowHidden = arrowHidden
//        model.leftImage = leftImage
//        model.leftTitle = leftTitle
//        model.rightDetailTitle = rightDetailTitle
//        model.rightImage = rightImage
//        model.lineHidden = lineHidden
//        model.switchHiden = switchHidden
//        model.action = action
//        model.actionKey = action
//        return model
//    }
}
