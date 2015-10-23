//
//  HttpController.swift
//  douban
//
//  Created by 翁嘉升 on 2015/6/10.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import Foundation
import Alamofire

protocol HttpProtocol {
    func didReceiving(result:NSDictionary)
}

class HttpController: NSObject {
    var delegate:HttpProtocol?

//    func onSearch(url:String) {
//        Alamofire.request(.GET, url).responseJSON() {
//            (_, _, data, _) in
//            if let datasource = data as? NSDictionary{
//                self.delegate?.didReceiving(datasource)
//            }
//        }
    
        func onSearch(url:String) {
            Alamofire.request(.GET, url).responseJSON() {
                response in
                if let datasource = response.result.value as? NSDictionary{
                    self.delegate?.didReceiving(datasource)
                }
            }
        
    }
    

    
}