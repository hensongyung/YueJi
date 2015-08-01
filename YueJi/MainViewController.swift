//
//  ViewController.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/6/10.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit
import MediaPlayer
//import QuartzCore
import Alamofire
//import AVFoundation
import Kingfisher
import iCarousel

class MainViewController: UIViewController,HttpProtocol,ChannelProtocol,UIPopoverPresentationControllerDelegate, iCarouselDataSource,iCarouselDelegate {
    
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
    var channelData = NSArray()
    var audioPlay = MPMoviePlayerController()
    
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet var cdImage: EkoImage!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var playtime: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eHttp.delegate = self
        iv.addGestureRecognizer(tap!)
        iv.image = UIImage(named:"music")
        cdImage.image = UIImage(named: "music")
        
//        songTableView.estimatedRowHeight = 60
//        songTableView.rowHeight = UITableViewAutomaticDimension
        
        carsousel.type = iCarouselType.CoverFlow
//        let size = carsousel.bounds
//        let image = UIImageView(frame: size)
//        image.image = UIImage(named: "background")
//        carsousel.addSubview(image)
    
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "loadMain", userInfo: nil, repeats: false)
    }

    func loadMain(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("hasViewWalkthrough") == false {
            
            //设置引导页
            if let pageViewContrller = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController{
                //We just create the PageViewController and present it in a modal way
                if let pageDelegate = storyboard?.instantiateViewControllerWithIdentifier("PageContent2ViewController") as? PageContent2ViewController{
//                    pageDelegate.delegate = self
//                    pageDelegate.didReceiving()
                    
                    self.presentViewController(pageViewContrller, animated: true, completion: {self.loadData()})
                }
                
                
            }
        }else{
            loadData()
        }
    }
    
    
    
    func loadData(){
        
        // Do any additional setup after loading the view, typically from a nib.
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        eHttp.onSearch("http://douban.fm/j/mine/playlist?channel=0")
        
    }
    
    
    func walkthroughDidFinish() {
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func didReceiving(result: NSDictionary) {
        if let songsArray = result["song"] as? NSArray {
            self.tableData = songsArray
            
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
            
            self.carsousel.reloadData()
            
            let firDict = self.tableData[0] as! NSDictionary
            let audioUrl = firDict["url"] as! String
            let image = firDict["picture"] as! String
            Alamofire.request(.GET, image).response() {
                (_, _, data, _) in
                let image = UIImage(data: data! as NSData)
                self.iv.image = image
                self.cdImage.image = image
                self.cdImage.onRotacion()
            }
            
            onSetAudio(audioUrl)
            
        }else if let channel = result["channels"] as? NSArray{
            self.channelData = channel
        }
        
    }
    
    
    func onSetAudio(url:String){
        timer?.invalidate()
        playtime.text = "0:00"
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
    

    var lastIndex = 0
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        lastIndex = 0
//        var channel = segue.destinationViewController as!  ChanelViewController
//        channel.delegate = self
//        channel.channelData = self.channelData
//        channel.imageFile = self.iv.image!
        
        if let channel = segue.destinationViewController as? ChanelViewController{
            if let pop =  channel.popoverPresentationController {
                pop.delegate = self
            }
            channel.delegate = self
            channel.channelData = self.channelData
            channel.imageFile = self.iv.image!
            
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
    func onChangeChannel(channelId:String){
        let url = "http://douban.fm/j/mine/playlist?\(channelId)"
        eHttp.onSearch(url)
    }
    
    
    @IBAction func close(segue:UIStoryboardSegue) {
        
    }
    
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        
        return songs.count
    }
    
    

    @IBOutlet var carsousel: iCarousel!
    
    var imageView: UIImageView!
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView!
    {
        
        var song = songs[index]
        var label: UILabel! = nil
        var newView = view
        //create new view if no view is available for recycling
        if (newView == nil)
        {
            let height = carsousel.bounds.height - 10
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            newView = UIImageView(frame:CGRectMake(0, 0, height, height))
            imageView = UIImageView(frame: newView.bounds)
            
            imageView.image = UIImage(named: "music")
//            imageView.hnk_setImageFromURL(NSURL(string: song.picture)!)
            imageView.kf_setImageWithURL(NSURL(string: song.picture)!)
            //            imageView.layer.cornerRadius = carouselSize
            
            imageView.layer.masksToBounds = true
            
            
            
            /*Change content mode to fit the Image*/
            imageView.contentMode = .ScaleToFill
            
            newView.addSubview(imageView)
            
            //(newView as! ReflectionView!).image = UIImage(named: "page.png")
            newView.contentMode = .Center
            
            
            // Not used as far of now - will be sued if u want to display bale in carousel
            
//            label = UILabel(frame:newView.bounds)
            label = UILabel(frame: CGRect(x: 0, y: 0, width: newView.bounds.width, height: 20))
            
//            label.frame.origin.y = -50
            label.numberOfLines = 2
            label.backgroundColor = UIColor.clearColor()
            
            label.textAlignment = .Center
            
//            label.font = label.font.fontWithSize(18)
            label.font = UIFont.boldSystemFontOfSize(18)
            
            label.textColor = UIColor.blueColor()
            
            label.tag = 1
            
            newView.addSubview(label)
            
        }
        else
        {
            //get a reference to the label in the recycled view
            label = view.viewWithTag(1) as! UILabel!
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        //        label.text = "\(items[index])"
        label.text = song.title
        
        return newView
    }
    
    func carousel(carousel: iCarousel!, didSelectItemAtIndex index: Int){
        if lastIndex != index {
            let rowData = tableData[index] as! NSDictionary
            let audioUrl = rowData["url"] as! String
            onSetAudio(audioUrl)
            
            Alamofire.request(.GET, rowData["picture"] as! String).response() {
                (_, _, data, _) in
                self.iv.image = UIImage(data: data! as NSData)
                self.cdImage.image = UIImage(data: data! as NSData)
//                self.cdImage.layer.removeAllAnimations()
            }
            
            lastIndex = index
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
    
    
}

