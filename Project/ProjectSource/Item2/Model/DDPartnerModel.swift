//
//  DDPartnerModel.swift
//  Project
//
//  Created by WY on 2018/4/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerModel: DDUserBaseModel ,Codable , NSMutableCopying{
    func mutableCopy(with zone: NSZone? = nil) -> Any {
        let temp = DDPartnerModel()
        temp.head_images = self .head_images
        temp.id = self.id
        temp.nickname = nickname
        return temp
    }
    
    var nickname = ""
    var id = ""
    var head_images : String?
    var mobile : String?
}
