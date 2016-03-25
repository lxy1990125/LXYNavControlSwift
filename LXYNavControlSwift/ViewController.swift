//
//  ViewController.swift
//  LXYNavControlSwift
//
//  Created by 李 欣耘 on 15/7/28.
//  Copyright (c) 2015年 LXY. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor=UIColor.greenColor()

        let action=UIButton(frame: CGRectMake(100, 100, 60, 30))
        action.backgroundColor=UIColor.whiteColor()
        action.setTitle("Push", forState: UIControlState.Normal)
        action.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        action.addTarget(self, action:"ak", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(action)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func ak(){
        let sedView=SecondViewController();
        self.navigationController!.pushViewController(sedView, animated: true)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

