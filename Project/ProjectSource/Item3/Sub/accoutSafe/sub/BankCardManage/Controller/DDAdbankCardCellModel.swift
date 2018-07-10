//
//  DDAdbankCardCellModel.swift
//  Project
//
//  Created by WY on 2018/1/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

//class DDAdbankCardCellModel: NSObject , Codable{
//    var data : [DDBankCardModel]?
//    var message = "";
//    var status : Int  = -1;
//}
class DDBankCardModel : NSObject , Codable {
    ///银行姓名
    var bank: String?
    ///bank logo
    var icon: String?
    /// bank id
    var id : String?
    ///银行卡0
    var card_number: String?
    ///背景图片
    var backicon: String?
    ///银行卡类型
    var type: String?
    ///背景图片
    var backIcon: String?
}

