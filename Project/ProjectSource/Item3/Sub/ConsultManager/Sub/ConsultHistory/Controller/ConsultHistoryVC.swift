//
//  ConsultHistoryVC.swift
//  Project
//
//  Created by wy on 2018/4/30.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class ConsultHistoryVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.request()
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "协商历史")
        self.tableView.frame = CGRect.init(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - TabBarHeight)
        self.tableView.register(ConsultCell.self, forCellReuseIdentifier: "ConsultCell")
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "COnsultHistoryCell", bundle: Bundle.main), forCellReuseIdentifier: "COnsultHistoryCell")
        self.tableView.register(ConsultHistoryHeader.self, forHeaderFooterViewReuseIdentifier: "ConsultHistoryHeader")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resultCell: COnsultHistoryCell = tableView.dequeueReusableCell(withIdentifier: "COnsultHistoryCell", for: indexPath) as! COnsultHistoryCell
        resultCell.model = self.dataArr[indexPath.section]
        return resultCell
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConsultHistoryHeader") as! ConsultHistoryHeader
        header.model = self.dataArr[section]
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    var dataArr: [ConsultModel] = [ConsultModel]() {
        didSet{
            self.tableView.reloadData()
        }
    }
    func request() {
        guard let consultModel = self.userInfo as? ConsultModel else { return  }
        guard let vid = consultModel.v_id else { return  }
        guard let aid = consultModel.aid else { return  }
        guard let bid = consultModel.bid else { return  }
        let paramete = ["vid": vid, "aid": aid, "bid": bid]
        let router = Router.post("Consulthistory/rest", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: [ConsultModel].self).subscribe(onNext: { (model) in
            if let data = model.data, model.status == 200 {
                self.dataArr = data
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
        }, onError: { (error) in
            
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
