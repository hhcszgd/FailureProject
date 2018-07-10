//
//  TransactionInfoVC.swift
//  Project
//
//  Created by wy on 2018/4/5.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class TransactionInfoVC: GDNormalVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresh()
        self.naviBar.attributeTitle = GDNavigatBar.attributeTitle(text: "交易记录")
        self.view.backgroundColor = UIColor.colorWithRGB(red: 234, green: 238, blue: 243)
        self.configTableView()
//        self.naviBar.rightBarButtons = [screenBtn]
        
        // Do any additional setup after loading the view.
    }
    ///筛选按钮
    lazy var screenBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("筛选", for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(screenBtnAction(sender:)), for: .touchUpInside)
        return btn
    }()
    var transactionType: TransactionType = TransactionType.allClass
    @objc func screenBtnAction(sender: UIButton) {
        self.cover = DDCoverView.init(superView: self.view)
        self.cover?.isHideWhenWhitespaceClick = true
        self.cover?.deinitHandle = {
            self.cover?.removeFromSuperview()
            self.cover = nil
        }
        let containerView = TransactionClassView.init(frame: CGRect.init(x: 0, y: SCREENHEIGHT - 180 - DDSliderHeight, width: SCREENWIDTH, height: 180 + DDSliderHeight), type: self.transactionType)
        self.cover?.addSubview(containerView)
        containerView.finished = { [weak self] (type) in
            self?.transactionType = type
            self?.refresh()
            self?.cover?.removeFromSuperview()
            self?.cover = nil
        }
        containerView.closeBtn.addTarget(self, action: #selector(closeBtnAction(sender:)), for: .touchUpInside)
        
    }
    @objc func closeBtnAction(sender: UIButton) {
        self.cover?.removeFromSuperview()
        self.cover = nil
    }
    
    weak var cover: DDCoverView?
    
    
    
    func request(success: @escaping (([TransactionModel]) -> ())) {
//        var spendType: String = "0"
//        switch self.transactionType {
//        case .allClass:
//            spendType = "0"
//        case .income:
//            spendType = "9"
//        case .directPay:
//            spendType = "8"
//        case .appointment:
//            spendType = "1"
//        case .recharge:
//            spendType = "3"
//        case .withDraw:
//            spendType = "4"
//        case .refund:
//            spendType = "2"
//        default:
//            break
//        }
//        let paramete = ["page": self.page, "count": self.count, "spend_type": spendType] as [String : Any]
        let paramete = ["page": self.page, "count": self.count] as [String : Any]
        let router = Router.get("Mttuserinfo/getAccountrecord", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: [TransactionModel].self).subscribe(onNext: { (model) in
            if model.status == 200, let _ = model.data {
                success(model.data ?? [TransactionModel]())
                
            }else {
                success([TransactionModel]())
               
            }
            if self.dataArr.count == 0 {
                DDErrorView.init(superView: self.view, error: DDError.noExpectData("没有交易记录")).automaticRemoveAfterActionHandle = {
                    self.refresh()
                }
                self.view.bringSubview(toFront: self.naviBar)
            }
        }, onError: { (error) in
            DDErrorView.init(superView: self.view, error: DDError.networkError).automaticRemoveAfterActionHandle = {
                self.refresh()
            }
            self.view.bringSubview(toFront: self.naviBar)
            success([TransactionModel]())
        }, onCompleted: nil, onDisposed: nil)
    }
    var dataArr: [TransactionModel] = [TransactionModel]()
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let model = self.dataArr[indexPath.row]
        cell.model = model
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
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
    override func refresh() {
        self.page = 0
        
        self.request { (data) in
            self.refreshHeader.endRefresh(result: GDRefreshResult.success)
            self.dataArr = data
            self.tableView.reloadData()
        }
        
        
    }
    
    override func loadMore() {
        self.page += 1
        self.request { (data) in
            if data.count > 0 {
                self.dataArr += data
                self.refreshFooter.endLoad(result: GDLoadResult.success)
                self.tableView.reloadData()
            }else {
                self.refreshFooter.endLoad(result: GDLoadResult.nomore)
                self.tableView.reloadData()
            }
        }
    }
    var page: Int = 0
    var count: Int = 20

}
extension TransactionInfoVC {
    func configTableView() {
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        self.tableView.frame = CGRect.init(x: 0, y: 15 + DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - 30)
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.gdRefreshControl = refreshHeader
        self.tableView.gdLoadControl = refreshFooter
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
}
class TransactionModel: Codable {
    ///交易ID
    var id: String?
    ///记录名称
    var pay_note: String?
    ///金额
    var price: String?
    ///符号
    var symbol: String?
    ///创建时间
    var create_at: String?
    ///1，成功，0未交易，3,交易失败
    var status: String?
}



