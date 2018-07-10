//
//  DDMessageContentModel.swift
//  Project
//
//  Created by WY on 2018/4/24.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDMessageContentModel: NSObject , Codable{
  
        //        var id = ""
        //        var title = ""
        var create_at = ""
        
        ///消息内容
        var content : String?//兼容金额
        
        ///内容分类序号【根据EXCEL定义https://192.168.101.210/svn/产品技术通用文档/产品三组-B2B/一把通/一把通移动端消息提示.xlsx】
        var con_status : String?
        
        ///跳转标识 1为跳转 0为无跳转
        var tag : String?
        
        ///跳转参数
        var attr : ContentAttributeModel?
    ///自加字段 , 存储行高
    var rowHeight : CGFloat?
    

}
class ContentAttributeModel: NSObject , Codable {
    //{"order_id":"d1804245906848576","yue_type":1,"type":0}
    var order_id : String?
    ///【1:单约、2:群约】
    var yue_type : String?
    ///【0 私密约定 1公开约定】
    var type : String?
    var uid : String?//对方id
    ///金额期数ID 查看修改金额界面参数
    var fid : String?
    /// 2付款 1收
    var user_type : String?
    
    /// 乙方id
    var bid : String?
    
    
    
    
    private enum CodingKeys: String, CodingKey  {
        case order_id
        case yue_type
        case type
        case uid
        case fid
        case user_type
        case bid
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        order_id = ContentAttributeModel.decodeProterty(container: container, codingKey: ContentAttributeModel.CodingKeys.order_id)
        
        yue_type = ContentAttributeModel.decodeProterty(container: container, codingKey: ContentAttributeModel.CodingKeys.yue_type)
        type = ContentAttributeModel.decodeProterty(container: container, codingKey: ContentAttributeModel.CodingKeys.type)
        uid = ContentAttributeModel.decodeProterty(container: container, codingKey: ContentAttributeModel.CodingKeys.uid)
        fid = ContentAttributeModel.decodeProterty(container: container, codingKey: ContentAttributeModel.CodingKeys.fid)
        user_type = ContentAttributeModel.decodeProterty(container: container, codingKey: ContentAttributeModel.CodingKeys.user_type)
        bid = ContentAttributeModel.decodeProterty(container: container, codingKey: ContentAttributeModel.CodingKeys.bid)
    }

}
