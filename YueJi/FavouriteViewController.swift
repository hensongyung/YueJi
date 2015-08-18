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

class FavouriteViewController: UIViewController,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDataSource,UITableViewDelegate {

    let song = Realm(path: Realm.defaultPath).objects(SongData)
    
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        println(song.valueForKey("url"))
        
        
        
        // Do any additional setup after loading the view.
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
        // A little trick for removing the cell separators
        self.tableView.tableFooterView = UIView.new()

        
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
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.tableView.reloadData()
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
        return 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("FavouriteCell") as! UITableViewCell
        cell.textLabel?.text = "lsb"
        return cell
        
    }
    
    private func populate(){
        
    }

}
