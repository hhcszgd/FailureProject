//
//  DDAlertVC.swift
//  Project
//
//  Created by 金曼立 on 2018/5/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDAlertVC: UIAlertController {

    static func showAlert(currentVC:UIViewController, title: String?, meg: String?, cancelBtn: String, certainBtn: String?, cancelHandler:(() -> Void)?, certainHandler:(() -> Void)?){
        let alertVC = UIAlertController.init(title: title, message: meg, preferredStyle: UIAlertControllerStyle.alert)
        let cancle = UIAlertAction(title: cancelBtn, style: UIAlertActionStyle.default) { (action ) in
            if cancelHandler == nil {
                alertVC.dismiss(animated: true, completion: nil)
            }
        }
        
        let certain = UIAlertAction(title: certainBtn, style: UIAlertActionStyle.destructive) { (action ) in
            certainHandler?()
        }
        alertVC.addAction(cancle)
        alertVC.addAction(certain)
        currentVC.present(alertVC, animated: true) {
        }
    }
    
    static func showAlertOneAction(currentVC:UIViewController, title: String?, meg: String?, cancelBtn: String, cancelHandler:(() -> Void)?){
        let alertVC = UIAlertController.init(title: title, message: meg, preferredStyle: UIAlertControllerStyle.alert)
        let cancle = UIAlertAction(title: cancelBtn, style: UIAlertActionStyle.default) { (action ) in
            if cancelHandler == nil {
                alertVC.dismiss(animated: true, completion: nil)
                return
            }
            cancelHandler?()
        }
        alertVC.addAction(cancle)
        currentVC.present(alertVC, animated: true) {
        }
    }
}
