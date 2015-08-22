//
//  searchDetailViewController.swift
//  YueJi
//
//  Created by 翁嘉升 on 2015/8/21.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit
import RealmSwift

class searchDetailViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
    var songData = SongData()
    
    let placeHolder = "Enter your feeling"
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
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
    
    
    
    @IBAction func saveBarButton(sender: UIBarButtonItem) {
        let createdTime = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMdd")
        
        
        songData.localPicture = UIImagePNGRepresentation(takePictureImage.image)
        songData.createdTime = dateFormatter.stringFromDate(createdTime)
        songData.detailFeeling = detailTextField.text
        let realm = Realm()
        realm.write { () -> Void in
            realm.add(self.songData)
            println("success")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        songNameLabel.text = songData.title
        
        detailTextField.layer.borderWidth = 1
        detailTextField.layer.cornerRadius = 6
        detailTextField.layer.masksToBounds = true
        
        
        detailTextField.text = placeHolder
        detailTextField.textAlignment = NSTextAlignment.Center
        detailTextField.font = UIFont.boldSystemFontOfSize(18)
        detailTextField.textColor = UIColor.lightGrayColor()
    
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        /**
        *  设置按下return 收起键盘
        */
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func keyboardWillHide(notification:NSNotification){
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.frame.origin.y += keyboardFrame.size.height
        })
    }
    
    func keyboardWillShow(notification:NSNotification){

        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.frame.origin.y -= keyboardFrame.size.height
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = nil
            textView.textAlignment = NSTextAlignment.Left
            textView.textColor = UIColor.blueColor()
        }
        
    }
    

    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGrayColor()
            
        }
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
