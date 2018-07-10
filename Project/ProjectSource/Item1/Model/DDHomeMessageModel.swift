//
//  DDHomeMessageModel.swift
//  Project
//
//  Created by WY on 2018/4/8.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDHomeMessageModel: NSObject  , Codable {
    ///消息id
    var id = ""
    ///消息标题
    var title : String? = ""
    ///发送人id
    var aid : String?  = ""
    ///消息类别 0为好友 1为约定 2为系统
    var status : String? = ""
    var create_at = ""
    var logo : String?
    ///消息读取状态 0为未读 1为已读
    var read_status  = ""
    var content : String?
}
