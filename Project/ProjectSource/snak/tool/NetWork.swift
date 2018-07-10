//
//  NetWork.swift
//  RxSwiftLearn
//
//  Created by wy on 2017/9/29.
//  Copyright © 2017年 wy. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import UIKit
import CryptoSwift
let ZDID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
enum BaseUrlStr: String {
    case api = "http://18t80.1818lao.com/"
}
enum Router: URLRequestConvertible {
    
        ///get请求
        case get(String, BaseUrlStr, [String: Any]?,[String: String]? )
        ///post请求
        case post(String, BaseUrlStr, [String: Any]?,[String: String]?)
        
        case put(String, BaseUrlStr, [String: Any]?,[String: String]?)
        
        ///URLRequestConvertible 代理方法
        func asURLRequest() throws -> URLRequest {
            ///请求方式
            var method: HTTPMethod {
                switch self {
                case .get:
                    return HTTPMethod.get
                case .post:
                    return HTTPMethod.post
                case .put:
                    return HTTPMethod.put
                }
            }
            ///请求参数
            var params: [String: Any]? {
                switch self {
                case var .get(url, _, dict, _):
                    if url != "Initkey/rest" {
                        if dict != nil {
                            dict!["token"] = token as Any
                        }else {
                            let dict = ["token": token as Any]
                            return dict
                        }
                    }
                    
                    return dict
                case var .post(url, _, dict, _):
                    if url != "Initkey/rest" {
                        if dict != nil {
                            dict!["token"] = token as Any
                        }else {
                            let dict = ["token": token as Any]
                            return dict
                        }
                    }
                    
                    return dict
                case var .put(_, _, dict, _):
                    if dict != nil {
                        dict!["token"] = token as Any
                    }else {
                        let dict = ["token": token as Any]
                        return dict
                    }
                    return dict
                    
                }
                
            }
            ///请求的网址
            var url: URL {
                var URLStr: String = ""
                switch self {
                case let .get(urlStr, baseUrl, _, _):
                    URLStr = baseUrl.rawValue + urlStr
                case let .post(urlStr, baseUrl, _, _):
                    URLStr = baseUrl.rawValue + urlStr
                case let .put(urlStr, baseUrl, _, _):
                    URLStr = baseUrl.rawValue + urlStr
                }
                mylog(URLStr)
                let url = URL.init(string: URLStr)
                return url!
                
            }
            
            ///时间戳
            func gettimeStamp() -> String {
                let calander = NSCalendar.current
                var comp = calander.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day,Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]), from: Date.init())
                let day = comp.day ?? 1
                let month = comp.month ?? 1
                let year = comp.year ?? 2018
                let timeStamp = String.init(format: "%d%02d%02d", year, month, day)
                return timeStamp
            }
           
            let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            let timeStamp = gettimeStamp()
            var request = URLRequest.init(url: url)
            var headers = [
                           "APPID": "2",
                           "VERSIONID": "2.0",
                           "VERSIONMINI": timeStamp,
                           "DID": ZDID,
                           "language": "110"]
            
            switch self {
            case let .get(_, _, _, header):
                
                if var headerDict = header{
                    for key in headerDict.keys {
                        request.setValue(headerDict[key], forHTTPHeaderField: key)
                    }
                }
                for key in headers.keys {
                    request.setValue(headers[key], forHTTPHeaderField: key)
                }
                
            case let .post(_, _, _, header):
                
                if let headerDict = header {
                    for key in headerDict.keys {
                        request.setValue(headerDict[key], forHTTPHeaderField: key)
                    }
                }
                for key in headers.keys {
                    request.setValue(headers[key], forHTTPHeaderField: key)
                }
            case let .put(_, _, _, header):
                if let headerDict = header {
                    for key in headerDict.keys {
                        request.setValue(headerDict[key], forHTTPHeaderField: key)
                        
                    }
                }
                for key in headers.keys {
                    request.setValue(headers[key], forHTTPHeaderField: key)
                }
            default:
                break
                
            }
            mylog(params)
            request.httpMethod = method.rawValue
            let encoding = URLEncoding.default
            return try encoding.encode(request, with: params)
        }
        
   
        
}

enum NetWorkStatus {
    ///不清楚
    case unknow
    ///蜂窝数据
    case wwan
    ///wifi
    case wifi
    ///不可达
    case notReachable
}
enum NetWorkError: Error {
    ///数据格式错误
    case formatError
    ///已经初始化
    case repeadInit
    ///网络连接失败
    case contectError
}
var token: String {
    get{
        if let token = UserDefaults.standard.value(forKey: "token") as? String {
            return token
        }else {
            return "nil"
        }
    }
}


class NetWork {
    static let manager = NetWork.init()
    private init() {
        
    }
   
        
    
    
    
    func initToken(success: ((String) -> ())?, failure:((String) -> ())?) {
        let router = Router.get("Initkey/rest", .api, nil, ["language": "110"])

        self.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if let sign = model.data {
                let result = ZDID + sign
                let resultToken = result.md5()
                UserDefaults.standard.setValue(resultToken, forKey: "token")
                success!(resultToken)
            }else {
                UserDefaults.standard.setValue("nil", forKey: "token")
                failure?("")
            }
        }, onError: { (error) in
            failure?("")
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        
        

    }
    
    
    ///初始化方法。
    func initToken() -> Observable<Bool> {
        let router = Router.get("Initkey/rest", .api, nil, ["language": "110"])
        let observable = Observable<Bool>.create({(observer) -> Disposable in
            if token != "nil" {
                observer.onNext(true)
                return Disposables.create()
            }
            let request = Alamofire.request(router).responseJSON(completionHandler: { (result) in
                
                switch result.result {
                case .success(let value):
                    guard let jsonStr = value as? String else {
                        observer.onError(NetWorkError.formatError)
                        observer.onCompleted()
                        return
                    }
                    if let model = DDJsonCode.decodeToModel(type: ApiModel<String>.self, from: jsonStr) {
                        if let sign = model.data {
                            let result = ZDID + sign
                            let resultToken = result.md5()
                            UserDefaults.standard.setValue(resultToken, forKey: "token")
                            observer.onNext(true)
                            
                        }else {
                            UserDefaults.standard.setValue("nil", forKey: "token")
                            observer.onNext(false)
                        }
                        
                    }else {
                        observer.onNext(false)
                    }
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create {
                request.cancel()
            }
        })
        return observable
    }

    
   ///重写请求方法
    func requestData<T: Codable>(router: Router, type: T.Type, success: ((ApiModel<T>) -> ())?, failure: ((NetWorkError) -> ())?) {
        self.initToken().subscribe(onNext: { (bo) in
            if bo {
                Alamofire.request(router).responseJSON(completionHandler: { (result) in
                    switch result.result {
                    case .success(let value):
                        guard let jsonStr = value as? String else {
                            failure?(NetWorkError.formatError)
                            return
                        }
                        if let model = DDJsonCode.decodeToModel(type: ApiModel<T>.self, from: jsonStr) {
                            success?(model)
                        }else {
                            failure?(NetWorkError.formatError)
                        }
                    case .failure(_):
                        
                        failure?(NetWorkError.contectError)
                        break
                    }
                    
                })

            }else {
                self.requestData(router: router, type: type, success: success, failure: failure)
            }
        }, onError: { (error) in
            self.requestData(router: router, type: type, success: success, failure: failure)
        }, onCompleted: {
            
        }) {
            
        }
    }
    
    
    

    func requestData<T: Codable>(router: Router, type: T.Type) -> Observable<ApiModel<T>> {
        
        return Observable<ApiModel<T>>.create({(observer) -> Disposable in
            mylog(router)
            //数据处理
            self.initToken().startWith(false).subscribe(onNext: { (bo) in
                if true {
                    
                }else {
                    
                }
            }, onError: { (error) in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
            let request = Alamofire.request(router).responseJSON(completionHandler: { (result) in
                
                switch result.result {
                case .success(let value):
                    guard let jsonStr = value as? String else {
                        observer.onError(NetWorkError.formatError)
                        observer.onCompleted()
                        return
                    }
                    if let model = DDJsonCode.decodeToModel(type: ApiModel<T>.self, from: jsonStr) {
                        observer.onNext(model)
                        observer.onCompleted()
                    }else {
                        observer.onError(NetWorkError.formatError)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    mylog(error)
                    observer.onError(error)
                    
                }
                
            })
            
            
            return Disposables.create {
                request.cancel()
            }
            
            
            
        })
    }
   
    
}

//                    switch router {
//                    case let .post(url, _, _, _):
//                        break
//                    case let .get(url, _, _, _):
//                        switch url {
//                        case "Initkey/rest":
//                            if let codeStr = value as? String {
//                                observer.onNext(["token": codeStr as AnyObject])
//                            }
//                        default:
//                            break
//                        }
//                        break
//                    case let .put(url, _, _, _):
//                        mylog(url)
//                    default:
//                        break
//                    }



