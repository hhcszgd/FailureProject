
//
//  DDShopsInMapVC.swift
//  Project
//
//  Created by WY on 2017/12/8.
//  Copyright © 2017年 HHCSZGD. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class DDShopsInMapVC: DDNoNavibarVC , UITextFieldDelegate{
    let zoomBig = UIButton.init(frame: CGRect.zero)
    let zoomSmall = UIButton.init(frame: CGRect.zero)
    let userLocation = UIButton.init(frame: CGRect.zero)
    let map = GDMapInView.init(frame: CGRect.zero)
//    var locations  = [DDCoordinate]()
    var locations  : [GDLocation] =  [GDLocation]()
    var zoomLevel : CLLocationDegrees = 0.00
    let searchBox = UITextField.init(frame: CGRect.zero)
    let backBtn  = UIButton.init()
    convenience init(locations:[GDLocation]){
        self.init()
        
        for location  in locations {
            mylog(location.title)
        }
        
        let tempLocations = getArrSortByCloseToUser(locations: locations)//离用户定位位置 就近排序
        self.locations = getArrSortByCloseToClose(locations: tempLocations)//在就近排序基础上,按下个地点距离远近依次排序
//        for location  in self.locations {mylog(location.title)}
    }
    ///离用户定位位置 就近排序
    func getArrSortByCloseToUser(locations : [GDLocation]) -> [GDLocation] {//
        let temp  = locations.sorted { (locationPrivious, locationNext) -> Bool in
            let userLocationCoordinate =  DDLocationManager.share.locationManager.location?.coordinate ?? CLLocationCoordinate2D.init()
            let priviousCha = hypotf(Float(abs( locationPrivious.coordinate.latitude - userLocationCoordinate.latitude )), Float(abs( locationPrivious.coordinate.longitude - userLocationCoordinate.longitude)))
            let nextCha = hypotf(Float(abs( locationNext.coordinate.latitude - userLocationCoordinate.latitude )), Float(abs( locationNext.coordinate.longitude - userLocationCoordinate.longitude)))
            return priviousCha < nextCha
        }
        return temp
    }
    /// 在就近排序基础上,按下个地点距离远近依次排序
    func getArrSortByCloseToClose(locations: [GDLocation]) ->  [GDLocation]{
        var  temp = [GDLocation]()
        var locations = locations
        let baseLocation = GDLocation()
        baseLocation.coordinate = DDLocationManager.share.locationManager.location?.coordinate ?? CLLocationCoordinate2D.init()//
        
        while locations.count > 0  {
            let minlocation = locations.min { (locationPrivious, locationNext) -> Bool in
                var lastLocation : GDLocation
                if let last = temp.last{
                    lastLocation = last
                }else{
                    lastLocation = locations.first ?? baseLocation//第一次以用户位置为标准,找离用户最近的店铺坐标
                }
                
                let priviousCha = hypotf(Float(abs( locationPrivious.coordinate.latitude - lastLocation.coordinate.latitude )), Float(abs( locationPrivious.coordinate.longitude - lastLocation.coordinate.longitude)))
                let nextCha = hypotf(Float(abs( locationNext.coordinate.latitude - lastLocation.coordinate.latitude )), Float(abs( locationNext.coordinate.longitude - lastLocation.coordinate.longitude)))
                return priviousCha < nextCha
            }
            if let unWrapMin = minlocation{
                temp.append(unWrapMin)
                if let index = locations.index(of: unWrapMin){
                    locations.remove(at: index)
                }
                
            }
        }
        return temp
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNaviBar()
        self.configMap()
        configSubviews()
        // Do any additional setup after loading the view.
    }
    func configSubviews() {
        self.view.addSubview(zoomBig)
        self.view.addSubview(zoomSmall)
        let zoomBtnWH : CGFloat = 33
        zoomBig.frame = CGRect(x:self.view.bounds.width - (zoomBtnWH + 10), y: self.view.center.y + zoomBtnWH, width: zoomBtnWH, height: zoomBtnWH)
        
        zoomSmall.frame = CGRect(x: zoomBig.frame.minX, y: zoomBig.frame.maxY + 10, width: zoomBtnWH, height: zoomBtnWH)
        
        zoomBig.backgroundColor = UIColor.blue
        zoomBig.setTitle("大", for: UIControlState.normal)
        zoomSmall.backgroundColor = UIColor.blue
        zoomSmall.setTitle("小", for: UIControlState.normal)
        zoomBig.addTarget(self , action: #selector(zoomLevelUp), for: UIControlEvents.touchUpInside)
        zoomSmall.addTarget(self , action: #selector(zoomLevelDown), for: UIControlEvents.touchUpInside)
        zoomLevel = self.map.mapView.region.span.latitudeDelta
        
        self.view.addSubview(userLocation)
        userLocation.frame = CGRect(x: 10, y: zoomSmall.frame.minY, width: zoomBtnWH, height: zoomBtnWH)
        userLocation.backgroundColor = UIColor.green
        userLocation.addTarget(self , action: #selector(comebackUserLocation), for: UIControlEvents.touchUpInside)
        userLocation.setTitle("我", for: UIControlState.normal)
        
        self.naviBar.addSubview(searchBox)
        
        searchBox.delegate = self
        searchBox.returnKeyType = UIReturnKeyType.search
        let searchBoxH : CGFloat = 30
        searchBox.bounds  = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 44 * 2 - 20, height: searchBoxH)
        searchBox.center = CGPoint(x: self.naviBar.bounds.width/2, y: backBtn.center.y)
        searchBox.clearButtonMode = UITextFieldViewMode.always
        //        searchBox.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        //        searchBox.borderStyle = UITextBorderStyle.none // UITextBorderStyle.roundedRect
        searchBox.borderStyle =  UITextBorderStyle.roundedRect
//        let rightView = UIButton(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
//        let img = UIImage(named: "search")
//        img?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        rightView.setImage(img, for: UIControlState.normal)
//        rightView.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.7, alpha: 1)
        //        rightView.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
//        searchBox.rightView = rightView
//        searchBox.rightViewMode = .always
        searchBox.placeholder = "河南烩面"
    }
    @objc func comebackUserLocation(){
        self.map.mapView.setCenter(self.map.mapView.userLocation.coordinate, animated: true)
    }
    //textfieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        self.navigationController?.pushViewController(DDSearchVC(), animated: true)
        return false
    }
    
    @objc func zoomLevelDown() {
        zoomLevel = self.map.mapView.region.span.latitudeDelta
        zoomLevel *= 2
        if self.zoomLevel >= 111 {
            zoomLevel = 111
        }
        self.performZoom()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.map.mapView.setRegion(MKCoordinateRegion.init(center: self.map.mapView.userLocation.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true )
    }
    @objc func zoomLevelUp() {
        zoomLevel = self.map.mapView.region.span.latitudeDelta
        zoomLevel /= 2
        if self.zoomLevel <= 0.001 {
            zoomLevel = 0.001
        }
        self.performZoom()

    }
    
    func performZoom()  {
        let coordinate = self.map.mapView.centerCoordinate
        let span = MKCoordinateSpan.init(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        self.map.mapView.setRegion(region, animated: true)
    }
    func configNaviBar()  {
        let btnWH : CGFloat = 44
        let button = UIButton.init(frame: CGRect(x: naviBar.bounds.width - btnWH - 10  , y: naviBar.bounds.height - btnWH, width: btnWH, height: btnWH))
        button.setTitle("针", for: UIControlState.normal)
        button.addTarget(self , action: #selector(location), for: UIControlEvents.touchUpInside)
        naviBar.addSubview(button)
        backBtn.frame =  CGRect(x: 10, y: self.naviBar.height - 44, width: 44, height: 44)
//        backBtn.backgroundColor = UIColor.purple
        backBtn.setTitle("返回", for: UIControlState.normal )
        backBtn.addTarget(self , action: #selector(goback), for: UIControlEvents.touchUpInside)
        naviBar.addSubview(backBtn)
    }
    @objc func goback(){
        self.popToPreviousVC()
    }
    ///按地址数组顺序划线  
    @objc func drawNaviLine(){
        for location  in locations {
            mylog(location.title)
        }
        for ( index , location ) in locations.enumerated() {
            if index < (locations.count - 1){
                let currentLocation = location
                let nextLocation = locations[index + 1]
                self.map.drawLineMethod(sourceCoordinate: currentLocation.coordinate, destinationCoordinate: nextLocation.coordinate,transportType: .walking)
            }
            self.map.mapView.addAnnotation(location)
        }
    }
    @objc func location()  {
        drawNaviLine()
//        let annotation : GDLocation = GDLocation.init()
//        annotation.coordinate = CLLocationCoordinate2D.init(latitude: 39.831789 , longitude: 116.288058)
//        self.map.mapView.addAnnotation(annotation)
//
//
//
//        let annotationStart : GDLocation = GDLocation.init()
//        annotationStart.coordinate = CLLocationCoordinate2D.init(latitude: 39.83157500, longitude: 116.28728700)
//        annotationStart.title = "分台区时代财富天地大厦"
//        let annotationEnd : GDLocation = GDLocation.init()
//        annotationEnd.coordinate = CLLocationCoordinate2D.init(latitude: 39.84080100, longitude: 116.28746200)
//        annotationEnd.title = "丰台区看丹桥"
//        self.map.mapView.addAnnotation(annotationStart)
//        self.map.mapView.addAnnotation(annotationEnd)
//
//        self.map.drawLineMethod(sourceCoordinate: CLLocationCoordinate2D.init(latitude: 39.83157500, longitude: 116.28728700), destinationCoordinate: CLLocationCoordinate2D.init(latitude: 39.84080100, longitude: 116.28746200) , transportType: .walking)
//
//        let annotationMid : GDLocation = GDLocation.init()
//        annotationMid.coordinate = CLLocationCoordinate2D.init(latitude: 39.83248000, longitude: 116.29743200)
//        annotationMid.title = "丰台区科怡路"
//        annotationMid.subtitle = "地/铁站"
//
//        self.map.mapView.addAnnotation(annotationMid)
//
//        self.map.drawLineMethod(sourceCoordinate: CLLocationCoordinate2D.init(latitude: 39.83157500, longitude: 116.28728700), destinationCoordinate: CLLocationCoordinate2D.init(latitude: 39.83248000, longitude: 116.29743200) , transportType: .walking)
    }
    func configMap()  {
        self.view.addSubview(map)
        map.frame = self.view.bounds
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
