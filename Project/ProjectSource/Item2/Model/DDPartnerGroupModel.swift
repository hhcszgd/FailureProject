//
//  DDPartnerGroupModel.swift
//  Project
//
//  Created by WY on 2018/4/9.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPartnerGroupModel: NSObject , Codable , NSMutableCopying{
    func mutableCopy(with zone: NSZone? = nil) -> Any {
        let temp = DDPartnerGroupModel()
        temp.letter = self.letter
        temp.info = self.info
        return temp
    }
    

    var letter : String = ""
    var info : [DDPartnerModel]?
    
}
