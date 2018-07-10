//
//  DDCreateConventionVC.swift
//  Project
//
//  Created by WY on 2018/1/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
import RxSwift
enum DDAppointType : String {
    case single
    case smart
}
/// 单人约定
class DDCreateConventionVC: DDNormalVC, DDCreateConventionSimpleDelegate, DDCreateConventionSmartDelegate {
  
    
    
    
    

    
    var appointType: Variable<DDAppointType> = Variable<DDAppointType>.init(DDAppointType.single)
    var collection : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavigationBar()
        self.configCollectionView()
        self.appointType.asObservable().subscribe(onNext: { (type) in
            if type == DDAppointType.single {
                self.title = "一次约定"
                self.collection.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: true)
            }else {
                self.title = "智能约定"
                self.collection.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .left, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        // Do any additional setup after loading the view.
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
//    control.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.colorWithHexStringSwift("6a96fc")], for: .selected)
//        control.selectedSegmentIndex = 0
//
//        control.addTarget(self, action: #selector(segmentAction(control:)), for: .valueChanged)
//        return control
//    }()
    
    
    func configNavigationBar() {
//        let container = UIView()
//        self.navigationItem.titleView = container
//        let backBtnWidth : CGFloat = 64
//        let width : CGFloat = (self.navigationController?.navigationBar.bounds.width ?? SCREENWIDTH ) - 200
//        container.frame = CGRect(x: backBtnWidth, y: DDNavigationBarHeight - 44, width: width, height: 30)
//        self.segement.frame = container.bounds
//        container.addSubview(self.segement)
        
        
        
        
        
        
    }
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
        self.collection.isScrollEnabled = false
        self.collection.showsHorizontalScrollIndicator = false
//        self.collection.isScrollEnabled = false//
        self.collection.register(UINib.init(nibName: "DDCreateConventionSimple", bundle: Bundle.main), forCellWithReuseIdentifier: "DDCreateConventionSimple")
        self.collection.register(UINib.init(nibName: "DDCreateConventionSmart", bundle: Bundle.main), forCellWithReuseIdentifier: "DDCreateConventionSmart")
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            self.collection.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
    }
    func payAction(userInfo: AnyObject?, finished: (() -> ())?) {
        guard var paramete = userInfo as? [String: String] else {
            finished?()
            return
        }
        guard let model = self.userInfo as? DDUserModel else {
            finished?()
            return
        }
        paramete["friends_id"] = model.id
        let router = Router.post("Liutest/Singleone", .api, paramete, nil)
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
    ///单人一次约定
    
    func changeConventionTypeToSmart() {
        self.appointType.value = .smart
//        self.segement.selectedSegmentIndex = 1
    }
    ///单人智能约定。
    func conventionSmartPayAction(userinfo: AnyObject, finished: (() -> ())?) {
        guard var paramete = userinfo as? [String: String] else {
            finished?()
            return
        }
        guard let model = self.userInfo as? DDUserModel else {
            finished?()
            return
        }
        paramete["friends_id"] = model.id
        let router = Router.post("Liutest/Singlezn", .api, paramete, nil)
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
    
    ///改变约定方式
    func changeConventionType() {
        self.appointType.value = .single
//        self.segement.selectedSegmentIndex = 0
    }

    
    
    
}
extension DDCreateConventionVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let i = Int(scrollView.contentOffset.x / SCREENWIDTH)
//        self.segement.selectedSegmentIndex = i
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0  {
            let item: DDCreateConventionSimple = collectionView.dequeueReusableCell(withReuseIdentifier: "DDCreateConventionSimple", for: indexPath) as! DDCreateConventionSimple
            
            item.delegate = self
            item.viewController = self
            
            return item
        }else{

            let item: DDCreateConventionSmart = collectionView.dequeueReusableCell(withReuseIdentifier: "DDCreateConventionSmart", for: indexPath) as! DDCreateConventionSmart
            item.delegate = self
            
            return item
        }
    }
}



