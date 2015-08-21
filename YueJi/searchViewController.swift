//
//  ViewController.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/6/18.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit
import Alamofire
import MediaPlayer


class searchViewController: UIViewController,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate {
    
    var searchController:UISearchController!
    
    
    var songUrls:[String] = []
    
    @IBOutlet weak var table: UITableView!
    
    var audioPlay = MPMoviePlayerController()
    
    var songItems:[(encode: String, decode: String, lrcid: String)] = []
    var songName = ""{
        didSet{
            songName = songName.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            parserUrl(songName)
        }
    }
    
    
    var searchKeyStr = "一生中最爱"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        table.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
//        parserUrl(searchStr)
        parserUrl(searchKeyStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        
        table.tableFooterView = UIView.new()
        
    }
    
    
    func parserUrl(songName:String){
        self.songUrls = []
        let feedParser = SongParser()
        feedParser.parseFeed("http://box.zhangmen.baidu.com/x?op=12&count=1&title=\(songName)$$", completionHandler: { (songItems: [(encode: String, decode: String, lrcid: String)]) -> Void in
        
        self.songItems = songItems
//        println(songItems)
        for song in songItems {
            if let nameMatch = song.encode.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch){
            let encodeurl = song.encode.substringToIndex(nameMatch.startIndex)
            var url = encodeurl + "/" + song.decode
            self.songUrls  += [url]
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.table.reloadData()
                })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return songItems.count
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        if songItems.count > indexPath.row {
//            cell.textLabel?.text = songItems[indexPath.row].lrcid
            cell.textLabel?.text =  "\(indexPath.row + 1)" + searchKeyStr
            return cell
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if songUrls.count > indexPath.row{
           onSetAudio(songUrls[indexPath.row])
        }
        
    }
    
    
    var timer:NSTimer?
    
    func onSetAudio(url:String){
        timer?.invalidate()
        self.audioPlay.stop()
        self.audioPlay.contentURL = NSURL(string: url)
        self.audioPlay.play()

    }
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
//        songName = searchController.searchBar.text
//        parserUrl(songName)
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
            searchKeyStr = searchBar.text
            parserUrl(searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
    }
    
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
}

