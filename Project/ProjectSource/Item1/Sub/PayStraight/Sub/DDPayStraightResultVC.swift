//
//  DDPayStraightResultVC.swift
//  Project
//
//  Created by WY on 2018/4/18.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPayStraightResultVC: DDNormalVC {
    var result : Bool = true
    let imageView = UIImageView()
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.removeSpecifyVC(DDPayStraightVC.self )
        self.view.addSubview(imageView)
        self.view.addSubview(label)
        label.textAlignment = .center
        label.textColor = UIColor.DDTitleColor
        if result {
            successLayout()
        }
        // Do any additional setup after loading the view.
    }
    func successLayout() {
        self.title = "付款成功"
        label.text = "直接付款成功"
        imageView.image = UIImage(named:"successicon")
        let iamgeViewWH : CGFloat = 160
        imageView.frame = CGRect(x: (self.view.bounds.width - iamgeViewWH ) / 2, y: 200, width: iamgeViewWH, height: iamgeViewWH)
        label.frame = CGRect(x: 0, y:imageView.frame.maxY + 20 , width: self.view.bounds.width, height: 40)
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
