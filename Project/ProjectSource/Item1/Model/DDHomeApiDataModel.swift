//
//  DDHomeApiDataModel.swift
//  Project
//
//  Created by WY on 2018/4/8.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDHomeApiDataModel: NSObject ,  Codable {
    var message : [DDHomeMessageModel]?
    var banners : DDHomeAdvertModel?
    var float_img : DDHomeAdvertModel?
}
