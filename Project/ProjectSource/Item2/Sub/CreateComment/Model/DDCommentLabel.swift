//
//  DDCommentLabel.swift
//  Project
//
//  Created by WY on 2017/12/26.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit

class DDCommentLabelsApiModle: NSObject,Codable {
    var message = ""
    var status = 0
    var data : [DDCommentLabel]?
}
class DDCommentLabel: NSObject ,Codable{
    var id : String = ""
    var value = ""
}
