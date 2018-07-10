//
//  DDEarnerModel.swift
//  Project
//
//  Created by 金曼立 on 2018/4/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDEarnerModel: Codable {
    var id: String? // 放款表ID
    var order_id: String? //订单号
    var status: String? // 状态 4为 金额有修改（金额有修改）
    var bid: String? // 收款方ID
    var payment_price: String? // 金额
    var nickname: String? // 昵称
    var head_images: String? // 头像
    var name: String? // 手机号
}
