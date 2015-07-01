//
//  PageContent2ViewController.swift
//  walkThroughDemo
//
//  Created by 翁嘉升 on 2015/6/24.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit
protocol walkthroughFinish{
    func walkthroughDidFinish()
}
class PageContent2ViewController: UIViewController {
    var delegate:walkthroughFinish?
    var timer:NSTimer?
    
    @IBOutlet weak var cdImage: UIImageView!
    
//    @IBAction func startImage(sender: UITapGestureRecognizer) {
////        UIView.animateWithDuration(1, animations: {
////            self.armImage.transform = CGAffineTransformMakeRotation(0.5)
////        })
//    }
    
    
    @IBOutlet weak var armImage: UIImageView!
    
    @IBAction func play(sender: UITapGestureRecognizer) {
        var rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotationAnimation.toValue  = M_2_PI
        rotationAnimation.duration = 0.2
        rotationAnimation.repeatCount = 1000
        rotationAnimation.cumulative = true
        
//        cdImage.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        
//            UIView.animateWithDuration(1, animations: {
//                self.armImage.transform = CGAffineTransformMakeRotation(0.3)
//            })
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.armImage.transform = CGAffineTransformMakeRotation(0.3)
            }) { (done:Bool) -> Void in
            self.cdImage.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        }
        UIView.animateWithDuration(0.7, delay: 3, options: nil, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeScale(3, 3)
            self.view.alpha = 0
            
            }, completion: {(done:Bool) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "hasViewWalkthrough")
                    
                })
                
        })

        
    }
    
    
    
    func didReceiving(){
        self.delegate?.walkthroughDidFinish()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.armImage.layer.anchorPoint.y = 0
        
        
//        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.Repeat, animations: {self.cdImage.transform = CGAffineTransformMakeRotation(360)}, completion: nil)
 

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
