//
//  DDHudongDetailVC.swift
//  Project
//
//  Created by WY on 2017/12/24.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//da huo

import UIKit

class DDHudongDetailVC: DDNormalVC {
    var dahuoID = ""
    
    convenience init(_ dahuoID:String){
        self.init()
        self.dahuoID = dahuoID
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
