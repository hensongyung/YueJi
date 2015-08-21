//
//  EkoImage.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/7/23.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit

class EkoImage: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.frame.size.width = UIScreen.mainScreen().bounds.height
//        self.frame.size.height = UIScreen.mainScreen().bounds.width
//        self.layer.bounds.size.width = UIScreen.mainScreen().bounds.width
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6).CGColor
        self.alpha = 0.9
        
        
        
    }
    
    
    
    
    func onRotacion(){
        var animation  = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = 20
        animation.repeatCount = 10000
        self.layer.addAnimation(animation, forKey: "onRotation")
        
    }
    
    func pauseLayer(){
        let pausedTime  =  layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
    }
    
    func resumeLayer(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    

}
