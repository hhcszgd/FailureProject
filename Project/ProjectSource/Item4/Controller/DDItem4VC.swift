//
//  DDItem4VC.swift
//  hhcszgd
//
//  Created by WY on 2017/10/13.
//  Copyright © 2017年 com.16lao. All rights reserved.
//

import UIKit

class DDItem4VC: DDNormalVC {
    var cover  : GDCoverView?

    var collection : UICollectionView!
    let simpleBtn = UIButton()
    let smartBtn = UIButton()
    let h : UISegmentedControl = UISegmentedControl.init()
    var apiModelMe : ApiModel<DDAppointListDataModel>?
    var apiModelOther : ApiModel<DDAppointListDataModel>?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.configCollectionView()
        
        NotificationCenter.default.addObserver(self , selector: #selector(appointStatusChanged(para:)), name: Notification.Name.init("AppointStatusChanged"), object: nil )
        NotificationCenter.default.addObserver(self , selector: #selector(tabbarReclick), name: DDTabBarItem4Reclick, object: nil )
        
        //post(Notification(name: Notification.Name.init("AppointStatusChanged")))
        // Do any additional setup after loading the view.
//        self.configNaviBar()
    }
    
    func configNaviBar() {
        let searchButton = UIBarButtonItem.init(image: UIImage(named:"addpartnericons"), style: UIBarButtonItemStyle.plain, target: self , action: #selector(addPartnerAction(sender:)))
        searchButton.tintColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
        searchButton.setTitlePositionAdjustment(UIOffset.init(horizontal: 9, vertical: 0), for: UIBarMetrics.default)
        self.navigationItem.rightBarButtonItem = searchButton
    }
    @objc func addPartnerAction(sender:UIBarButtonItem)  {
       addBtnClick()
    }
    @objc func appointStatusChanged(para : Notification)  {
        self.collection.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collection.reloadData()
        DDNotification.postNetworkChanged(networkStatus: (oldStatus: true, newStatus: true))
    }
    @objc func tabbarReclick()  {
        let cells =  self.collection.visibleCells
        for ( index , cell)  in cells.enumerated() {
            if let realCell = cell as? DDConventionListItem{
                let type = realCell.type
                realCell.type = type
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self )
    }
    ///1发起 , 2 接收
//    func requestApi(type:String)  {
//        DDRequestManager.share.appointList(type: ApiModel<DDAppointListDataModel>.self, appointType: type) { (model ) in
//            if type == "1"{//发起
//                self.apiModelMe = model
//                self.collection.reloadItems(at: [IndexPath(item: 0, section: 0  )])
//            }else if type == "2"{//接收
//                self.apiModelOther = model
//                self.collection.reloadItems(at: [IndexPath(item: 1, section: 0  )])
//            }
//        }
//    }
    
    func configNavigationBar() {
        let container = UIView()
        self.navigationItem.titleView = container
        let backBtnWidth : CGFloat = 64
        let containerH : CGFloat = 36
        let width : CGFloat = (self.navigationController?.navigationBar.bounds.width ?? SCREENWIDTH ) - backBtnWidth * 2
        container.frame = CGRect(x: backBtnWidth, y: DDNavigationBarHeight - 44 + (44 - containerH)/2, width: width, height: containerH)
        container.layer.cornerRadius = 4
        container.layer.masksToBounds = true
        container.addSubview(simpleBtn)
        container.layer.borderColor = UIColor.white.cgColor
        container.layer.borderWidth = 1
        container.addSubview(smartBtn)
        //        simpleBtn.contentHorizontalAlignment = .right
        //        smartBtn.contentHorizontalAlignment = .left
        simpleBtn.frame = CGRect(x: 0, y: 0, width: width/2, height: containerH)
        smartBtn.frame = CGRect(x: width/2, y: 0, width: width/2, height: containerH)
        let  simpleSelectTitle = NSMutableAttributedString.init(string: "甲方")
        simpleSelectTitle.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18) , NSAttributedStringKey.foregroundColor : UIColor.DDThemeColor], range: NSRange.init(location: 0, length: simpleSelectTitle.string.count))
        
        let  simpleNormalTitle = NSMutableAttributedString.init(string: "甲方")
        simpleNormalTitle.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor : UIColor.white], range: NSRange.init(location: 0, length: simpleNormalTitle.string.count))
        
        
        
        simpleBtn.setAttributedTitle(simpleNormalTitle, for: UIControlState.normal)
        simpleBtn.setAttributedTitle(simpleSelectTitle, for: UIControlState.selected)
        
        
        
        let  smartSelectTitle = NSMutableAttributedString.init(string: "乙方")
        smartSelectTitle.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.DDThemeColor], range: NSRange.init(location: 0, length: smartSelectTitle.string.count))
        
        let  smartNormalTitle = NSMutableAttributedString.init(string: "乙方")
        smartNormalTitle.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor : UIColor.white], range: NSRange.init(location: 0, length: smartNormalTitle.string.count))
        
        
        
        smartBtn.setAttributedTitle(smartNormalTitle, for: UIControlState.normal)
        smartBtn.setAttributedTitle(smartSelectTitle, for: UIControlState.selected)
        
        smartBtn.addTarget(self , action: #selector(senderClick(sender:)), for: UIControlEvents.touchUpInside)
        simpleBtn.addTarget(self , action: #selector(senderClick(sender:)), for: UIControlEvents.touchUpInside)
        simpleBtn.isSelected = true
        setBackgroundColor(firstIsSelected: true )
        
    }
    @objc func senderClick(sender:UIButton) {
        if sender.isSelected {return}
        sender.isSelected = !sender.isSelected
        if sender == self.simpleBtn {
            self.smartBtn.isSelected = !sender.isSelected
            self.collection.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
            setBackgroundColor(firstIsSelected: true )
        }else if sender == self.smartBtn{
            self.simpleBtn.isSelected = !sender.isSelected
            
            self.collection.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
            setBackgroundColor(firstIsSelected: false  )
        }
        
    }
    func setBackgroundColor(firstIsSelected:Bool)  {
        if firstIsSelected {
            
            self.simpleBtn.backgroundColor = UIColor.white
            self.smartBtn.backgroundColor = UIColor.clear
        }else{
            self.smartBtn.backgroundColor = UIColor.white
            self.simpleBtn.backgroundColor = UIColor.clear
        }
    }
    func configCollectionView() {
        let collectionFrame = CGRect(x: 0, y: DDNavigationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - DDNavigationBarHeight - DDTabBarHeight)
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: self.view.bounds.width , height: collectionFrame.height)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collection  = UICollectionView.init(frame: collectionFrame, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        self.collection.bounces = false
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        self.view.addSubview(self.collection)
        self.collection.alwaysBounceHorizontal = false
        self.collection.isPagingEnabled = true
        self.collection.delegate = self
        self.collection.dataSource = self

        self.collection.register(DDConventionListItem.self , forCellWithReuseIdentifier: "DDConventionListItemLeft")
         self.collection.register(DDConventionListItem.self , forCellWithReuseIdentifier: "DDConventionListItemRight")
    }
}
extension DDItem4VC : UICollectionViewDelegate , UICollectionViewDataSource , DDConventionListItemDelegate{
    func didSelectRowAt(indexPath: IndexPath, cellModel: DDAppointListCellModel) {
        var privateOrPublic = ""
        if let temp  = cellModel.type{
            privateOrPublic = temp
        }
        if indexPath.item == 0 {//付款方列表
             self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": cellModel.value_code , "userType":"2","privateOrPublic":privateOrPublic,"yue_type":cellModel.yue_type ?? ""])//请求详情接口时付款方标识为2
        }else{//收款方列表
            self.navigationController?.pushVC(vcIdentifier: "DDConventionVC", userInfo: ["orderID": cellModel.value_code , "userType":"1" , "privateOrPublic":privateOrPublic , "yue_type":"1" /*, "yiFangID":DDAccount.share.id*/])//请求详情接口时收款方标识为1
            
           
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0 {
            self.smartBtn.isSelected = false
            self.simpleBtn.isSelected = true
            setBackgroundColor(firstIsSelected: true )
        }else{
            self.smartBtn.isSelected = true
            self.simpleBtn.isSelected = false
            setBackgroundColor(firstIsSelected: false )
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0  {//付款方
            let item = collection.dequeueReusableCell(withReuseIdentifier: "DDConventionListItemLeft", for: indexPath)
            if let itemUnwrap = item as? DDConventionListItem{
                itemUnwrap.delegate = self
                itemUnwrap.type = "1"
            }
            item.backgroundColor = UIColor.red
            return item
        }else{
            
            let item = collection.dequeueReusableCell(withReuseIdentifier: "DDConventionListItemRight", for: indexPath)
            if let itemUnwrap = item as? DDConventionListItem{
                itemUnwrap.delegate = self
                itemUnwrap.type = "2"
            }
            item.backgroundColor = UIColor.green
            return item
        }
    }
}


extension DDItem4VC {
    @objc func corverItemClick(sender:UIButton){
        mylog(sender.tag)
        //to do something
        switch sender.tag {
        case 0:
            mylog("0")
//            readyForScanning()
        case 1:
            mylog("1")
//            createAppointAction()
        case 2:
            mylog("2")
//            self.addPartner()
            
        case 3:
            mylog("3")
//            self.payAction()
        case 4:
            mylog("4")
//            self.getCashAction()
            
        default:
            break
        }
        self.cover?.remove()
        self.cover = nil
    }
    @objc func addBtnClick(){
        if self.cover != nil {
            conerClick(sender: self.cover!)
            return
        }
        //        let titles = [" 扫一扫"," 发起约定"," 添加伙伴"," 直接付款"," 提  现"]修改
        //        let titles = [" 扫一扫"," 发起约定"," 添加伙伴"]
        let titles = [" 全部约定"," 一次约定"," 智能约定"," 公开约定"]
        // ****************  wangyuanfei  **********************
        //        let imageNames = ["scan_icon_small","convention_icon_small","addpartnericons 2","payment_icon_small","withdrawal_icon 2"]//修改
        //        let imageNames = ["scan_icon_small","convention_icon_small","addpartnericons 2"]
        let imageNames = ["scan_icon_small","convention_icon_small","addpartnericons 2","payment_icon_small"]
        // *****************************************************
        //        let imageNames = ["withdrawal_icon 2","withdrawal_icon 2","withdrawal_icon 2","withdrawal_icon 2","withdrawal_icon 2"]
        cover = GDCoverView.init(superView: self.view)
        cover?.addTarget(self , action: #selector(conerClick(sender:)) , for: UIControlEvents.touchUpInside)
        //            cover?.layoutViewToBeShow(action: { () in
        for index in 0..<titles.count{
            let button  = UIButton.init(frame:CGRect(x: SCREENWIDTH, y: DDNavigationBarHeight + CGFloat(44 * index), width: 88, height: 40))
            button.tag = index
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
            button.addTarget(self , action: #selector(corverItemClick(sender:)), for: UIControlEvents.touchUpInside)
            cover?.addSubview(button)
            button.backgroundColor = UIColor.DDThemeColor
            button.setTitle(titles[index], for: UIControlState.normal)
            button.setImage(UIImage(named:imageNames[index]), for: UIControlState.normal)
        }
        for (index ,view) in (self.cover?.subviews.enumerated())!{
            UIView.animate(withDuration: 0.3, delay: TimeInterval(CGFloat(index) * 0.05), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                view.frame = CGRect(x: SCREENWIDTH - 88 , y: DDNavigationBarHeight + CGFloat(44 * index), width: 88, height: 40)
            }, completion: { (bool ) in
                
            })
        }
        
    }
    
    @objc func conerClick(sender : GDCoverView)  {
        for (index ,view) in sender.subviews.enumerated(){
            UIView.animate(withDuration: 0.3, delay: TimeInterval(CGFloat(index) * 0.05), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                view.frame = CGRect(x: SCREENWIDTH + 22 , y: DDNavigationBarHeight + CGFloat(44 * index), width: 88, height: 40)
            }, completion: { (bool ) in
                sender.remove()
                self.cover = nil
            })
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cover = self.cover{
            self.conerClick(sender: cover)
        }
    }
}
