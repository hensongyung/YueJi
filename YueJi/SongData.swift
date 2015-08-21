//
//  SongData.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/8/18.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import RealmSwift

class SongData: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var url = ""
    dynamic var title = ""
    dynamic var picture = ""
    dynamic var artist = ""
    dynamic var discription = ""
    dynamic var createdTime = ""
}
