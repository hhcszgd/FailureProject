//
//  DDDiyNavibarVC.swift
//  Project
//
//  Created by WY on 2018/4/3.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit

class DDDiyNavibarVC: DDProvideForceTouchVC {
     var scrollCritical : CGFloat = 0
//    var scrollCritical : CGFloat {
//        if criticalStore > 0 {
//            return criticalStore
//        }else{
//            if criticalStore < (naviBar?.bounds.height ?? 0) {
//                criticalStore = (naviBar?.bounds.height ?? 0)
//                return criticalStore
//            }else{
//                if DDDevice.type == .iphoneX {return 88}
//                return  64
//            }
//        }
//    }//滚动临界值
    ///自己实现导航栏子控件
    var naviBar : UIView?{
        didSet{
            if let bar = naviBar{
                oldValue?.removeFromSuperview()
                self.view.addSubview(bar)
                bar.backgroundColor = UIColor.DDThemeColor
            }
        }
    }
    private var scrollViews : [UIScrollView] = [UIScrollView]()
    override func viewDidLoad() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "nil" , style: UIBarButtonItemStyle.plain, target: self  , action:  #selector(performGoBack(sender:) ))//去掉title
        
        super.viewDidLoad()
        self._configNavBar()
        // Do any additional setup after loading the view.
    }
    @objc func performGoBack(sender : UITabBarItem) {
        mylog("go back")
    }
    private func _configNavBar()  {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.setNavigationBarHidden(true   , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏1

        if let delegate = self as? UIGestureRecognizerDelegate{
            navigationController?.interactivePopGestureRecognizer?.delegate = delegate
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: true )//自定义导航栏就需要隐藏导航控制器的导航栏2
        if let bar = self.naviBar{
            self.view.bringSubview(toFront: bar)
        }
//        mylog(self.navigationController)
    }
    func popToPreviousVC() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///子类实现
    func contentOffsetInContentInset(scrollView : UIScrollView , scale  : CGFloat)  {//0~1
        //        mylog("contentInset范围内滚动\(scale)")
        //        self.navigationView.changeBackgrouncAlpha(alpha:1 - scale)//改变导航栏透明度
        //        self.navigationView.changeFrame(paramet: scale)//改变导航栏位置
    }
    func contentOffsetBigThanInsetTop(scrollView : UIScrollView ,scale  : CGFloat)  {//0~1
        //        mylog("大于0\(scale)")
    }
    func contentOffsetLessThanInsetTop(scrollView : UIScrollView ,scale  : CGFloat)  {//0~1
        //        mylog("小于0\(scale)")
    }
    func contentOffsetChanged(scrollView : UIScrollView ,contentOffset : CGPoint) {
        //        mylog("监听contentOffsetChanged\(contentOffset)")
    }
    deinit {
        self.removeAllScrollViewObservers()
    }
}

extension DDDiyNavibarVC {
    /// observer scrollView's propotis eg: contentOffset ,contentSize
    public func addObservers(scrollView:UIScrollView) {
        if !scrollViews.contains(scrollView) {
            scrollViews.append(scrollView)
            scrollView.addObserver(self , forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self , forKeyPath: "contentInset", options: NSKeyValueObservingOptions.new, context: nil)
            scrollView.addObserver(self , forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    private final func removeAllScrollViewObservers(){
        scrollViews.forEach {self.removeObservers(scrollView: $0)}
        scrollViews.removeAll()
    }
    private func removeObservers(scrollView:UIScrollView?) {
        if scrollView == nil  {return}
        scrollView!.removeObserver(self , forKeyPath: "contentOffset")
        scrollView!.removeObserver(self , forKeyPath: "contentInset")
        scrollView!.removeObserver(self , forKeyPath: "contentSize")
    }
    
    
    
    override internal  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let scrollView = object as? UIScrollView
        
        if keyPath != nil && keyPath! == "contentOffset" && scrollView != nil {
            if let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint{
                self.contentOffsetChanged(scrollView : scrollView! ,contentOffset: newPoint)
                let contentInset  = scrollView!.contentInset
                if contentInset.top < 0 {//应该没人这么干
                }else{
//                    self.naviBar.change(by: scrollView!)
                    if newPoint.y < -contentInset.top {//滚完inset后,继续往下拖动 , y值<-top
                        let cha = -newPoint.y - contentInset.top
                        if cha <= self.scrollCritical {
                            self.contentOffsetLessThanInsetTop(scrollView : scrollView! , scale: cha / self.scrollCritical)
                        }
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: 0)//使inset外继续可以调用这个方法
                    }
                    if newPoint.y >= -contentInset.top && newPoint.y <= 0   {//在inset范围内滚动
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: ((scrollView?.contentInset.top)! + newPoint.y) / (scrollView?.contentInset.top)!)
                    }
                    if newPoint.y >= 0   {//滚到scrollView控件的边缘后 , 继续往上拖动
                        let cha = newPoint.y
                        if cha <= self.scrollCritical {
                            self.contentOffsetBigThanInsetTop(scrollView : scrollView! ,scale: cha / self.scrollCritical)
                        }
                        self.contentOffsetInContentInset(scrollView : scrollView! ,scale: 1)//使inset外继续可以调用这个方法
                    }
                }
                
                
            }
        }else if keyPath != nil && keyPath! == "contentInset"{
            if  let newContentInset = change?[NSKeyValueChangeKey.newKey] as? CGRectEdge{
                //                mylog("监听contentInset : \(String(describing: newContentInset))")
                
            }
            
        }else if keyPath != nil && keyPath! == "contentSize"{
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                //                mylog("监听contentSize : \(String(describing: newSize))")
                
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}
class DDNaviBar : UIView {
    lazy var titleLabel = { () -> UILabel in
       let label = UILabel()
        label.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height - 44 / 2)
        label.sizeToFit()
        return label
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        if let  superV = self.superview{
            self.snp.remakeConstraints { (make ) in
                make.left.top.right.equalTo(superV)
                make.height.equalTo(self.bounds.height)
            }
        }
    }
}
