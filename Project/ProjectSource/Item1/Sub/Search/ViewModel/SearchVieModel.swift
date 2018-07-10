//
//  SearchVieModel.swift
//  zuidilao
//
//  Created by wy on 2017/10/13.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxDataSources
class SearchVieModel: NSObject {
    func getData(router: Router, getData: @escaping ([SectionModel<String, String>]) -> ()) {
//        NetWork.manager.requestData(router: router).subscribe(onNext: { (dict) in
//            let arr = [SectionModel.init(model: "热搜", items: ["a假两件卡", "b以是这个样子", "我不知道该怎么办"]), SectionModel.init(model: "历史搜索", items: ["c", "d"])]
//            getData(arr)
//        }, onError: { (error) in
//            print(error)
//        }, onCompleted: {
//            print("结束")
//        }) {
//            print("回收")
//        }
    }
    override init() {
        super.init()
    }
    
    
    
    var cleanBtnObservable: Observable<Void>!
    let items = Variable<[SectionModel<String, String>]>.init([SectionModel<String, String>]())
    var itemClick: Observable<(IndexPath, String)>!
    deinit {
        mylog("销毁")
    }
}
