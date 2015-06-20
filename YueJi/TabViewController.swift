//
//  TabViewController.swift
//  douban
//
//  Created by 翁嘉升 on 2015/6/12.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let selecView = selectedViewController{
//            if let chennleView = selecView as? ChanelViewController{
//                ViewController().delegate = chennleView
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println(sender)
        println(segue)
    }
    

}
