//
//  ViewController.swift
//  walkThroughDemo
//
//  Created by 翁嘉升 on 2015/6/22.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit

class PageContent1ViewController: UIViewController {
    var index = 0
    
    @IBOutlet weak var textImage: UIImageView!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var earphoneImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        headImage.transform = CGAffineTransformMakeScale(0.0, 0.0)
        earphoneImage.transform = CGAffineTransformMakeScale(0.0, 0.0)
        headImage.alpha = 0
        earphoneImage.alpha = 0
        textImage.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1, delay: 0, options: nil, animations: {
            self.textImage.alpha = 1
        }, completion: nil)
        
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.6,initialSpringVelocity:0.5,options: nil, animations: {
            self.headImage.alpha = 1
            self.headImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 2,usingSpringWithDamping: 0.6,initialSpringVelocity:0.5, options: nil, animations: {
            self.earphoneImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.earphoneImage.alpha = 1
            }, completion: nil)
    }
    
}

