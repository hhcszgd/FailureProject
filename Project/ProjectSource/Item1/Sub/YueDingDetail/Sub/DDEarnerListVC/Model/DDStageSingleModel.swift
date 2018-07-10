//
//  DDStageSingleModel.swift
//  Project
//
//  Created by 金曼立 on 2018/4/25.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDStageSingleModel: Codable {
    var id : String? // 放款表id  fid
    var status : String? // 状态（1可正常放款）0 不可放款 1 待放款 2纠纷中 3协商中 4 纠纷完成 5 终止完成 6 已发放
    var num : String? // 当前期数
}
