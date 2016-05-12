//
//  BookmarkViewController.swift
//  H-1B
//
//  Created by Bond Wong on 12/28/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

var bookmarklist: [String: [String: AnyObject]] = {
    guard let jsonStr = NSUserDefaults.standardUserDefaults().objectForKey("bookmark") as? String else {
        return [:]
    }
    
    guard let jsonData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding) else {
        return [:]
    }
    
    do {
        guard let bookmark = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [String: [String: AnyObject]]else {
            return [:]
        }
        
        return bookmark
    } catch let e as NSError{
        print(e.localizedDescription)
        return [:]
    }
    
}()

class BookmarkViewController: UINavigationController, LocalDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let data: CollectionResult = getData() as! CollectionResult
        
        let vc:RecordsViewController =  self.viewControllers.first as! RecordsViewController
        vc.module = .BOOKMARK
        vc.delegate = self
        vc.data = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() -> AnyObject {
        let data: CollectionResult = CollectionResult()
        data.hasNext = false
        data.pageNum = 0
        data.pageSize = bookmarklist.count
        
        var positions = [Position]()
        for element in bookmarklist.values {
            positions.append(createPosition(element))
        }
        
        data.positions = positions
        
        return data
    }
    
    func synchronize() {
        do {
            let jsonBookmarklist = try NSJSONSerialization.dataWithJSONObject(bookmarklist, options: [])
            let bookmarkListJsonString = NSString(data: jsonBookmarklist, encoding: NSUTF8StringEncoding)
            
            NSUserDefaults.standardUserDefaults().setValue(bookmarkListJsonString, forKey: "bookmark")
            NSUserDefaults.standardUserDefaults().synchronize()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/

}
