//
//  UINavigationController+extention.swift
//  Project
//
//  Created by WY on 2018/3/14.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

extension UINavigationController{
@discardableResult
    func popToSpecifyVC(_ vcType : UIViewController.Type , animate:Bool = true ) -> UIViewController? {
        for vc  in self.viewControllers{
            if vc.isKind(of: vcType){
                self.popToViewController(vc , animated: animate)
                return vc
            }
        }
        return nil
    }
    
    @discardableResult
    func removeSpecifyVC(_ vcType : UIViewController.Type  ) -> UIViewController? {
        for index in  0..<self.viewControllers.count {
            let targetIndex = self.viewControllers.count - 1 - index
            let targetVC = self.viewControllers[targetIndex]
            if targetVC.isKind(of: vcType){
                self.viewControllers.remove(at: targetIndex)
//                targetVC.removeFromParentViewController()
//                targetVC.willMove(toParentViewController: nil)
//                targetVC.view.removeFromSuperview()
//                mylog(targetIndex)
//                dump(targetVC)
                return targetVC
            }
        }
        return nil
    }
    
    func pushVC(vcIdentifier : String , userInfo:Any? = nil ) {
//        if needLogin {
            //show login vc
            //return
//        }
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]as! String
        var clsName = vcIdentifier
        if !vcIdentifier.hasPrefix(namespace + ".") {
            clsName = namespace + "." + vcIdentifier
        }
        //UICollectionViewController
        if let cls = NSClassFromString(clsName) as? UICollectionViewController.Type{
            let vc = cls.init(collectionViewLayout: UICollectionViewFlowLayout())
            vc.userInfo = userInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }else if let cls = NSClassFromString(clsName) as? UIViewController.Type{
            let vc = cls.init()
            vc.userInfo = userInfo
            self.pushViewController(vc, animated: true)
        }else{
            print("there is no class:\(vcIdentifier)  from string:\(vcIdentifier)")
        }
    }
}
