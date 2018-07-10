//
//  ConsultModel.swift
//  Project
//
//  Created by wy on 2018/4/20.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import Foundation
class ConsultModel: Codable {
    ///协商编号
    var id: String?
    ///约定号
    var order_id: String?
    ///约定名称
    var full_name: String?
    ///状态 0，处理中，1，已同意，2已拒绝。
    var status: String?
    var create_date: String?
    var start: String?
    var bid: String?
    var aid: String?
    var content: String?
    var rest_price: String?
    
    /// 付款金额
    var pay_price: String?
    var price: String?
    var v_id: String?
    var display: String?
    var history: String?
    var text: String?
    var name: String?
    var reason: String?
    var type: String? = "1"
}
