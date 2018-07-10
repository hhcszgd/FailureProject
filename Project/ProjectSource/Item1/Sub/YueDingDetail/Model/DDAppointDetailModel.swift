//
//  DDAppointDetailModel.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAppointDetailModel: NSObject,Codable {
    
    ///(1:手动，2:自动)；
    var lenders : String?
    
    ///需要人数
    var person_num :  String?
    
    ///已加入人数
    var join_num : String?
    ///期数
    var num  = ""
    var status : DDAppointDetailStatus = DDAppointDetailStatus()
    var items : [DDAppointDetailSectionModel]?
    ///自定义字段 2付款方 , 1收款方
    var user_type : String?
    var appointment_id : String?
    var v_appointment_id : String?
    
    /// 当为单人约定时会返回此字段 , 代表此成员的放款id
    var fid : String?
    var price : String?
    ///约定类型 1 单约 ， 2 群约
    var yue_type : String?
    
    ///新增字段 是否加入约定:    join ,1有加入,2没有加入,3用户创建约定
    var join : String?
    private enum CodingKeys: String, CodingKey  {
        ///(1:手动，2:自动)；
        case lenders
        ///需要人数
        case  person_num
        
        ///已加入人数
        case  join_num
        ///期数
        case  num
        case  status
        case  items
        ///自定义字段 2付款方 , 1收款方
        case  user_type
        case  appointment_id
        case  v_appointment_id
        
        /// 当为单人约定时会返回此字段 , 代表此成员的放款id
        case  fid
        case  price
        case  yue_type
        case join
    }
    
    override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lenders = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.lenders)
        person_num = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.person_num)
        join_num = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.join_num)
        num = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.num)
        status = try container.decode(DDAppointDetailStatus.self, forKey: CodingKeys.status)
        items = try container.decodeIfPresent([DDAppointDetailSectionModel].self  , forKey: CodingKeys.items)
        
        user_type = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.user_type)
        appointment_id = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.appointment_id)
        v_appointment_id = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.v_appointment_id)
        
        fid = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.fid)
        price = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.price)
        yue_type = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.yue_type)
        join = DDAppointDetailModel.decodeProterty(container: container, codingKey: CodingKeys.join)

    }
    
    
    
    
    
    
    
    
    
}

class DDAppointDetailStatus: NSObject,Codable {
    
    ///订单状态
    var or_st  :String?
    
    ///是否有金额修改
    var or_xg : String?
    
    ///是否有纠纷
    var or_jf : String?
    
    ///是否开工（1：未开工，0: 已开工）
    var or_kg : String?
    
    /// 何时开始:  a_start(公开约定开工方式) 0 : 随时开始 1 : 人满开始
    var  a_start : String?
    ///0私密 , 1 公开
    var type : String?
    
    private enum CodingKeys: String, CodingKey  {
        case or_st
        case or_xg
        case or_jf
        case or_kg
        case a_start
        case type
    }
    override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        or_st = try container.decodeIfPresent(String.self, forKey: DDAppointDetailStatus.CodingKeys.or_st)
        or_xg = try container.decodeIfPresent(String.self, forKey: DDAppointDetailStatus.CodingKeys.or_xg)
        or_jf = try container.decodeIfPresent(String.self, forKey: DDAppointDetailStatus.CodingKeys.or_jf)
        a_start = try container.decodeIfPresent(String.self, forKey: DDAppointDetailStatus.CodingKeys.a_start)
        type = try container.decodeIfPresent(String.self, forKey: DDAppointDetailStatus.CodingKeys.type)
        
        do {
            or_kg = try container.decodeIfPresent(String.self, forKey: DDAppointDetailStatus.CodingKeys.or_kg)
        } catch  {
            let intValue = try container.decodeIfPresent(Int.self, forKey: DDAppointDetailStatus.CodingKeys.or_kg)
            or_kg = "\(intValue ?? 0)"
        }
    }
}

class DDAppointDetailCellModel: NSObject,Codable {
    var title : String?
    var value : String?
    var bid : String?
    var aid : String?
    var top : String?
    /// 0置灰
    var sign : String?
    private enum CodingKeys: String, CodingKey  {
        case title
        case value
        case bid
        case sign
        case aid
        case top
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = DDAppointDetailCellModel.decodeProterty(container: container, codingKey: CodingKeys.title)
        bid = DDAppointDetailCellModel.decodeProterty(container: container, codingKey: CodingKeys.bid)
        aid = DDAppointDetailCellModel.decodeProterty(container: container, codingKey: CodingKeys.aid)
        sign = DDAppointDetailCellModel.decodeProterty(container: container, codingKey: CodingKeys.sign)
        value = DDAppointDetailCellModel.decodeProterty(container: container, codingKey: CodingKeys.value)
        top = DDAppointDetailCellModel.decodeProterty(container: container, codingKey: CodingKeys.top)
    }
}

class DDAppointDetailSectionModel: NSObject,Codable {
    var title : String?
    var value : String?
    var type: String?
    var items:[DDAppointDetailCellModel]?
    
    private enum CodingKeys: String, CodingKey  {
        case title
        case value
        case type
        case items
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title =  DDAppointDetailSectionModel.decodeProterty(container: container, codingKey: CodingKeys.title)
        
        value  =  DDAppointDetailSectionModel.decodeProterty(container: container, codingKey: CodingKeys.value )
        
        type  =  DDAppointDetailSectionModel.decodeProterty(container: container, codingKey: CodingKeys.type)
        items = try container.decodeIfPresent([DDAppointDetailCellModel].self , forKey: DDAppointDetailSectionModel.CodingKeys.items)
    }
}
