//
//  LXYNavViewController.swift
//  LXYNavControlSwift
//
//  Created by 李 欣耘 on 15/7/28.
//  Copyright (c) 2015年 LXY. All rights reserved.
//
//"!"表示这个可选变量存在，可以使用，如果用"!"访问不存在的可选变量会导致一些错误
//"?"表示这个变量可能不存在，如果不存在，"?"所在语句后面的内容都不会执行
import UIKit
import Foundation

let WINDOW:UIWindow=UIApplication.sharedApplication().keyWindow!
let kDurationTime:Float=0.3
let kScaleValue:Float=0.95

class LXYNavViewController: UINavigationController,UIGestureRecognizerDelegate {
    
    var startTouch=CGPoint()
    var isMoving:Bool=false
    var blackMask:UIView?
    var lastScreenShotView:UIImageView?
    var backgroundView:UIView?
    var screenShotsList=NSMutableArray()
    var SCREEN_VIEW_WIDTH=Float()
    
    
    override func viewWillAppear(animated: Bool) {
        self.SCREEN_VIEW_WIDTH=Float(self.view.bounds.size.width)
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController);
    }

    // init(){
       //self=self.init()
       // if self{
       //   self.screenShotsList=NSMutableArray(capacity: 2)
       // }
       // return self
    //}
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
       super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //if self{
        self.screenShotsList=NSMutableArray(capacity: 2)
        
        //}
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var panGesture=UIPanGestureRecognizer(target: self, action:"handlePanGesture:")
        
        self.view.addGestureRecognizer(panGesture)
        self.navigationBar.hidden=true
        isMoving=false
        // Do any additional setup after loading the view.
    }

    
    func checkBackgroudViewExist(){//查看背景view的存在与否
    
        if !(self.backgroundView != nil){
        
            var frame:CGRect=self.view.frame
            self.backgroundView=UIView(frame: frame)
            self.backgroundView!.backgroundColor=UIColor.blackColor()
            //将view插入到窗口上，并且below低于self。view层
            WINDOW.insertSubview(self.backgroundView!, belowSubview: self.view)
            
            //在背景view添加黑色的罩
            self.blackMask=UIView(frame: frame)
            self.blackMask!.backgroundColor=UIColor.blackColor()
            self.backgroundView!.addSubview(blackMask!)
            }
        self.backgroundView!.hidden=false
    
    }
    
    func addLastScreenShotView(){//将上一个页面截图加入到下一个页面
        if (lastScreenShotView != nil){
          lastScreenShotView!.removeFromSuperview()
        }
        var lastScreenShot:UIImage=self.screenShotsList.lastObject as! UIImage
        //把截图插入到背景的黑色背景下面
        self.lastScreenShotView=UIImageView(image: lastScreenShot)
        self.backgroundView!.insertSubview(lastScreenShotView!, belowSubview: blackMask!)
    
    }
    
    func handlePanGesture(sender: UIGestureRecognizer) {
        //如果小于1，则说明到了顶层的界面，不需要返回了
        if self.viewControllers.count <= 1{
            return
        }
        var translation=CGPoint()
        translation=sender.locationInView(WINDOW)
        if sender.state == UIGestureRecognizerState(rawValue: 3){
            isMoving=false
            
            //如果结束坐标大于开始坐标50像素就动画效果移动
            if translation.x - startTouch.x > 50{
            
                UIView.animateWithDuration(NSTimeInterval(kDurationTime), animations:{
                     self.moveViewWithX(self.SCREEN_VIEW_WIDTH)
                   
                    }, completion:{finished in
                        self.gesturePopViewControllerAnimated(false)
                        //将view的x设置为0
                        var frame:CGRect=self.view.frame
                        frame.origin.x=0
                        self.view.frame=frame
                })
            }else{
                //不大于50就回到原位
                UIView.animateWithDuration(NSTimeInterval(kDurationTime), animations: {
                   self.moveViewWithX(0)
                   
                    }, completion: {finished in
                   self.backgroundView!.hidden=true
                })
            
            }

        }else if sender.state == UIGestureRecognizerState(rawValue: 1){
            startTouch=translation;
            isMoving=true
            
            self.checkBackgroudViewExist()
            
            self.addLastScreenShotView()
            
        }
        if isMoving==true{
            self.moveViewWithX(Float(translation.x-startTouch.x))
        
        }
        
    
    }
    
    func moveViewWithX(var x:Float){//移动页面的x坐标
        x = x > self.SCREEN_VIEW_WIDTH ? self.SCREEN_VIEW_WIDTH:x
        x = x < 0 ? 0:x
        
        var frame:CGRect=self.view.frame
        frame.origin.x = CGFloat(x)
        self.view.frame=frame
        
        var scale:Float=(x/6400) + kScaleValue//缩放scale
        var alpha:Float=0.4-(x/800);//透明度
        
        lastScreenShotView!.transform=CGAffineTransformMakeScale(CGFloat(scale), CGFloat(scale))
        blackMask!.alpha=CGFloat(alpha)
    }
    
    func ViewRenderImage()->UIImage{//将页面截成一张图片
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var img:UIImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    //重写推进到新页面
    override func pushViewController(viewController: UIViewController, animated: Bool) {
    
        if animated{
            //图像数组中存放一个当前页面图像，然后再push
            self.screenShotsList.addObject(self.ViewRenderImage())
            if self.viewControllers.count>0{
                self.checkBackgroudViewExist()
                self.addLastScreenShotView()
                
                blackMask!.alpha=0
                
                var toView:UIView=viewController.view
                self.view.addSubview(toView)
                
                var frame:CGRect=self.view.frame
                frame.origin.x=CGFloat(self.SCREEN_VIEW_WIDTH)
                self.view.frame=frame
                
                UIView.animateWithDuration(NSTimeInterval(kDurationTime), animations: {
                
                    self.moveViewWithX(0)
                    
                    }, completion: {finished in
                   super.pushViewController(viewController, animated: false)
                })
            }else{
               super.pushViewController(viewController, animated: false)
            }
        }else{
             super.pushViewController(viewController, animated: false)
        }
    
    }
    
    func gesturePopViewControllerAnimated(animated:Bool)->UIViewController?{
     
        self.screenShotsList.removeLastObject()
        return super.popViewControllerAnimated(animated)
    
    }
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        var popVC:AnyObject?=nil
        if animated{
            self.checkBackgroudViewExist()
            self.addLastScreenShotView()
            //先缩放
            lastScreenShotView!.transform=CGAffineTransformMakeScale(CGFloat(kScaleValue), CGFloat(kScaleValue))
            UIView.animateWithDuration(NSTimeInterval(kDurationTime), animations: {
                self.moveViewWithX(self.SCREEN_VIEW_WIDTH)
                }, completion: {finished in
                    super.popViewControllerAnimated(false)
                    var frame:CGRect=self.view.frame
                    frame.origin.x=0
                    self.view.frame=frame
                    self.backgroundView!.hidden=true;
                    self.screenShotsList.removeLastObject()
            })
            var viewcontrol=self.viewControllers as NSArray
            popVC=viewcontrol.lastObject
            
        }else{
             popVC=super.popViewControllerAnimated(false)!
        
        }
        return (popVC as! UIViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
