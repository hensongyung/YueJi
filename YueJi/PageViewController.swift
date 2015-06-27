//
//  PageViewController.swift
//  walkThroughDemo
//
//  Created by 翁嘉升 on 2015/6/22.
//  Copyright (c) 2015年 翁嘉升. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController,UIPageViewControllerDataSource {
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        dataSource = self
        if let startingViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContent3ViewController") as? UIViewController{
            setViewControllers([startingViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            index++
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
//        var index = (viewController as! PageContent1ViewController).index
//        index--
//        return viewControllerAtIndex(index)
        switch index{
        case 0:
            if let page3Content = storyboard?.instantiateViewControllerWithIdentifier("PageContent3ViewController") as? UIViewController{
            
                return page3Content
            }
            
        case 1:
            if let page1Content = storyboard?.instantiateViewControllerWithIdentifier("PageContent1ViewController") as? PageContent1ViewController{
                
                return page1Content
            }
            
        case 2:
            if let page2Content = storyboard?.instantiateViewControllerWithIdentifier("PageContent2ViewController") as? PageContent2ViewController {
                
                return page2Content
                
            }
        
        default:
            break
            
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?{
//        var index = (viewController as! PageContent1ViewController).index
//        index++
//        return viewControllerAtIndex(index)
//        if let pageContent = viewController as? PageContent1ViewController{
//            return pageContent
//            
//        }
        
        
        switch index{
        case 0:
            if let page3Content = storyboard?.instantiateViewControllerWithIdentifier("PageContent3ViewController") as? UIViewController{
                index++
                return page3Content
            }
            
        case 1:
            if let page1Content = storyboard?.instantiateViewControllerWithIdentifier("PageContent1ViewController") as? PageContent1ViewController{
                index++
                return page1Content
            }
            
        case 2:
            if let page2Content = storyboard?.instantiateViewControllerWithIdentifier("PageContent2ViewController") as? PageContent2ViewController {
                return page2Content
            }
            
        default:
            break
            
        }
        return nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let PageContent1ViewController = storyboard?.instantiateViewControllerWithIdentifier("PageContent1ViewController") as? PageContent1ViewController{
            return PageContent1ViewController.index
        }
        
        return 0
        
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
