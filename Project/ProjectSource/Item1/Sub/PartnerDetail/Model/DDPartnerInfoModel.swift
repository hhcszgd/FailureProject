//
//  DDPartnerInfoModel.swift
//  Project
//
//  Created by WY on 2018/4/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerInfoModel: NSObject,Codable {
    var id = ""
    var nickname : String?
    var head_images : String?
    var name : String?
    var mobile  :String?
    ///1为好友 0为陌生人
    var is_friends : String? 
}
