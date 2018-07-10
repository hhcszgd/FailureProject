//
//  DDPayPartnersDetailVC.swift
//  Project
//
//  Created by 金曼立 on 2018/5/4.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDPayPartnersDetailVC: DDDiyNavibarVC {

    let detailView = DDPayPartnersDetailView()
    var dict : [String : String]?
    var yueType : String?
    var payDetailModel : DDPayDetailModel?
    var offSet : CGFloat = 0.0
    var startOffSet : CGFloat = 0.0
    var endOffSet : CGFloat = 0.0
    var index = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        configNaviBar()
        
        dict = self.userInfo as? [String : String]
        yueType = dict?["yue_type"] ?? ""
        
        detailView.frame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - DDSliderHeight)
        detailView.collectionView?.register(DDPayDetailCollecCell.self, forCellWithReuseIdentifier: "DDPayDetailCollecCell")
        detailView.tableView.estimatedRowHeight = 100
        detailView.tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(detailView)
        detailView.isHidden = true
        
        var num = ""
        let bid = dict?["bid"] ?? ""
        if yueType == "2" && bid.count == 0 {
            // 群约 多期
            num = dict?["num"] ?? ""
            self.detailView.num = num
            self.detailView.yue_type = yueType
            if num == "1" {
                let numRequest = self.dict?["numRequest"] ?? ""
                if numRequest.count != 0 {
                    num = numRequest
                }
                self.detailView.tableView.delegate = self
                self.detailView.tableView.dataSource = self
            } else {
                self.detailView.collectionView?.delegate = self
                self.detailView.collectionView?.dataSource = self
                num = "1"  // 获取第一期的放款详情
            }
        } else {
            self.detailView.tableView.delegate = self
            self.detailView.tableView.dataSource = self
        }
        
        DDRequestManager.share.getPayPartnersDetail(type: ApiModel<DDPayDetailModel>.self, order_id: dict?["orderid"] ?? "", num: num, lenders: dict?["lenders"] ?? "", bid: dict?["bid"] ?? "", yue_type: yueType ?? "") { (model) in
            if model?.status == 200 {
                self.detailView.isHidden = false
                self.detailView.payDetailModel = model?.data
                self.payDetailModel = model?.data
                let num = self.payDetailModel?.num ?? ""
                if let num_all = self.payDetailModel?.num_all {
                    if num_all == "1" || num.count == 0 {
                        self.detailView.tableView.reloadData()
                    } else {
                        let numRequest = self.dict?["numRequest"] ?? ""
                        if numRequest.count != 0 {
                            self.detailView.tableView.reloadData()
                        }
                        self.detailView.collectionView?.reloadData()
                    }
                }
            } else {
                GDAlertView.alert(model?.message, image: nil, time: 2, complateBlock: nil)
            }
        }
    }
    
    func configNaviBar() {
        let navBar = DDDetailNav.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: DDNavigationBarHeight))
        navBar.delegate = self
        self.naviBar = navBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DDPayPartnersDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(NSString(string: payDetailModel?.num_all ?? "").intValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDPayDetailCollecCell", for: indexPath) as? DDPayDetailCollecCell
        cell?.tableView.delegate = self
        cell?.tableView.dataSource = self
        cell?.tableView.reloadData()
        return cell!
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        endOffSet = scrollView.contentOffset.x
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffSet = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = startOffSet - endOffSet
        if scrollView == detailView.collectionView {
            if offset < 0 {
                // 左滑
                let indexStr = "\(index)"
                if self.payDetailModel?.num_all == indexStr {
                } else {
                    index += 1
                }
            } else if offset > 0 {
                // 右滑
                if index == 1 {
                } else {
                    index -= 1
                }
            } else {
                return
            }
            DDRequestManager.share.getPayPartnersDetail(type: ApiModel<DDPayDetailModel>.self, order_id: dict?["orderid"] ?? "", num: "\(index)", lenders: dict?["lenders"] ?? "", bid: dict?["bid"] ?? "", yue_type: yueType ?? "") { (model) in
                if model?.status == 200 {
                    self.detailView.payDetailModel = model?.data
                    self.payDetailModel = model?.data
                    self.detailView.collectionView?.reloadData()
                } else {
                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
                }
            }
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offset = startOffSet - endOffSet
//        if scrollView == detailView.collectionView {
//            if scrollView.contentOffset.x > offSet {
//                index += 1
//                mylog("********************************\(index)")
//            } else if scrollView.contentOffset.x < offSet {
//                index -= 1
//                 mylog("******************************\(index)")
//            }
//            offSet = scrollView.contentOffset.x
//
//            DDRequestManager.share.getPayPartnersDetail(type: ApiModel<DDPayDetailModel>.self, order_id: dict?["orderid"] ?? "", num: "\(index)", lenders: dict?["lenders"] ?? "", bid: dict?["bid"] ?? "", yue_type: yueType ?? "") { (model) in
//                if model?.status == 200 {
//                    self.detailView.payDetailModel = model?.data
//                    self.payDetailModel = model?.data
//                    self.detailView.collectionView?.reloadData()
//                } else {
//                    GDAlertView.alert(model?.message, image: nil, time: 1, complateBlock: nil)
//                }
//            }
//        }
//    }
}

extension DDPayPartnersDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payDetailModel?.item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bid = dict?["bid"] ?? ""
        if yueType == "2" && bid.count == 0 {
            // 群约 多期
            var cell = tableView.dequeueReusableCell(withIdentifier: "DDPayDetailCell") as? DDPayDetailCell
            if (cell == nil) {
                cell = DDPayDetailCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPayDetailCell")
            }
            if let num = self.payDetailModel?.num_all {
                if num == "1" {
                    cell?.type = "1"
                } else {
                    cell?.type = "2"
                }
            }
            cell?.payDetailModel = self.payDetailModel?.item?[indexPath.row]
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "DDPayDetailSingleCell") as? DDPayDetailSingleCell
            if (cell == nil) {
                cell = DDPayDetailSingleCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "DDPayDetailSingleCell")
            }
            cell?.payDetailModel = self.payDetailModel?.item?[indexPath.row]
            cell?.stageStr = self.payDetailModel?.num_all
            return cell!
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let bid = dict?["bid"] ?? ""
//        if yueType == "2" && bid.count == 0 {
//            return 70
//        }
//        if let model = self.payDetailModel?.item?[indexPath.row] {
//            if model.status == "4" {
//                // 纠纷未放款
//                return 190
//            }
//            return 120
//        }
//        return 120
//    }
}

extension DDPayPartnersDetailVC : DDDetailNavDelegate {
    func performAction() {
        self.navigationController?.popToSpecifyVC(DDConventionVC.self)
    }
}
