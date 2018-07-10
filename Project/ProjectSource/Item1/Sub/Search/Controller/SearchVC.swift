//
//  SearchVC.swift
//  zuidilao
//
//  Created by wy on 2017/10/12.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
let historyArrPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/historyArr"
class SearchVC: GDNormalVC, UISearchBarDelegate {
    let bag = DisposeBag()
    let viewModel: SearchVieModel = SearchVieModel.init()
    var mainView: SearchMainView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = SearchMainView.init(withModel: viewModel)
        self.myAddSubview()
        configNatitleView()
        
        self.configmentSearchBtn()
        self.naviBar.backgroundColor = UIColor.white
        
        
        self.viewModel.itemClick.subscribe { [weak self](result) in
            guard let title = result.element?.1 else {
                return
            }
            self?.navigationController?.pushViewController(GDNormalVC(), animated: true)
        }
        
        // Do any additional setup after loading the view.
    }

    func myAddSubview() {
        self.view.addSubview(self.mainView)
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
    }
    
    override func updateViewConstraints() {
        self.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: DDNavigationBarHeight, left: 0, bottom: 0, right: 0))
            
        }
       
        super.updateViewConstraints()
    }
    
    
    
    
    func configmentSearchBtn() {
        var searchField: UITextField?
        for subView in self.search.subviews {
            if subView is UITextField {
                searchField = subView as! UITextField
            }
        }
        
        if let textfiled = searchField {
            let image = UIImageView.init(image: UIImage.ImageWithColor(color: UIColor.clear, frame: CGRect.init(x: 0, y: 0, width: 0.5, height: 0.5)))
            image.frame = CGRect.init(x: 0, y: 0, width: 0.5, height: 0.5)
            textfiled.leftView = image
        }
        //合并键盘的搜索方法和搜索按钮的搜索
        let searchClick = Observable.merge([self.search.rx.searchButtonClicked.asObservable(),self.searchBtn.rx.tap.asObservable()])
            searchClick.subscribe { [weak self](tap) in
            if let text = self?.search.text, text.characters.count > 0 {
                guard var dataArr = self?.viewModel.items.value else {
                    return
                }
                guard var sectionModel = dataArr.last else {
                    return
                }
                var items = sectionModel.items
                if !items.contains(text) {
                    if items.count > 10 {
                        items.removeLast()
                        items.insert(text, at: 0)
                    }else {
                        items.insert(text, at: 0)
                    }
                    sectionModel.items = items
                    dataArr[1] = sectionModel
                    self?.viewModel.items.value = dataArr
                }
                mylog(self?.navigationController?.pushViewController(GDNormalVC(), animated: true))
                
            }
        }
        
        
        
    }
    
    
    
    @objc func clean(btn: UIButton) {
        let alertVC = UIAlertController.init(title: "\n 确定删除历史记录？\n \n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            
        }
        let trueAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (action) in
            
//            self.dataArr.removeAll()
//            let arr = self.dataArr as NSArray
//            arr.write(toFile: historyArrPath, atomically: true)
//            self.layout?.dataArr = self.dataArr
//            self.myCol?.reloadData()
            
            
        }
        alertVC.addAction(cancleAction)
        alertVC.addAction(trueAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    lazy var topView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    
    
    
    
    
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArr.count
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchColCell", for: indexPath) as! SearchColCell
//        let sectionArr = self.dataArr[indexPath.section]
//        let title = sectionArr[indexPath.item]
//        cell.title = title
//        return cell
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let sectionArr = self.dataArr[indexPath.section]
//        let title = sectionArr[indexPath.item]
//
//        let model = SearchModel.init(dict: nil)
//        model.title = title
//        model.actionkey = "searchList"
//        if let text = model.title {
//            let paramete = ["paramete": text]
//            model.keyparamete = paramete as AnyObject
//            GDSkipManager.skip(viewController: self, model: model)
//        }
//
//
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.characters.count > 0 {
            
            
//            let model = SearchModel.init(dict: nil)
//            model.title = text
//            model.actionkey = "searchList"
//            let paramete = ["paamete": text]
//            model.keyparamete = paramete as AnyObject
//            var isAppend: Bool = false
//            var historyArr = self.dataArr.last
//            for title in historyArr! {
//                if title == text {
//                    isAppend = true
//                }
//            }
//            if !isAppend {
//                if historyArr!.count >= 10 {
//                    historyArr?.removeLast()
//                    historyArr?.insert(text, at: 0)
//                }else {
//                    historyArr?.insert(text, at: 0)
//                }
//                
//            }
//            self.dataArr[1] = historyArr!
//            
//            self.layout?.dataArr = dataArr
//            self.myCol?.reloadData()
//            GDSkipManager.skip(viewController: self, model: model)
        }
        
    }
    
    @objc func actionToSearchList(btn: UIButton) {
        self.searchBarSearchButtonClicked(self.search)
    }
    
    
    
    
    
    
    func configNatitleView() {
        self.searchBar.addSubview(self.search)
        self.naviBar.navTitleView = self.searchBar
        self.search.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        searchBtn.setTitle("搜索", for: UIControlState.normal)
        searchBtn.titleLabel?.font = font13
        searchBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(actionToSearchList(btn:)), for: UIControlEvents.touchUpInside)
        self.naviBar.rightBarButtons = [searchBtn]
        searchBtn.rx.tap.asObservable().subscribe { (tap) in
            
        }
        
        
    }
    let searchBtn: UIButton = UIButton.init()
    
    
    
    
    
    lazy var searchBar: NavTitleView = {
        let titleView = NavTitleView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 30))
        titleView.insets = UIEdgeInsets.init(top: 7, left: 10, bottom: 7, right: 54)
        
        return titleView
    }()
    lazy var search: UISearchBar = {
        let sear = UISearchBar.init(frame: CGRect.zero)
        sear.searchBarStyle = UISearchBarStyle.minimal
        
        sear.showsBookmarkButton = false
        sear.prompt = ""
        sear.placeholder = "请输入关键词进行搜索"
        sear.delegate = self
        return sear
    }()
    deinit {
        mylog("销毁")
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
