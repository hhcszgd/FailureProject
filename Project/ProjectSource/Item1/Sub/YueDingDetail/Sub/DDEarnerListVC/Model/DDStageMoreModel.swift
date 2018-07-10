//
//  DDStageMoreModel.swift
//  Project
//
//  Created by 金曼立 on 2018/4/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDStageMoreModel: Codable {
    var count : Int?
    var order_id : String?
    var yue_type : String? // 1单人 2多人
    var item : Array<DDStageEarnerNumModel>?
}

class DDStageEarnerNumModel: Codable {
    var term : Int? // 加入约定的人数
    var num : Int? // 待放款人数
}
