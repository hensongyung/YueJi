//
//  SongParser.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/6/18.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import Foundation
import UIKit

class SongParser: NSObject, NSXMLParserDelegate{
    private var songItems:[(encode:String,decode:String,lrcid:String)] = []
    
    private var currentElement = ""
    private var currentEncode:String = "" {
        didSet {
            currentEncode = currentEncode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    private var currentDecode:String = "" {
        didSet {
            currentDecode = currentDecode.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    private var currentLrcid:String = "" {
        didSet {
            currentLrcid = currentLrcid.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
    }
    
    private var parser: NSXMLParser!
    private var parserCompletionHandler:([(encode: String, decode: String, lrcid: String)] -> Void)?
    
    func parseFeed(feedUrl: String, completionHandler: ([(encode: String, decode: String, lrcid: String)] -> Void)?) -> Void {
        
        self.parserCompletionHandler = completionHandler
        
        let request = NSURLRequest(URL: NSURL(string: feedUrl)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            
            // Parse XML data
            self.parser = NSXMLParser(data: data!)
            self.parser.delegate = self
            self.parser.parse()
            
        })
        
        task.resume()
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
        songItems = []
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        self.parserCompletionHandler?(songItems)
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
        
        if currentElement == "url" {
            currentEncode = ""
            currentDecode = ""
            currentLrcid = ""
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "url" {
            let songItem = (encode: currentEncode, decode: currentDecode, lrcid: currentLrcid)
            songItems += [songItem]
        }
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        switch currentElement {
        case "encode": currentEncode += string!
        case "decode": currentDecode += string!
        case "lrcid": currentLrcid += string!
        default: break
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print(parseError.localizedDescription)
    }
    
    
}