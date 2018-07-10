
//
//  ApiModel.swift
//  Project
//
//  Created by WY on 2018/3/29.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ApiModel<T : Codable>: NSObject , Codable{
    var status : Int = 0
    var message : String = ""
    var data: T?
    override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let intValue =  try container.decode(Int.self , forKey: CodingKeys.status)//再按float处理
            status =  intValue
        } catch  {
             let result = try container.decode(String.self , forKey: CodingKeys.status)
            status = Int(result) == nil ? 0 :  Int(result)!
        }
        message = (try container.decodeIfPresent(type(of: message), forKey: CodingKeys.message)) ?? ""
        data = try container.decodeIfPresent(type(of: data), forKey: CodingKeys.data ) as? T
    }
    private enum CodingKeys: String, CodingKey  {
        case status
        case message
        case data
    }
}

///class T example
class ExampleModel: NSObject , Codable {
    var a = 0

}
private func testDecode(){
    if let model = DDJsonCode.decode(ApiModel<ExampleModel>.self, from: nil ){
        mylog(model.data)
    }
}
extension Decodable{
    static func decodeProterty<Key>(container :  KeyedDecodingContainer<Key> , codingKey :  KeyedDecodingContainer<Key>.Key) -> String {
        do {
            let stringValue  = try container.decode(String.self , forKey: codingKey)//按String处理
            return stringValue
        } catch  {
            do {
                let intValue =  try container.decode(Int.self , forKey: codingKey)//再按Int处理
                let stringValue  = "\(intValue)"
                return stringValue
            } catch  {
                do {
                    let floatValue =  try container.decode(Double.self , forKey: codingKey)//再按float处理
                    let stringValue  = "\(floatValue)"
                    return stringValue
                } catch  {
                    return ""
                }
            }
        }
    }
}




















private class NewAchienementDataModel: DDActionModel ,Codable {
    var date_list : [NewAchienementTimeModel]?
    var name : String?
    var shop_number: String?
    var message : [NewAchienementMsgModel]?
    required init(from decoder: Decoder) throws{
        var container = try decoder.container(keyedBy: CodingKeys.self)

        date_list = try container.decodeIfPresent(type(of: date_list), forKey: CodingKeys.date_list) as? [NewAchienementTimeModel]
        
        name = try container.decodeIfPresent(type(of: name), forKey: CodingKeys.name) as? String
        message = try container.decodeIfPresent(type(of: message), forKey: CodingKeys.message) as? [NewAchienementMsgModel]

        shop_number = NewAchienementDataModel.decodeProterty(container: container, codingKey: CodingKeys.shop_number)
        //        do {
        //            shop_number = try container.decode(type(of: shop_number), forKey: CodingKeys.shop_number)//按String处理
        //        } catch  {
        //            let levelInt =  try container.decode(Int.self , forKey: CodingKeys.shop_number)//再按Int处理
        //            shop_number = "\(levelInt)"
        //        }
    }
    private enum CodingKeys: String, CodingKey  {
        case name
        case date_list
        case shop_number
        case message
    }
    
    
    
}

fileprivate class NewAchienementTimeModel: DDActionModel ,Codable{
    var create_at : String = ""
}

fileprivate class NewAchienementMsgModel: DDActionModel ,Codable{
    var create_at : String = ""
    var title : String = ""
}
