//
//  String+extension.swift
//  zuidilao
//
//  Created by wy on 2017/10/11.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import CryptoSwift

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

extension String {
    //MARK: -MD5算法
//    func md5() ->String!{
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)//如果报错就在bridgeing-header中加上#import <CommonCrypto/CommonDigest.h>
//        
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//        let hash = NSMutableString()
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.deinitialize()
//        return String(format: hash as String)
//    }

    
    ///判断用户名是否合法
    func userNameLawful() -> Bool {
        let name  = "^[\\u4e00-\\u9fa5]{2,80}$"
        let regextextName = NSPredicate.init(format: "SELF MATCHES %@", name)
        let result: Bool = regextextName.evaluate(with: self)
        return  result
    }
    ///判断公司名称
    func companyNameLawful() -> Bool {
        let name  = "^[\\u4e00-\\u9fa5]{4,80}$"
        let regextextName = NSPredicate.init(format: "SELF MATCHES %@", name)
        let result: Bool = regextextName.evaluate(with: self)
        return  result
    }
    ///解码
    static  func AESDecode(key:String = "tgkdksiwa4kfla28",iv:String = "tgkdksiweskfla28",codeStr:String) -> String?{
        if let targetData =  Data.init(base64Encoded: codeStr){
            do {
                let decrypted = try AES(key: key.bytes, blockMode: BlockMode.CBC(iv: iv.bytes), padding: .pkcs7).decrypt(targetData.bytes)
                let decryptedData = Data(decrypted)
                return String(bytes: decryptedData.bytes, encoding: .utf8) ?? nil
            } catch  {
                mylog(error )
                return nil
            }
        }
        return nil
    }
    
    
//    func aesDecrypt(key: String) throws -> [String: String]? {
//                let key = "4974949650676986"
//        let iv = key
//        //        let str = "uLjChSYtNCkPYkKV9kmkP5GCA/rAbHHCWRWaVxQC36VrX/voRhvV1RhVNGq1lHBR4Wb7uzU97DMT3qe4rSIVNQ=="
//        let data1 = self.data(using: String.Encoding.utf8)!
//        let data = Data(base64Encoded: data1)!
//
//        let decrypted = try! AES(key: key, iv: iv, blockMode: .CBC, padding: .pkcs7).decrypt([UInt8](data))
//        let decryptedData = Data(decrypted)
//        let result = String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
//        let josnData = result.data(using: String.Encoding.utf8)
//        do {
//            let dict = try JSONSerialization.jsonObject(with: josnData!, options: JSONSerialization.ReadingOptions.mutableContainers)
//            if let josnDic = dict as? [String: String] {
//                return josnDic
//            }else {
//                return nil
//            }
//        } catch {
//            return nil
//        }
//
//    }
    ///MARK: Unicode转中文
    var unicodeStr:String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = ("\"" + tempStr2) + "\""
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: PropertyListSerialization.MutabilityOptions(), format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }

    func attributWithString(textColor: UIColor, location: Int, length: Int) -> NSMutableAttributedString {
        let mutableAttribute = NSMutableAttributedString.init(string: self)
        mutableAttribute.addAttributes([NSAttributedStringKey.foregroundColor : textColor], range: NSRange.init(location: location, length: length))
        return mutableAttribute
    }
    static func getYearMonthDay() -> String {
        let calander = NSCalendar.current
        var comp = calander.dateComponents(Set<Calendar.Component>.init([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: Date.init())
        let year = comp.year ?? 2018
        let month = comp.month ?? 1
        let day = comp.day ?? 30
        let str = String.init(format: "%d", year) + String.init(format: "%02d", month) + String.init(format: "%02d", day)
        return str
    }
    
    
    
    
    
    ///MARK:计算多行字符串的size
    func sizeWith(font : UIFont , maxSize : CGSize) -> CGSize {
        var tempMaxSize = CGSize.zero
        if maxSize == CGSize.zero {
            tempMaxSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        }else{
            tempMaxSize = maxSize
        }
        let attribute = Dictionary(dictionaryLiteral: (NSAttributedStringKey.font,font) )
        let size = self.boundingRect(with: tempMaxSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin , NSStringDrawingOptions.usesFontLeading], attributes: attribute, context: nil).size
        return  size
    }
    ///MARK:计算多行字符串的size
    func sizeWith(font : UIFont , maxWidth : CGFloat) -> CGSize {
        var tempMaxSize = CGSize.zero
        if maxWidth == 0 {
            tempMaxSize = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        }else{
            tempMaxSize = CGSize(width: maxWidth, height: CGFloat(MAXFLOAT))
        }
        let attribute = Dictionary(dictionaryLiteral: (NSAttributedStringKey.font,font) )
        let size = self.boundingRect(with: tempMaxSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin , NSStringDrawingOptions.usesFontLeading], attributes: attribute, context: nil).size
        return  size
    }
    
    func firstCharactorWithString() -> String {
        if #available(iOS 9.0, *) {
            if let str1 = self.applyingTransform(StringTransform.toLatin, reverse: false) as? String {
                if let str2 = str1.applyingTransform(.stripCombiningMarks, reverse: false) as? String {
                    let index = str2.index(str2.startIndex, offsetBy: 1)
                    let str3 = str2.prefix(upTo: index)
                    return String.init(str3)
                    
                }
                
            }
            return ""
        }else {
            
            var str = NSMutableString.init(string: self) as CFMutableString
            CFStringTransform(str, nil, kCFStringTransformToLatin, false)
            CFStringTransform(str, nil, kCFStringTransformStripCombiningMarks, false)
            let str2 = CFStringCreateWithSubstring(nil, str, CFRangeMake(0, 1))
            return String(str2!)
        }
    }
    
  
    func bankCardCheck()-> Bool {
        if self.isEmpty {
            return false
        }
        var forwardDescArr = [String]()
        for (_ , char)  in self.enumerated() {
            forwardDescArr.insert(String(char), at: 0)
        }
        var  arrOddNum = [Int]()//偶数位数组
        //        var  arrOddNum2 =  [Int]()//奇数位*2的积 > 9
        var  arrEvenNum =  [Int]()//奇数位*2的积 < 9
        for (index ,char) in forwardDescArr.enumerated() {
            let intNum = Int(char) ?? 0
            if index % 2 != 0 {
                if intNum * 2 < 9 {
                    arrEvenNum.append(intNum * 2)
                }else{
                    arrEvenNum.append(intNum * 2 - 9)
                }
            }else {
                arrOddNum.append(intNum)
            }
        }
        var sumOddNumTotal = 0
        for (_ , intValue ) in arrOddNum.enumerated() {
            sumOddNumTotal += intValue
        }
        var sumEvenNumTotal = 0
        for (_ , intValue ) in arrEvenNum.enumerated() {
            sumEvenNumTotal += intValue
        }
        //        let  lastNumber = Int(lastNum) ?? 0
        
        let  luhmTotal =  sumEvenNumTotal + sumOddNumTotal
        
        return (luhmTotal%10 == 0) ? true : false
    }
    
    ///判断手机号是否合法
    func mobileLawful() -> Bool {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let cm = "1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let cu = "1(3[0-2]|5[256]|8[56])\\d{8}$"
        let ct = "1((33|53|77|8[09])[0-9]|349)\\d{7}$"
        let phs = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
        let new = "1((76|66|55|8[0-9])[0-9]|349)\\d{7}$"
        let regextextMobile = NSPredicate.init(format: "SELF MATCHES %@", mobile)
        let regextextcm = NSPredicate.init(format: "SELF MATCHES %@", cm)
        let regextextcu = NSPredicate.init(format: "SELF MATCHES %@", cu)
        let regextextct = NSPredicate.init(format: "SELF MATCHES %@", ct)
        let regextextphs = NSPredicate.init(format: "SELF MATCHES %@", phs)
        let regexTextNew = NSPredicate.init(format: "SELF MATCHES %@", new)
        let result: Bool = regextextMobile.evaluate(with: self) || regextextcm.evaluate(with: self) || regextextcu.evaluate(with: self) || regextextct.evaluate(with: self) || regextextphs.evaluate(with: self) || regexTextNew.evaluate(with: self)
        return  result
    }
    ///手机号码中间星号处理
    func prefixphone() -> String {
        
        let phoneStr = NSString.init(string: self)
        let prefix = phoneStr.substring(to: 3)
        let sub = phoneStr.substring(from: 7)
        let id = prefix + "****" + sub
        return id
    }
    ///判断约定名称是否正确(包含字母数字中文还有空格)
    func appointmentNameLawful() -> Bool {
        let name  = "^[\\u4e00-\\u9fa5A-Za-z0-9\\s+]{0,24}$"
        let regextextName = NSPredicate.init(format: "SELF MATCHES %@", name)
        let result: Bool = regextextName.evaluate(with: self)
        return  result
    }
    
    
    
    func passwordLawful() -> Bool {
        let pass = "^[0-9A-Za-z]{6,16}$"
        let result = NSPredicate.init(format: "SELF MATCHES %@", pass)
        if result.evaluate(with: self) {
            return true
        }else {
            if self.count == 0 {
                return true
            }
            return false
        }
    }
    
    ///判断公司的电话号码。
    func isFixedCompanyTelephone() -> Bool {
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    
    let FT = "^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$"
    
    let regextestcm = NSPredicate.init(format: "SELF MATCHES %@", FT)
    
    return regextestcm.evaluate(with: self)
    
    }
    
    
    ///身份证号码
    func idCardLawful() -> Bool {
        let authCode = "^(\\d{17})(\\d|[xX])$"
        let result = NSPredicate.init(format: "SELF MATCHES %@", authCode)
        if result.evaluate(with: self) {
            return true
        }else {
            return false
        }
    }
    ///判断验证码是否合法
    func authoCodeLawful() -> Bool {
        let authCode = "^[0-9a-zA-Z]{4,6}$"
        let regextextAuthCode = NSPredicate.init(format: "SELF MATCHES %@", authCode)
        let result: Bool = regextextAuthCode.evaluate(with: self)
        return  result
    }

    //MARK:计算单行字符串的size
    func sizeSingleLine(font : UIFont ) -> CGSize  {
        return self.size(withAttributes: Dictionary(dictionaryLiteral: (NSAttributedStringKey.font,font) ))
    }
    
    // 判断字符串是否只含有数字、汉字、字母，判断长度
    func checkString(string : String, length : Int) -> Bool {
        let checkString = string.trimmingCharacters(in: .whitespaces)
        let pattern = "^[\\u4E00-\\u9FA5A-Za-z0-9]|[\\s]+$"
        let matcher = MyRegex(pattern)
        if matcher.match(input: checkString) {
            let str = NSString(string: checkString)
            if str.length > length {
                let log = "不能超过" + "\(length)" + "字"
                GDAlertView.alert(log, image: nil, time: 2, complateBlock: nil)
                return false
            }
            return true
        }else{
            if checkString.count == 0{
                return false
            }
            GDAlertView.alert("只可以输入汉字、数字和字母", image: nil, time: 2, complateBlock: nil)
            return false
        }
    }
    
    // 判断字符串是否只含有数字（整数），判断长度
    func checkNumberString(string : String) -> Bool {
        let checkString = string.trimmingCharacters(in: .whitespaces)
        let pattern = "^[0-9]+$"
        let matcher = MyRegex(pattern)
        if matcher.match(input: checkString) {
            return true
        }
        return false
    }
    
    // 判断是否为两位小数的正实数
    func checkDoubleDecimalNumberString(string: String) -> Bool {
        let checkString = string.trimmingCharacters(in: .whitespaces)
        let pattern = "^[0-9]+(.[0-9]{2})?$"
        let matcher = MyRegex(pattern)
        if matcher.match(input: checkString) {
            return true
        }
        return false
    }
    
    // 判断是否为一位小数的正实数
    func checkSingleDecimalNumberString(string: String) -> Bool {
        let checkString = string.trimmingCharacters(in: .whitespaces)
        let pattern = "^[0-9]+(.[0-9]{1})?$"
        let matcher = MyRegex(pattern)
        if matcher.match(input: checkString) {
            return true
        }
        return false
    }
    
    // 判断输入的数字是否合法（整数、一位小数、两位小数）
    func checkDecimalNumberString(string: String) -> Bool {
        if NSString(string: string).length == 0 {
            return false
        }
        let isRoundNum = string.checkNumberString(string: string)
        if isRoundNum {return true}
        let isSingleNum = string.checkSingleDecimalNumberString(string: string)
        if isSingleNum {return true}
        let isDoubleNum = string.checkDoubleDecimalNumberString(string: string)
        if isDoubleNum {return true}
        GDAlertView.alert("只可以输入数字", image: nil, time: 2, complateBlock: nil)
        return false
    }
}
