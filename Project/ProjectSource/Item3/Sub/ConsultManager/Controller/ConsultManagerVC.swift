//
//  ConsultManagerVC.swift
//  Project
//
//  Created by wy on 2018/4/19.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ConsultManagerVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.request()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "协商管理")
        self.tableView.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - TabBarHeight)
        self.tableView.register(ConsultCell.self, forCellReuseIdentifier: "ConsultCell")
        self.tableView.separatorStyle = .none
        
        
        // Do any additional setup after loading the view.
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell: ConsultCell = tableView.dequeueReusableCell(withIdentifier: "ConsultCell", for: indexPath) as! ConsultCell
        resultCell.model = self.dataArr[indexPath.row]
        return resultCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataArr[indexPath.row]
        
        self.navigationController?.pushVC(vcIdentifier: "ConsultDetailVC", userInfo: model)
    }
    
    var dataArr: [ConsultModel] = [ConsultModel]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    func request() {
        
        
        let router = Router.post("Consult/rest", .api, nil, nil)
        NetWork.manager.requestData(router: router, type: [ConsultModel].self).subscribe(onNext: { (model) in
            if let data = model.data, model.status == 200 {
                self.dataArr = data
            }else {
                DDErrorView.init(superView: self.view, error: DDError.noExpectData("无协商")).automaticRemoveAfterActionHandle = {
                    self.request()
                }
                self.view.bringSubview(toFront: self.naviBar)
            }
        }, onError: { (error) in
            DDErrorView.init(superView: self.view, error: DDError.networkError).automaticRemoveAfterActionHandle = {
                self.request()
            }
            self.view.bringSubview(toFront: self.naviBar)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
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




