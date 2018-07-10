//
//  DDStageModel.swift
//  Project
//
//  Created by 金曼立 on 2018/4/23.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDStageModel: Codable {
    var term : String? // 期数
    var count : String? // 总人数
    var order_id : String? // 订单ID
    var num : Bool? // 可放款人数
    var yue_type : String? // 1单人 2多人
}
