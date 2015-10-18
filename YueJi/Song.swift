//
//  Song.swift
//  douban
//
//  Created by 翁嘉升 on 2015/6/11.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import Foundation
class Song {
    var url = ""
    var title = ""
    var picture = ""
    var artist = ""
    var length = ""
    var like = false
    var public_time = ""
    
    init(url:String,picture:String,title:String,artist:String,length:Int,public_time:String){
        self.url = url
        self.artist = artist
//        self.length = length
        self.public_time = public_time
        self.title = title
        var s = ""
        
        if (length > 0){
            let ss = length % 60
            let s = ss<10 ?"0"+"\(ss)":"\(ss)"
        let min = length / 60
            self.length = "\(min):\(s)"
        }
    }
}

