//
//  MainBackgroundImage.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/7/24.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit

class MainBackgroundImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView =  UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
//        println(blurEffectView.frame)
//        println(self.frame)
//        println(self.bounds)
        self.addSubview(blurEffectView)
        
    }
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
