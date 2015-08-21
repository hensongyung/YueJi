//
//  searchDetailViewController.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/8/21.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit

class searchDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var takePictureImage: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var detailTextField: UITextView!
    

    @IBAction func takePicture(sender: UITapGestureRecognizer) {
        let optionMenu = UIAlertController(title: nil, message: "请选择照片", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let takeLibraryPhotoAction = UIAlertAction(title: "从相册中选择", style: .Default) { (action:UIAlertAction!) -> Void in
            //先检查是否可用
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                let imagePicker  = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .PhotoLibrary
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        let takeCameraAction = UIAlertAction(title: "拍照", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera){
                let imagePicker = UIImagePickerController()
                //immediately after declaring imagePicker
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else{
                println("can't use camera")
            }
        })
        
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(takeLibraryPhotoAction)
        optionMenu.addAction(takeCameraAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        takePictureImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        takePictureImage.contentMode = UIViewContentMode.ScaleAspectFill
        takePictureImage.clipsToBounds = true
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
