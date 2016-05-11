//
//  BookmarkViewController.swift
//  H-1B
//
//  Created by Bond Wong on 12/28/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

var bookmarklist: [CLong: [String: AnyObject]] = {
    if let bm:[CLong: [String: AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("bookmark") as? [CLong: [String: AnyObject]]{
        return bm
    } else {
        return [:]
    }
}()

class BookmarkViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let data: CollectionResult = CollectionResult()
        data.hasNext = false
        data.pageNum = 0
        data.pageSize = bookmarklist.count
        
        var positions = [Position]()
        for element in bookmarklist.values {
            positions.append(createPosition(element))
        }
        
        data.positions = positions
        
        let vc:RecordsViewController =  self.viewControllers.first as! RecordsViewController
        vc.module = .BOOKMARK
        vc.data = data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/

}
