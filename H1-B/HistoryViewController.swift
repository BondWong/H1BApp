//
//  HistoryViewController.swift
//  H-1B
//
//  Created by Bond Wong on 12/31/15.
//  Copyright © 2015 Bond Wong. All rights reserved.
//

import UIKit

var history: [AnyObject] = {
    if let his:[AnyObject] = NSUserDefaults.standardUserDefaults().arrayForKey("history") {
        return his
    } else {
        return []
    }
}()

class HistoryViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var data: [String: AnyObject] = [:]
        data["pageNum"] = 1;
        data["pageSize"] = 50
        data["hasNext"] = false
        data["elements"] = history
        let vc = self.viewControllers.first as! RecordsViewController
        vc.module = Module.HISTORY
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
    }
    */

}
