//
//  DDLocalNotificationManager.swift
//  Project
//
//  Created by WY on 2018/6/29.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
class DDNotification {

    static func postLoginSuccess(){
        self.performPost(NSNotification.Name("loginSuccess"))
    }
    
    static func postAppointChanged(){
        self.performPost(NSNotification.Name("AppointStatusChanged"))
    }
    
    static func postGetCashSuccess(){
        self.performPost(NSNotification.Name("GetCashSuccess"))
    }
    
    static func postNetworkChanged(networkStatus : (oldStatus : Bool , newStatus : Bool ) ){
        self.performPost( NSNotification.Name("DDNetworkChanged"), ["userInfo" : networkStatus])
    }
    
    static func postReloadMessageList(){
        self.performPost(GDReloadMessageList)
    }
    
    static func postReloadMeItem(){
        self.performPost(GDReloadMeItem)
    }
    
    
    static func postTabbarItem1Reclick(){
        self.performPost(DDTabBarItem1Reclick)
    }
    static func postTabbarItem2Reclick(){
        self.performPost(DDTabBarItem2Reclick)
    }
    static func postTabbarItem3Reclick(){
        self.performPost( DDTabBarItem3Reclick)
    }
    static func postTabbarItem4Reclick(){
        self.performPost( DDTabBarItem4Reclick)
    }
    static func postTabbarItem5Reclick(){
        self.performPost( DDTabBarItem5Reclick)
    }
    
    
    static func postLocationChanged(location:CLLocation){
        self.performPost( DDLocationManager.GDLocationChanged,["userInfo" : location])
    }
    
    private static func performPost(_ name:NSNotification.Name  , _ object : Any? = nil  , _  userInfo:[AnyHashable : Any]? = nil ){
        NotificationCenter.default.post(name: name , object: object, userInfo: userInfo)
    }
}
