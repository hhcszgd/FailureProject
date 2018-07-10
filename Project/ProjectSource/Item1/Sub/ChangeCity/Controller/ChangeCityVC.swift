//
//  ChangeCityVC.swift
//  zuidilao
//
//  Created by wy on 2017/11/9.
//  Copyright © 2017年 wy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class ChangeCityVC: GDNormalVC {
    let viewModel = FSelectCityModel.init()
    let locationManager = LocationManager.init()
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getData()
        self.configNatitleView()
        viewModel.changeState(viewController: self)
        self.setUI()
        // Do any additional setup after loading the view.
    }


    
    
    lazy var table : UITableView = {
        let temp = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)//
        self.view.addSubview(temp)
        temp.delegate = self
        temp.frame = self.view.bounds
        return temp
        
    }()
    deinit {
        mylog("切换语言页面销毁")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.cityItems.value.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    lazy var searchBar: NavTitleView = {
        let titleView = NavTitleView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 30))
        titleView.insets = UIEdgeInsets.init(top: 7, left: 10, bottom: 7, right: 5)
        
        return titleView
    }()
    lazy var search: UISearchBar = {
        let sear = UISearchBar.init(frame: CGRect.zero)
        sear.searchBarStyle = UISearchBarStyle.minimal
        sear.showsBookmarkButton = false
        sear.prompt = ""
        sear.placeholder = "城市名，城市邮编"
        return sear
    }()
    
    let changeCountryBtn: UIButton = UIButton.init()
}
///布局导航栏，并且处理导航栏上的交互
extension ChangeCityVC {
    func configNatitleView() {
        changeCountryBtn.setTitle("切换国家", for: UIControlState.normal)
        changeCountryBtn.titleLabel?.font = font13
        changeCountryBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        changeCountryBtn.frame = CGRect.init(x: 0, y: 0, width: 88, height: 44)
       
        self.naviBar.rightBarButtons = [changeCountryBtn]
        changeCountryBtn.rx.tap.asObservable().subscribe { (tap) in
            mylog("切换国家")
        }
        
        self.searchBar.addSubview(self.search)
        self.naviBar.navTitleView = self.searchBar
        self.search.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        }

        
    }
    
}
extension ChangeCityVC {
    func setUI() {
        self.view.addSubview(self.table)
        self.table.dataSource = nil
        self.table.sectionIndexBackgroundColor = UIColor.clear
        self.table.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: DDNavigationBarHeight, left: 0, bottom: -bottom, right: 0))
        }
        let tableViewHeader = FCityHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: SCREENWIDTH, height: 50))
        self.table.tableHeaderView = tableViewHeader
        locationManager.currentCity.subscribe(onNext: { [weak self](city) in
            tableViewHeader.currentCity.text = city
            }, onError: { (error) in
                mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }
        
        self.table.register(FCityCell.self, forCellReuseIdentifier: "FCityCell")
        self.table.register(FCityOtherCell.self, forCellReuseIdentifier: "FCityOtherCell")
        self.table.register(CityHeaderView.self, forHeaderFooterViewReuseIdentifier: "CityHeaderView")
        self.table.register(CityFooterView.self, forHeaderFooterViewReuseIdentifier: "CityFooterView")
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CityModel>>.init(configureCell: {[weak self](source, table, index , model) -> UITableViewCell in
            let sectionModel = self?.viewModel.cityItems.value[index.section]
            
            if sectionModel?.model == "history" {
                let cell: FCityCell = table.dequeueReusableCell(withIdentifier: "FCityCell", for: index) as! FCityCell
                cell.items = model.cityItems
                cell.modelCliclk = { [weak self](model) in
                    mylog(model.cityName)
                }
                return cell
            }else {
                let cell: FCityOtherCell = table.dequeueReusableCell(withIdentifier: "FCityOtherCell", for: index) as! FCityOtherCell
                cell.titleLabel.text = model.cityName
                return cell
            }
        }, titleForHeaderInSection: { (source, num) -> String? in
            return nil
        }, titleForFooterInSection: { (source, num) -> String? in
            return nil
        }, canEditRowAtIndexPath: { (source, index) -> Bool in
            return false
        }, canMoveRowAtIndexPath: { (source, index) -> Bool in
            return false
        }, sectionIndexTitles: { (source) -> [String]? in
            return ["a", "b"]
        }) { (source, title, num) -> Int in
            mylog(num)
            return 0
        }
        
        self.viewModel.cityItems.asObservable().bind(to: self.table.rx.items(dataSource: dataSource)).disposed(by: bag)
        self.viewModel.cityItems.asObservable().subscribe(onNext: { [weak self](dataArr) in
            self?.table.reloadData()
            }, onError: { (error) in
                mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }.disposed(by: bag)
        
    self.table.rx.modelSelected(CityModel.self).asObservable().subscribe(onNext: { [weak self](model) in
        ///历史搜索是一直存在的
        self?.viewModel.configMentHistoryData(model: model)
        }, onError: { (error) in
            mylog(error)
        }, onCompleted: {
            mylog("结束")
        }) {
            mylog("回收")
        }.disposed(by: bag)
        
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CityHeaderView") as! CityHeaderView
        let sectionModel = self.viewModel.cityItems.value[section]
        let title = (sectionModel.model == "history") ? "历史搜索" : sectionModel.model
        header.titleLabel.text = title
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CityFooterView") as! CityFooterView
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = self.viewModel.cityItems.value[indexPath.section]
        if sectionModel.model == "history" {
           guard let items = sectionModel.items.first?.cityItems.flatMap({ (model) -> String? in
                return model.cityName
           }) else {
            return 0
            }
            let height = getCellHeight(dataArr: items)
            return height
        }else {
            return 44
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    
    func getCellHeight(dataArr: [String]) -> CGFloat {
        let leftPadding: CGFloat = 12.0
        let rightPadding: CGFloat = leftPadding
        var totalW: CGFloat = leftPadding
        var totalH: CGFloat = 0
        let margin: CGFloat = 10
        var leftW: CGFloat = SCREENWIDTH - totalW
        totalH += margin
        for (_, title) in dataArr.enumerated() {
            let titleSize = title.sizeWith(font: font13, maxWidth: SCREENWIDTH - 40)
            let width = titleSize.width + 16
            let height = CGFloat(27)
            if width > leftW {
                //换行
                totalH += height + margin
                totalW = leftPadding
            }
            //不换行
            totalW += width + margin
            leftW = SCREENWIDTH - rightPadding - totalW
            
        }
        
        totalH += CGFloat(27) + margin
        return totalH
    }
    
    
}



