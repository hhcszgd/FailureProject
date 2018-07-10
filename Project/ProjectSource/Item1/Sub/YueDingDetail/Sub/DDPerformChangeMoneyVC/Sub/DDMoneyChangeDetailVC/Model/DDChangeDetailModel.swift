//
//  DDChangeDetailModel.swift
//  Project
//
//  Created by 金曼立 on 2018/4/28.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDChangeDetailModel: Codable {
    var status : String? // 【0处理中 1已同意 2已拒绝】
    var tag : String?  // 【1代表甲方查看自己修改约定后的详情 7甲方查看乙方同意修改后的详情 2代表甲方查看乙方拒绝后的详情 5代表甲方查看自己同意乙方修改后的详情 3代表乙方查看甲方修改后的详情 4代表乙方查看自己拒绝甲方修改后的详情 6 代表乙方查看自己同意甲方修改后的详情 8代表乙方查看甲方同意修改后的详情】
    var set_tag : String?  // 0  未设置支付密码  1 已设置支付密码
    var info : DDChangeDetailInfoModel?
    var own : DDChangeDetailInfoModel?
    var other : DDChangeDetailInfoModel?
}

class DDChangeDetailInfoModel: Codable {
    var rid : String? 
    var order_id : String?
    var full_name : String?
    var pay_price : String?
    var price : String?
    var rest_price : String?
}

class DDCheckAutoInvalidModel: Codable {
    var invalid : String?
}
