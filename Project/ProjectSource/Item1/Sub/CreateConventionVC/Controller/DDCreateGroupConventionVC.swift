//
//  DDCreateGroupConventionVC.swift
//  Project
//
//  Created by WY on 2018/4/11.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
///多人约定
import RxSwift
class DDCreateGroupConventionVC: DDNormalVC {
 
    var appointType: Variable<DDAppointType> = Variable<DDAppointType>.init(.single)
    var collection : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.configCollectionView()
        self.appointType.asObservable().subscribe(onNext: { (type) in
            if type == .single {
                self.title = "一次约定"
                self.collection.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: true)
            }else {
                self.collection.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .left, animated: true)
                self.title = "智能约定"
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        if let arr = self.userInfo as? [DDUserModel]  {
            self.dataArr = arr
        }
        // Do any additional setup after loading the view.
    }
    var dataArr: [DDUserModel] = [DDUserModel]() {
        didSet{
            self.collection.reloadData()
        }
    }
    func getPara() {
        //        if let ID = self.userInfo as? String{//单人
        ////            self.partnerCountType = .single
        //        }else if let IDs = self.userInfo as? [String]{//多人
        ////            self.partnerCountType = .multiple
        //        }else{
        //            mylog("请选择约定成员")
        //        }
    }
    @objc func segmentAction(control: UISegmentedControl) {
        if control.selectedSegmentIndex == 0 {
            self.collection.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: true)
        }else {
            self.collection.scrollToItem(at: IndexPath.init(item:1, section: 0), at: .left, animated: true)
        }
    }
//    lazy var segement: UISegmentedControl = {
//        let control = UISegmentedControl.init(items: ["一次约定", "智能约定"])
//
//        control.layer.borderColor = UIColor.white.cgColor
//        control.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
//        control.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.colorWithHexStringSwift("6a96fc")], for: .selected)
//        control.selectedSegmentIndex = 0
//
//        control.addTarget(self, action: #selector(segmentAction(control:)), for: .valueChanged)
//        return control
//    }()
//
    
    func configNavigationBar() {
//        let container = UIView()
//        self.navigationItem.titleView = container
//        let backBtnWidth : CGFloat = 64
//        let width : CGFloat = (self.navigationController?.navigationBar.bounds.width ?? SCREENWIDTH ) - 200
//        container.frame = CGRect(x: backBtnWidth, y: DDNavigationBarHeight - 44, width: width, height: 30)
//        self.segement.frame = container.bounds
//        container.addSubview(self.segement)
        
        
        
        
        
        
        
    }
    weak var singleCell: ConventionMoreSimpleCell!
    weak var moreCell: ConventionMoreSmartCell!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    //
    func configCollectionView() {
        let collectionFrame = CGRect(x: 0, y: DDNavigationBarHeight, width: SCREENWIDTH, height: SCREENHEIGHT - DDNavigationBarHeight - TabBarHeight)
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = CGSize(width: SCREENWIDTH , height: collectionFrame.height)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collection  = UICollectionView.init(frame: collectionFrame, collectionViewLayout: layout)
        self.collection.bounces = false
        self.view.addSubview(self.collection)
        self.collection.alwaysBounceHorizontal = false
        self.collection.isPagingEnabled = true
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.isPagingEnabled = true
        self.collection.showsHorizontalScrollIndicator = false
        //        self.collection.isScrollEnabled = false//
        self.collection.register(UINib.init(nibName: "ConventionMoreSimpleCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ConventionMoreSimpleCell")
        self.collection.register(UINib.init(nibName: "ConventionMoreSmartCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ConventionMoreSmartCell")
        self.collection.isScrollEnabled = false
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    
    
}
extension DDCreateGroupConventionVC : UICollectionViewDelegate , UICollectionViewDataSource{
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let i = Int(scrollView.contentOffset.x / SCREENWIDTH)
//        self.segement.selectedSegmentIndex = i
//    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    @objc func toSmart() {
        self.collection.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .left, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0  {
            let item: ConventionMoreSimpleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConventionMoreSimpleCell", for: indexPath) as! ConventionMoreSimpleCell
            item.changeBtn.addTarget(self, action: #selector(toSmart), for: .touchUpInside)
            item.delegate = self
            item.peopleNum = self.dataArr.count
            item.users = self.dataArr
            self.singleCell = item
            return item
        }else{
            let item: ConventionMoreSmartCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConventionMoreSmartCell", for: indexPath) as! ConventionMoreSmartCell
            item.delegate = self
            item.peopleNum = self.dataArr.count
            item.users = self.dataArr
            self.moreCell = item
            return item
            
        }
    }
}
extension DDCreateGroupConventionVC: ConventionMoreSimpleCellDelegate {
    func actionToSmart() {
//        self.segement.selectedSegmentIndex = 1
        self.appointType.value = DDAppointType.smart
    }
    
    func actionToConfigVC(userinfo: Any?) {
        ///将约定的组成成员传递给设置报酬页面
       
        let vc = ConfigPriceVC()
        vc.finished = { [weak self] in
            self?.singleCell.configTotalPrice()
        }
        vc.users = self.dataArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func moreSimplePay(userinfo: Any?, finished: (() -> ())?) {
        guard var paramete = userinfo as? [String: String] else {
            finished?()
            return
        }
        let router = Router.post("Liugroupone/groupone", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                let pay = PayVC()
                guard let appointmentID = model.data else {
                    return
                }
                guard let price = paramete["price"] else {
                    return
                }
                let userInfo = ["orderID": appointmentID, "price": price]
                pay.userInfo = userInfo
                self.navigationController?.pushViewController(pay, animated: true)
                
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
            finished?()
        }, onError: { (error) in
            finished?()
        }, onCompleted: {
            finished?()
            mylog("结束")
        }) {
            mylog("回收")
        }
    }
    
}

extension DDCreateGroupConventionVC: ConventionMoreSmartCellDelegate {
    func actionToSimple() {
//        self.segement.selectedSegmentIndex = 0
        self.appointType.value = DDAppointType.single
    }
    func actiontoSmartMoney(userinfo: AnyObject?) {
        let vc = ConfigPriceVC()
        vc.finished = { [weak self] in
            self?.moreCell.configTotalPrice()
        }
        vc.users = self.dataArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func payActionSmart(userinfo: AnyObject?, finished: (() -> ())?) {
        guard var paramete = userinfo as? [String: String] else {
            finished?()
            return
        }
        let router = Router.post("Liugroupwisdom/groupz", .api, paramete, nil)
        NetWork.manager.requestData(router: router, type: String.self).subscribe(onNext: { (model) in
            if model.status == 200 {
                let pay = PayVC()
                guard let appointmentID = model.data else {
                    return
                }
                guard let price = paramete["price"] else {
                    return
                }
                let userInfo = ["orderID": appointmentID, "price": price]
                pay.userInfo = userInfo
                self.navigationController?.pushViewController(pay, animated: true)
            }else {
                GDAlertView.alert(model.message, image: nil, time: 1, complateBlock: nil)
            }
            finished?()
        }, onError: { (error) in
            finished?()
        }, onCompleted: {
            finished?()
            mylog("结束")
        }) {
            mylog("回收")
        }
        
    }
}




