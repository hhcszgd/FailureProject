//
//  DDMoneyChangeModel.swift
//  Project
//
//  Created by 金曼立 on 2018/4/26.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDMoneyChangeModel: Codable {
    var id : String?
    var full_name : String?
    var lenders : String? //  1 手动  2 自动
    var order_total : String? // 约定总金额 【已拼接了单位“元”】
    var order_id : String? // 约定ID号
    var period_tag : String? // 金额期数标识 【1为单期 2为多期】
    var uid : String? // 用户ID
    var nickname : String? // 用户姓名
    var mobile : String? // 用户手机号
    var head_images : String? // 用户头像
    var user_tag : String? // 当前用户标识 1为甲方 2为乙方
    var periods_list : [DDPeriodsListModel]?
}
class DDPeriodsListModel: Codable {
    var fid : String? // 金额期数ID
    var grant_time : String? // 放款时间
    var status : String? // 放款状态 【1:甲修改、乙未发放、2:详情+金额有修改、4:详情+金额有修改+显示支付金额和原定金额和退款金额、5、6:已发放】
    var num : String? // 放款期数
    var rest_price : String? // 退回金额
    var mod_tag : String?  // 修改标识 1为已修改 0为未修改
    var pay_price : String? // 支付金额 【已拼接了单位“元”】
    var price: String?
}
