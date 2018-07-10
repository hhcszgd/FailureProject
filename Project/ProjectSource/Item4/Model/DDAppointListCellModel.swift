//
//  DDAppointListCellModel.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAppointListCellModel: NSObject ,Codable{
    var key_code = ""
    var key_name : String?
    var key_price = ""
    var key_status = ""
    var values_status = ""
    var value_code = ""
    var value_name = ""
    var value_price = ""
    
    ///(0:私密，1：公开)
    var type : String?
    
    ///(1:单，2：群)
    var yue_type : String?
}

class DDAppointListDataModel: NSObject ,Codable{
    var item : [DDAppointListCellModel]?
}
