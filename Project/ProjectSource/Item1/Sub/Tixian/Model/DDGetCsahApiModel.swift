//
//  DDGetCsahApiModel.swift
//  Project
//
//  Created by WY on 2018/1/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
class DDGetCsahApiDataModel: NSObject , Codable{
    var balance : String? = ""
    var bank_logo : String?
    var bank_name : String?
    var id : String?
    var number : String?
}

class DDGetCashPageDataModel: NSObject , Codable    {
    ///储蓄卡
    var type : String? = ""
    var bankicon : String?
    var bank : String?
    var id : String?
    var card_number : String?
    var balance : String? = ""
    var icon : String?
    ///绑定手机
    var mobile : String?
    
    ///是否已经设置支付密码 , 2 已设置
    var status : String?
}
