//
//  DDAccount.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit
import HandyJSON
class DDAccount:NSObject, Codable, NSCoding{
    private override init() {
        super.init()
    }
    
    ///用户名,账号
    var username: String?
    ///手机号
    var mobile: String?
    var sex: String?
    ///用户名账号
    var name: String?
    var countryID: String?
    var countryCode: String?
    var companyName: String?
    var companyPhone: String?
    ///用户id
    var id: String?
    ///头像
    var headImage: String?
    ///真实姓名
    var nickname: String? {
        didSet{
            self.trueName = nickname
        
        }
    }
    var trueName: String?

    

    
    
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case username
        case mobile
        case sex
        case name
        case countryID
        case countryCode
        case id = "uid"
        case companyName = "company"
        case trueName = "true_name"
        case companyPhone = "telephone"
        case headImage = "head_images"
        
    }
    
    var isLogin : Bool {
        if token == "nil" {
            return false
        }else if let userName = self.username, userName.count > 0 {
            return true
        }else {
            return false
        }
        
    }
    
    static let share = DDAccount.read()
    
    
    
    ///save account from memary to disk .
    
    /// return value  : save success or not
    @discardableResult
    func save() -> Bool {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("Account.data")
            let isSuccess =  NSKeyedArchiver.archiveRootObject(self , toFile: filePath)
            if isSuccess {
                mylog("archive success")
            }else{
                mylog("archive failure")
            }
            return isSuccess
        }else{
            mylog("the  path of archive is not exist")
            return false
        }
    }
    ///load account from local disk
    class  func read() -> DDAccount {
        let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        if let realDocuPath : NSString = docuPath as NSString? {
            let filePath = realDocuPath.appendingPathComponent("Account.data")
            let object =  NSKeyedUnarchiver.unarchiveObject(withFile:  filePath)
            if let realObjc = object as? DDAccount {
                return realObjc
            }else{
                return  DDAccount()
            }
        }else{
            mylog("the  path of unarchive is not exist")
            return  DDAccount()
        }
    }
    ///set share account's propertis by other account dictionary
    
    
    
   
    ///set share account's propertis by other account instance
    func setPropertisOfShareBy( otherAccount : DDAccount?)  {
        guard let account = otherAccount else {
            return
        }

        if let name = account.name, name.count > 0 {
            self.name = name
            self.username = self.name
        }
        if let mobile = account.mobile, mobile.count > 0 {
            self.mobile = mobile
        }
        if let id = account.id, id.count > 0 {
            self.id = id
        }
        

        if let companyName = account.companyName, companyName.count > 0 {
            self.companyName = companyName
        }
        if let name = account.trueName, name.count > 0 {
            self.trueName = name
            self.nickname = name
            
        }
        if let name = account.nickname, name.count > 0 {
            self.trueName = name
            self.nickname = name
            
        }
        if let image = account.headImage, image.count > 0 {
            self.headImage = image
        }
//        if let education = otherAccount.education, education.count > 0 {
//            self.education = education
//        }
//        if let relationName = otherAccount.relationName, relationName.count > 0 {
//            self.relationName = relationName
//        }
//        if let relation = otherAccount.relation, relation.count > 0 {
//            self.relation = relation
//        }
//        if let relationMobile = otherAccount.relationMobile, relationMobile.count > 0 {
//            self.relationMobile = relationMobile
//        }
//        if let id = otherAccount.id, id.count > 0 {
//            self.id = id
//        }
//        if let avatar = account.avatar, avatar.count > 0 {
//            self.avatar = avatar
//        }
//        if let examitionStatus = otherAccount.examineStatus, examitionStatus.count > 0 {
//            self.examineStatus = examitionStatus
//        }
        if let userName = account.username, userName.count > 0 {
            self.username = account.username
            UserDefaults.standard.setValue(userName, forKey: "loginName")
        }
        
        
        self.save()
    }
    
    ///remove account data from disk
    @discardableResult
    func deleteAccountFromDisk() -> Bool {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("Account.data")
        do {
            try  FileManager.default.removeItem(atPath: path)
            mylog("remove account data from disk success")
            
            self.clean()
            return true
        }catch  let error as NSError {
            mylog("remove account data from disk failure")
            mylog(error)
            return false
        }
        
        
        
        
    }
    func clean() {
        self.username = nil
        self.mobile = nil
        self.sex = nil
        self.name = nil
        self.countryID = nil
        self.countryCode = nil
        self.companyName = nil
        self.companyPhone = nil
        self.id = nil
        self.headImage = nil
        self.nickname = nil
        self.trueName = nil
    }
    
    
    //unarchive binary data to instance
    required init?(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        self.headImage = aDecoder.decodeObject(forKey: "headImage") as? String ?? ""
//        self.memberId = (aDecoder.decodeObject(forKey: "memberId") as? Int) ?? 0
        self.mobile = (aDecoder.decodeObject(forKey: "mobile") as? String) ?? ""
//        self.email = (aDecoder.decodeObject(forKey: "email") as? String) ?? ""
        self.sex = (aDecoder.decodeObject(forKey: "sex") as? String)
//        self.saltCode = (aDecoder.decodeObject(forKey: "saltCode") as? String) ?? ""
        self.countryID = aDecoder.decodeObject(forKey: "countryID") as? String
        self.countryCode = aDecoder.decodeObject(forKey: "countryCode") as? String
        self.id = aDecoder.decodeObject(forKey: "id") as? String
//        self.nickName = aDecoder.decodeObject(forKey: "nickName") as? String
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        self.trueName = aDecoder.decodeObject(forKey: "trueName") as? String

        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.companyPhone = aDecoder.decodeObject(forKey: "companyPhone") as? String
        self.companyName = aDecoder.decodeObject(forKey: "companyName") as? String
    }
    
    
    //unarchive instance to binary data
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.mobile, forKey: "mobile")
        aCoder.encode(self.trueName, forKey: "trueName")
        aCoder.encode(self.nickname, forKey: "nickname")
//        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.sex, forKey: "sex")
//        aCoder.encode(self.saltCode, forKey: "saltCode")
        aCoder.encode(self.countryID, forKey: "countryID")
        aCoder.encode(self.countryCode, forKey: "countryCode")
        aCoder.encode(self.id, forKey: "id")
//        aCoder.encode(self.nickName, forKey: "nickName")
        aCoder.encode(self.headImage, forKey: "headImage")
//        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.companyName, forKey: "companyName")
        aCoder.encode(self.companyPhone, forKey: "companyName")
    }
}
