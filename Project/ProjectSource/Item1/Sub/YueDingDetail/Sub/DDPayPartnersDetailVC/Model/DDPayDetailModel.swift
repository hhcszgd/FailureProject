//
//  DDPayDetailModel.swift
//  Project
//
//  Created by 金曼立 on 2018/5/7.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPayDetailModel: Codable {
    
    var name : String?  //  约定名称
    var price_all : String?  //  发放总金额
    var num : String?  //  当前期数
    var num_all : String?  //  总期数
    var item : [DDPayDetailInfoModel]?
    var stop : String? // 1为已终止 0为未终止
    var stop_price : String?
    var stop_pay_price : String?
    var stop_rest_price : String?
}

class DDPayDetailInfoModel : Codable {
    
    var price : String? //  金额
    var bname : String?  //  收款人名
    var blogo : String?  //  收款人头像
    var grant_time : String?  //  放款时间
    var bphone : String?  //  手机号
    var status : String?  //  放款状态   0 正常 1 待发放 2 纠纷 3 终止 4 纠纷完成 5 终止完成 6已发放
    var payment_prive : String?  //  支付金额
    var rest_price : String?  //  退回金额
    var num : String?  //  当前期数
    var mod_tag : String?  // 【1为有修改 0为未修改】
}
