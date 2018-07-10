//
//  FSelectCityModel.swift
//  zuidilao
//
//  Created by wy on 2017/11/10.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import CoreLocation
class FSelectCityModel: NSObject {
    ///切换洲
    func changeState(viewController: GDNormalVC) {
//        NetWork.manager.requestData(router: Router.post("index/stateList", ["parent_id": -1 as! AnyObject])).subscribe(onNext: { (dict) in
//            mylog(dict)
//        }, onError: { (error) in
//            mylog(error)
//        }, onCompleted: {
//            mylog("切换洲方法结束")
//        }) {
//            mylog("切换洲方法回收")
//        }
        var items = [CityModel]()
        for i in 0..<10 {
            let model = CityModel.init()
            model.cityName = String(i)
            items.append(model)
        }
        
        let histrory = CityModel.init()
        let model1 = CityModel.init()
        model1.cityName = "尽量的放大点卡了"
        
       
        histrory.cityItems = [model1]
        let historyModel = SectionModel<String, CityModel>.init(model: "history", items: [histrory])
        let aModel = SectionModel<String, CityModel>.init(model: "A", items: items)
        let bModel = SectionModel<String, CityModel>.init(model: "B", items: items)
        cityItems.value = [historyModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel, aModel, bModel]
        
    }
    ///切换国家
    func changeCountry() {
        
    }
    ///切换城市
    func changeCity() {
        
    }
    func configMentHistoryData(model: CityModel) {
        var dataArr = cityItems.value
        guard let cityModel = dataArr.first?.items.first else {
            return
        }
        var items = cityModel.cityItems
        var isContaint: Bool = true
        items.forEach({ (submodel) in
            if submodel.cityName == model.cityName {
                isContaint = false
                return
            }
        })
        let count = items.count
        if isContaint {
            if count >= 6 {
                items.removeLast()
                items.insert(model, at: 0)
            }else {
                items.insert(model, at: 0)
            }
        }
        cityModel.cityItems = items
        let sectionModel = SectionModel<String, CityModel>.init(model: "history", items: [cityModel])
        dataArr.removeFirst()
        dataArr.insert(sectionModel, at: 0)
        cityItems.value = dataArr
        
    }
    
    func getData() {
//        let paramter = ["l": LCode, "c": CountryCode] as [String: AnyObject]
//        NetWork.manager.requestData(router: Router.post("getCountryCity/110", .api, paramter)).subscribe(onNext: { (dict) in
//            
//        }, onError: { (error) in
//            
//        }, onCompleted: {
//            mylog("结束")
//        }) {
//            mylog("回收")
//        }
    }
    
    
    
    
    
    
    var cityItems: Variable<[SectionModel<String, CityModel>]> = Variable<[SectionModel<String, CityModel>]>.init([SectionModel<String, CityModel>]())
    
    
}
