//
//  FavouriteViewController.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/8/10.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RealmSwift
import Kingfisher
import MediaPlayer


class FavouriteViewController: UIViewController,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var audioPlay = MPMoviePlayerController()
    
//    let cache = KingfisherManager.sharedManager.cache
    
    let song = Realm(path: Realm.defaultPath).objects(SongData)
    
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView.new()
        
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "music")
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "目前没有收藏，赶紧去收藏吧"
        let attributes  = [NSFontAttributeName:UIFont.boldSystemFontOfSize(18.0),NSForegroundColorAttributeName:UIColor.darkGrayColor()]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return song.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FavouriteCell") as! FavouriteTableViewCell
    
        let inverse = self.song.count - 1 - indexPath.row
        if inverse  >= 0 {
            cell.titleLabel.text = song.valueForKey("title")![inverse] as? String
            cell.artistLabel.text = song.valueForKey("artist")![inverse] as? String
            cell.discriptionLabel.text = song.valueForKey("discription")![inverse] as? String
            cell.musicImage.kf_setImageWithURL(NSURL(string: song.valueForKey("picture")![inverse] as! String)!)
            cell.createTimeLabel.text = song.valueForKey("createdTime")![inverse] as? String
            return cell
        }else{
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete{
//           
//        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete") { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let deleteMenu = UIAlertController(title: "hello", message: "Are you sure to delete?", preferredStyle: UIAlertControllerStyle.Alert)
            let cancleAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.Cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "sure", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                
                let realm = Realm()
                realm.write({ () -> Void in
                    realm.delete(self.song[self.song.count - 1 - indexPath.row])
                })
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            deleteMenu.addAction(deleteAction)
            deleteMenu.addAction(cancleAction)
            self.presentViewController(deleteMenu, animated: true, completion: nil)
        }
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        onSetAudio((song.valueForKey("url")![indexPath.row] as? String)!)
    }
    

    
    func onSetAudio(url:String){
        self.audioPlay.contentURL = NSURL(string: url)
        self.audioPlay.play()
    }


}
