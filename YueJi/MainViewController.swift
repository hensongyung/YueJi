//
//  ViewController.swift
//  douban
//
//  Created by 翁嘉升 on 2015/6/10.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit
import MediaPlayer
//import QuartzCore
import Alamofire
import Haneke

var commonChannelData = []

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HttpProtocol,ChannelProtocol {
    
    @IBOutlet weak var songTableView: UITableView!
    
    
    let cache = Shared.imageCache
    
    var songs:[Song] = []
    
    var eHttp = HttpController()
    
    @IBOutlet var tap: UITapGestureRecognizer! = nil
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        
        if sender.view == btnPlay {
            btnPlay.hidden = true
            audioPlay.play()
            btnPlay.removeGestureRecognizer(tap)
            iv.addGestureRecognizer(tap)
        }else if sender.view == iv{
            btnPlay.hidden = false
            audioPlay.pause()
            iv.removeGestureRecognizer(tap)
            btnPlay.addGestureRecognizer(tap)
        }
    }

    @IBOutlet weak var btnPlay: UIImageView!
    

    var timer:NSTimer?
    var tableData  = NSArray()
    var channelData = NSArray(){
        didSet{
            ChannelDataSource.channelDataSource = channelData
        }
    }
    var imageCache = [:]
    
    var audioPlay = MPMoviePlayerController()
    
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var playtime: UILabel!
    
    @IBOutlet weak var tv: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        eHttp.onSearch("http://douban.fm/j/mine/playlist?channel=0")
        iv.addGestureRecognizer(tap!)
        iv.image = UIImage(named:"music")
        songTableView.estimatedRowHeight = 60
        songTableView.rowHeight = UITableViewAutomaticDimension
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableData.count
        
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "douban")
//        let rowData = self.tableData[indexPath.row] as! NSDictionary
//        cell.textLabel?.text = rowData["title"] as? String
//        cell.detailTextLabel?.text = rowData["artist"] as? String
//        
//        cell.imageView?.image = UIImage(named: "lsb")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("douban", forIndexPath: indexPath) as! SongTableViewCell
        let rowData = self.tableData[indexPath.row] as! NSDictionary
//        cell.textLabel?.text = rowData["title"] as? String
//        cell.detailTextLabel?.text = rowData["artist"] as? String
        
        
        var song = songs[indexPath.row]
        cell.artistLabel.text = song.artist
        cell.titleLabel.text = song.title
        
        cell.yearLabel.text = song.public_time
        cell.timeLabel.text = song.length
        cell.pictureImage.image = UIImage(named: "music")
        
        
        
//        cell.pictureImage.layer.cornerRadius = cell.pictureImage.frame.size.width / 2
//        cell.pictureImage.clipsToBounds = true
        
//        dispatch_async(dispatch_get_main_queue(), {
//        cell.imageView?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: rowData["picture"] as! String)!)!)
//        })
        
//        Alamofire.request(.GET, song.picture).response() {
//            (_, _, data, _) in
//            let image = UIImage(data: data! as! NSData)
//            cell.pictureImage.image = image
//        }
        
        cell.pictureImage.hnk_setImageFromURL(NSURL(string: song.picture)!)
        
        
        return cell
    }
    
    var lastIndex = 0
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if lastIndex != indexPath.row {
            let rowData = tableData[indexPath.row] as! NSDictionary
            let audioUrl = rowData["url"] as! String
            onSetAudio(audioUrl)
            
            Alamofire.request(.GET, rowData["picture"] as! String).response() {
                (_, _, data, _) in
                self.iv.image = UIImage(data: data! as! NSData)
                
            }
            
//            if let cell  = tableView.cellForRowAtIndexPath(indexPath) as? SongTableViewCell{
//                cell.titleLabel.sizeToFit()
//                var frame = cell.titleLabel.frame
//                frame.origin.x = cell.frame.width
//                cell.titleLabel.frame = frame
//                
//                UIView.beginAnimations("testAnimation", context: nil)
//                UIView.setAnimationDuration(5)
//                UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
//                UIView.setAnimationDelegate(self)
//                UIView.setAnimationRepeatAutoreverses(false)
//                UIView.setAnimationRepeatCount(2)
//                
//                frame = cell.titleLabel.frame
//                frame.origin.x = -frame.size.width
//                cell.titleLabel.frame = frame
//                UIView.commitAnimations()
//                
//            }
            
            
            lastIndex = indexPath.row
        }else{
            switch audioPlay.playbackState{
            case .Playing:
                audioPlay.pause()
                self.btnPlay.hidden = false
            case .Paused:
                audioPlay.play()
                self.btnPlay.hidden = true
            default :
                break
            }
        }
        

        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
        
        
    }
    
    
    
    func didReceiving(result: NSDictionary) {
        if let songsArray = result["song"] as? NSArray {
            self.tableData = songsArray
            self.tv.reloadData()
            
            songs = []
            for songInfo in songsArray{
                var song = Song(url: "", picture: "", title:"",artist: "", length: songInfo["length"] as! Int,  public_time: "1976")
                song.url = songInfo["url"] as! String
                song.picture = songInfo["picture"] as! String
                
                song.artist = songInfo["artist"] as! String
                if let public_time = songInfo["public_time"] as? String{
                    song.public_time = public_time
                }
                song.title = songInfo["title"] as! String
                songs.append(song)
            }
            
            let firDict = self.tableData[0] as! NSDictionary
            let audioUrl = firDict["url"] as! String
            let image = firDict["picture"] as! String
            Alamofire.request(.GET, image).response() {
                (_, _, data, _) in
                let image = UIImage(data: data! as! NSData)
                self.iv.image = image
            }
            
            onSetAudio(audioUrl)
            
        }else if let channel = result["channels"] as? NSArray{
            self.channelData = channel
        }
        
    }
    
    
    func onSetAudio(url:String){
        timer?.invalidate()
        playtime.text = "00:00"
        self.audioPlay.stop()
        self.audioPlay.contentURL = NSURL(string: url)
        self.audioPlay.play()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        
        
        
        
    }
    
    func onUpdate(){
        let c = audioPlay.currentPlaybackTime
        if c > 0 {
            let t = audioPlay.duration
            let p = CFloat(c / t)
            progressView.setProgress(p, animated: true)
            
            let all = Int(c)
            var time = ""
            let s = all % 60
            let m = all / 60
            
            
            if s < 10 {
                time = "\(m):0\(s)"
            }else if s < 60  {
                time = "\(m):\(s)"
            }
            
            self.playtime.text = time
        }
       

        
        
    }
    
    func onSetImage(url:String) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        lastIndex = 0
        var channel = segue.destinationViewController as!  ChanelViewController
        channel.delegate = self
        channel.channelData = self.channelData
        channel.imageFile = self.iv.image!
    }
    
    func onChangeChannel(channelId:String){
        let url = "http://douban.fm/j/mine/playlist?\(channelId)"
        eHttp.onSearch(url)
    }
    
    
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
}

