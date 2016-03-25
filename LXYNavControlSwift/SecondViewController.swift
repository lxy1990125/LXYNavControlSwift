//
//  SecondViewController.swift
//  LXYNavControlSwift
//
//  Created by 李 欣耘 on 15/7/30.
//  Copyright (c) 2015年 LXY. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.yellowColor()
        let lable=UILabel(frame: CGRectMake(50, 100, 300, 20))
        lable.text="Slide self to the right to back"
        self.view.addSubview(lable)
        
        // Do any additional setup after loading the view.
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
