//
//  DDHomeAdvertModel.swift
//  Project
//
//  Created by WY on 2018/4/8.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDHomeAdvertModel: NSObject , Codable {

    var id = ""
    var name = ""
    var url : String?
    var img : String?
    var create_time : String?
    var admin : String?
    var status : String? = ""
    var type = ""
    var start_time : String? = ""
    var end_time : String? = ""
    var pid  : String?
    var font  : String?
}
