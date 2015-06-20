//
//  ChanelViewController.swift
//  douban
//
//  Created by 翁嘉升 on 2015/6/10.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit

protocol ChannelProtocol{
    func onChangeChannel(channelId:String)
}

class ChanelViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var channelData = []
    var delegate:ChannelProtocol?
    var imageFile = UIImage(named: "music")
    
    
    @IBOutlet weak var channelCell: UITableView!
    @IBOutlet weak var channelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        channelTableView.backgroundView = UIImageView(image: imageFile)
        
        channelData = ChannelDataSource.channelDataSource
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return channelData.count
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("channel", forIndexPath: indexPath) as! UITableViewCell
        let rowData = channelData[indexPath.row] as! NSDictionary
//        let rowDataq = channelData[indexPath.row] as! [AnyObject]
        
        cell.textLabel?.text = rowData["name"] as? String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var rowData = channelData[indexPath.row] as! NSDictionary
        let channelId: AnyObject! = rowData["channel_id"] as AnyObject!
        let channel = "channel=\(channelId)"
        delegate?.onChangeChannel(channel)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
//        UIView.animateWithDuration(0.25, animations: { () -> Void in
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
//        })
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.6,initialSpringVelocity:0.5,options: nil, animations: {
            //把窗口变成原来的大小
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)},
            completion: nil)
    }
    


//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//
//    }
//    

}
